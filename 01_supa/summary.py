import os
import requests
import re
import numpy
from datetime import datetime, timezone
import torch
from transformers import BartForConditionalGeneration, BartTokenizer
from multiprocessing import Process, set_start_method
import multiprocessing
import time
import gc
import psycopg2

def create_conn_source(select_query):
    conn = None
    try:
        conn = psycopg2.connect(
            host="ep-purple-boat-77462220.ap-southeast-1.aws.neon.tech",
            database="neondb",
            user="gskchaitanya.gadde",
            password="aWO71xgmLjUv"
        )
        cur = conn.cursor()
        cur.execute(select_query)
        rows = cur.fetchall()
        return rows
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def update_conn_source(update_query):
    conn = None
    try:
        conn = psycopg2.connect(
            host="ep-purple-boat-77462220.ap-southeast-1.aws.neon.tech",
            database="neondb",
            user="gskchaitanya.gadde",
            password="aWO71xgmLjUv"
        )
        cur = conn.cursor()
        cur.execute(update_query)
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def insert_conn_source(insert_query, data):
    conn = None
    try:
        conn = psycopg2.connect(
            host="ep-purple-boat-77462220.ap-southeast-1.aws.neon.tech",
            database="neondb",
            user="gskchaitanya.gadde",
            password="aWO71xgmLjUv"
        )
        cur = conn.cursor()
        for item in data:
            #print(item)
            cur.execute(insert_query, item)
        conn.commit()
        cur.close()
        print("Data inserted successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def is_valid_timezone_format(published):
    try:
        # Attempt to parse the string
        date_format = "%a, %d %b %Y %H:%M:%S %z"
        date_object = datetime.strptime(published, date_format)

        hasura_timestamp = date_object.astimezone(timezone.utc).isoformat()
        return True, hasura_timestamp
    except ValueError:
        # If parsing fails, the string is not in the correct format
        return False, None

def check_date_format(date_string):
    try:
        datetime.strptime(date_string, '%Y-%m-%dT%H:%M:%S%z')
        return True
    except ValueError:
        return False

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = BartForConditionalGeneration.from_pretrained('facebook/bart-large-cnn').to(device)
tokenizer = BartTokenizer.from_pretrained('facebook/bart-large-cnn')

def summarize(text, maxSummarylength=500):
    # Encode the text and summarize
    inputs = tokenizer.encode("summarize: " +
                              text,
                              return_tensors="pt",
                              max_length=1024, truncation=True).to(device)
    summary_ids = model.generate(inputs, max_length=int(maxSummarylength),  # Cast to int
                                 min_length=int(maxSummarylength/2),
                                 length_penalty=10.0,
                                 num_beams=4, early_stopping=True)
    summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)
    return summary

def split_text_into_pieces(text,
                           max_tokens=900,
                           overlapPercent=10):
    # Tokenize the text
    tokens = tokenizer.tokenize(text)

    # Calculate the overlap in tokens
    overlap_tokens = int(max_tokens * overlapPercent / 100)

    # Split the tokens into chunks of size
    # max_tokens with overlap
    pieces = [tokens[i:i + max_tokens]
              for i in range(0, len(tokens),
                             max_tokens - overlap_tokens)]

    # Convert the token pieces back into text
    text_pieces = [tokenizer.decode(
        tokenizer.convert_tokens_to_ids(piece),
        skip_special_tokens=True) for piece in pieces]

    return text_pieces


def recursive_summarize(text, max_length=200, recursionLevel=0):
    recursionLevel=recursionLevel+1
    # print("######### Recursion level: ",
    #       recursionLevel,"\n\n######### ")
    tokens = tokenizer.tokenize(text)
    expectedCountOfChunks = len(tokens)/max_length
    max_length=int(len(tokens)/expectedCountOfChunks)+2

    # Break the text into pieces of max_length
    pieces = split_text_into_pieces(text, max_tokens=max_length)

    # print("Number of pieces: ", len(pieces))
    # Summarize each piece
    summaries=[]
    k=0
    for k in range(0, len(pieces)):
        piece=pieces[k]
        # print("****************************************************")
        # print("Piece:",(k+1)," out of ", len(pieces), "pieces")
        # print(piece, "\n")
        summary =summarize(piece, maxSummarylength=max_length/3*2)
        # print("SUMNMARY: ", summary)
        summaries.append(summary)
        # print("****************************************************")

    concatenated_summary = ' '.join(summaries)

    tokens = tokenizer.tokenize(concatenated_summary)

    if len(tokens) > max_length:
        # If the concatenated_summary is too long, repeat the process
        # print("############# GOING RECURSIVE ##############")
        return recursive_summarize(concatenated_summary,
                                   max_length=max_length,
                                   recursionLevel=recursionLevel)
    else:
      # Concatenate the summaries and summarize again
        final_summary=concatenated_summary
        if len(pieces)>1:
            final_summary = summarize(concatenated_summary,
                                  maxSummarylength=max_length)
        return final_summary

def summerizer(offset1):
  print(offset1)
  while True:
    articles_details = """
      SELECT
        a.id,
        a.title,
        a.summary,
        a.detail
      FROM
        synopse_articles.v_v6_article_word_count a
      where a.is_in_detail = 1
      and a.is_vectorized = 0
      and a.is_summerized = 0
      and a.total_count >= 300
      ORDER BY
        id DESC
      LIMIT 1 OFFSET """ + str(offset1) + """;
      """
    articles_details_output = create_conn_source(articles_details)
    if len(articles_details_output) == 0:
        break
    title = articles_details_output[0][1]
    summary = articles_details_output[0][2]
    description = articles_details_output[0][3]
    filled_prompt = title + "/n" + summary + "/n" + description
    summary = recursive_summarize(filled_prompt)
    print(summary)
    v1 = []
    v2 = []
    v2.append(articles_details_output[0][0])
    v2.append(summary)
    v1.append(tuple(v2))
    q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_summerized = 1
            WHERE id = """ + str(articles_details_output[0][0]) +""";"""
    update_conn_source(q1)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v1)

if __name__ == "__main__":
    # Define the list of arguments

    set_start_method('spawn', force=True)
    args = [ 180 , 190 , 200]

    # Create a list to hold the processes
    processes = []

    # Create and start a process for each argument
    for arg in args:
        process = multiprocessing.Process(target=summerizer, args=(arg,))
        processes.append(process)
        process.start()

    # Wait for all processes to finish
    for process in processes:
        process.join()
