%%file articles_main.py

import psycopg2
from psycopg2 import sql
import requests
import feedparser
from datetime import datetime, timezone, timedelta
import re
from multiprocessing import Process, set_start_method
import multiprocessing
import json
import re
import openai
import numpy
import spacy
import torch
from keybert import KeyBERT
from bertopic import BERTopic
import numpy as np
from sentence_transformers import SentenceTransformer
from transformers import MBartForConditionalGeneration, MBart50TokenizerFast
import time


endpoint = "https://active-monitor-48.hasura.app/v1/graphql"
admin_key = "bAQuK7HSYvMAp6S6pnqXH0wQlyuKNUICzoW3jwecc27pwz6COLhE750s5YAec7Hz"

def query_hasura_graphql(endpoint, admin_key, query, variables):
    headers = {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': f'{admin_key}'
    }

    data = {
        'query': query,
        'variables': variables
    }
    response = requests.post(endpoint, json=data, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        # print(f"Request failed with status code {response.status_code}")
        return None

def mutation_hasura_graphql(endpoint, admin_key, mutation_query, mutation_variables):
    headers = {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': f'{admin_key}'
    }
    response = requests.post(endpoint, json={'query': mutation_query, 'variables': mutation_variables}, headers=headers)
    if response.ok:
        data = response.json()
        # print(data)
        return True, data
    else:
        # print(f"Mutation failed with status code {response.status_code}: {response.text}")
        return False, None

def create_conn_source(select_query):
    conn = None
    try:
        conn = psycopg2.connect(
            host="35.244.20.53",
            database="neondb",
            user="gskchaitanya.gadde",
            password="aWO71xgmLjUv"
        )
        cur = conn.cursor()
        cur.execute(select_query)
        rows = cur.fetchall()
        cur.close()
        return rows
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def update_conn_source(update_query):
    conn = None
    try:
        conn = psycopg2.connect(
            host="35.244.20.53",
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
            host="35.244.20.53",
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
        # print("Data inserted successfully")
        return True
    except (Exception, psycopg2.DatabaseError) as error:
        # print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
        return False

def select_conn_destination(select_query):
    conn = None
    try:
        conn = psycopg2.connect(
            host="aws-0-ap-south-1.pooler.supabase.com",
            database="postgres",
            user="postgres.icrispjgfllulboelvhw",
            password="rJywtQ5R2Wt17hG1",
            port=6543
        )
        cur = conn.cursor()
        cur.execute(select_query)
        rows = cur.fetchall()
        cur.close()
        return rows
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def create_conn_destination(insert_query, data):
    conn = None

    try:
        conn = psycopg2.connect(
            host="aws-0-ap-south-1.pooler.supabase.com",
            database="postgres",
            user="postgres.icrispjgfllulboelvhw",
            password="rJywtQ5R2Wt17hG1",
            port=6543
        )
        cur = conn.cursor()
        for item in data:
            #print(item)
            cur.execute(insert_query, item)
        conn.commit()
        cur.close()
        # print("Data inserted successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def update_conn_destination(update_query):
    conn = None

    try:
        conn = psycopg2.connect(
            host="aws-0-ap-south-1.pooler.supabase.com",
            database="postgres",
            user="postgres.icrispjgfllulboelvhw",
            password="rJywtQ5R2Wt17hG1",
            port=6543
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

def extract_json(s):
    start = s.find('{')
    end = s.rfind('}') + 1  # +1 to include the '}' in the substring
    json_str = s[start:end]
    try:
        return json.loads(json_str)
    except json.JSONDecodeError:
        return None

def array2dto2d(n2):
    n1 = []
    for sublist in n2:
        for element in sublist:
            n1.append(element)
    n2 = list(set(n1))
    return n2

def suffix(d):
    return 'th' if 11<=d<=13 else {1:'st',2:'nd',3:'rd'}.get(d%10, 'th')

def get_part_of_day(hour):
    return (
        "Morning" if 5 <= hour <= 11
        else
        "Afternoon" if 12 <= hour <= 17
        else
        "Evening" if 18 <= hour <= 22
        else
        "Night"
    )

# get data from rss
def update_articles(outlet):
    print(outlet)
    articles_from_rss = """
    SELECT
        rss1_link,
        rss1_link_name,
        outlet,
        id,
        language,
        rss1_link_name
    FROM
        synopse_articles.t_v1_rss1_feed_links
    WHERE
        rss1_link_type = 11 AND
        outlet = '""" + outlet + """';
    """
    articles_l2_details_output = create_conn_source(articles_from_rss)
    for l1 in articles_l2_details_output:
        NewsFeed = feedparser.parse(l1[0])
        v1 = []
        for entry in NewsFeed.entries:
            post_link = entry.link
            title = entry.title
            summary = 'na'
            if 'summary' in entry:
                summary_nofil = entry.summary
                summary = re.sub('<[^<]+?>', '', summary_nofil)
            if l1[5] == "google link":
              title_none = ["- Eenadu", ]
              for t1 in title_none:
                if t1 in title:
                  title = title.replace(t1, "")
              # print(title)
              summary_none = [ "&nbsp;&nbsp;Eenadu",]
              for t1 in summary_none:
                if t1 in summary:
                  summary = summary.replace(t1, "")
              # print(summary)
            image_url = ""
            if 'media_content' in entry:
                try:
                    if entry['media_content']:
                        image_url = entry['media_content'][0]['url']
                except:
                    image_url = ''
            if 'links' in entry:
                for link in entry.links:
                    if link.type == "image/jpeg":
                        image_url= link.href
                        break
            published = datetime.now(timezone.utc).isoformat()
            if 'published' in entry:
                published = entry.published
            datevalidation = is_valid_timezone_format(published)
            if datevalidation[0]:
                hasura_timestamp = datevalidation[1]
                # print(hasura_timestamp)
                hasura_datetime = datetime.strptime(hasura_timestamp, "%Y-%m-%dT%H:%M:%S%z")

                now_datetime = datetime.now(timezone.utc)

                difference = hasura_datetime - now_datetime
                difference_in_hours =  - difference.total_seconds() / 3600
                if difference_in_hours > 24:
                  break
            if check_date_format(published):
                hasura_timestamp = published
            else:
                hasura_timestamp = datetime.now().astimezone(timezone.utc).isoformat()
            if "author" in entry:
                author = entry.author
            else:
                author = "na"
            tags = []
            tags.append(l1[1])
            tags.append(l1[2])
            if 'tags' in entry:
                for tag in entry.tags:
                    tags.append(tag.term)
            v2 = []
            v2.append(l1[3])
            v2.append(post_link)
            v2.append(title)
            v2.append(summary)
            v2.append(author)
            v2.append(image_url)
            v2.append(hasura_timestamp)
            v2.append(l1[4])
            v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles (rss1_feed_id, post_link, title, summary, author, image_link, post_published, language) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING;"

        insert_conn_source(v1_insert_query, v1)

#set all is in detail:
def set_all_in_detail(offset):
  print( "set_all_in_detail " + str(offset))
  query = """select a.id, a.title, a.summary, a.post_link,language
    from synopse_articles.t_v1_rss1_articles a
    where a.is_in_detail != 1
    limit 100 offset """ + str(offset) + """;
    """
  while True:
    articles_details_output = create_conn_source(query)
    if len(articles_details_output) == 0:
        break
    v1 = []
    ids = []
    for i in range(len(articles_details_output)):
        v2 = []
        v2.append(articles_details_output[i][0])
        v2.append(articles_details_output[i][1])
        v2.append(articles_details_output[i][2])
        v2.append(articles_details_output[i][3])
        v2.append(articles_details_output[i][4])
        v1.append(tuple(v2))
        ids.append(articles_details_output[i][0])
    # print(ids)
    if len(ids) > 1:
      ids_t = tuple(ids)
      q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_in_detail = 1
            WHERE id in {ids_t};"""
    else:
      ids_t = ids[0]
      q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
              SET is_in_detail = 1
              WHERE id = {ids_t};"""
    update_conn_source(q1)
    v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, title, detail, final_url, language) VALUES (%s, %s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v1)

def summerizer_under_300(offset):
    print( "summerizer_under_300 " + str(offset))
    i11 = - 1
    while True:
        i11 = i11 + 1
        articles_details = """
          SELECT
            a.id,
            a.title,
            a.summary,
            a.detail,
            a.language
          FROM
            synopse_articles.v_v6_article_word_count a
          where a.is_in_detail = 1
          and a.is_vectorized = 0
          and a.is_summerized = 0
          and a.total_count < 300
          ORDER BY id DESC
          LIMIT 200 OFFSET """ + str(i11*200 + offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        v1 = []
        ids = []
        for i in range(len(articles_details_output)):
            v2 = []
            v2.append(articles_details_output[i][0])
            t1 = ""
            s1 = ""
            s2 = ""
            try:
              if articles_details_output[i][1] is not None:
                t1 = articles_details_output[i][1]
            except:
              t1 = ""
            try:
              if articles_details_output[i][2] is not None:
                s1 = articles_details_output[i][2]
            except:
              s1 = ""
            try:
              if articles_details_output[i][3] is not None:
                s2 = articles_details_output[i][3]
            except:
              s2 = ""
            v2.append(t1 + " " + s1 + " " + s2)
            v2.append(articles_details_output[i][4])
            v1.append(tuple(v2))
            ids.append(articles_details_output[i][0])

        if len(ids) > 1:
            ids_t = tuple(ids)
            q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                    SET is_summerized = 1
                    WHERE id in {ids_t};"""
        else:
          ids_t = ids[0]
          q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                  SET is_summerized = 1
                  WHERE id = {ids_t};"""

        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary, language) VALUES (%s, %s, %s)  ON CONFLICT DO NOTHING;"
        insert_conn_source(v1_insert_query, v1)


# summerize
def summerizer_over_300(offset):
    print( "summerizer_over_300 " + str(offset))
    i11 = - 1
    while True:
        i11 = i11 + 1
        articles_details = """
          SELECT
            a.id,
            a.title,
            a.summary,
            a.detail,
            a.language
          FROM
            synopse_articles.v_v6_article_word_count a
          where a.is_in_detail = 1
          and a.is_vectorized = 0
          and a.is_summerized = 0
          and a.total_count >= 300
          ORDER BY id DESC
          LIMIT 200 OFFSET """ + str(i11*200 + offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        v1 = []
        ids = []
        for i in range(len(articles_details_output)):
            v2 = []
            v2.append(articles_details_output[i][0])
            t1 = ""
            s1 = ""
            s2 = ""
            try:
              if articles_details_output[i][1] is not None:
                t1 = articles_details_output[i][1]
            except:
              t1 = ""
            try:
              if articles_details_output[i][2] is not None:
                s1 = articles_details_output[i][2]
            except:
              s1 = ""
            try:
              if articles_details_output[i][3] is not None:
                s2 = articles_details_output[i][3]
            except:
              s2 = ""
            out11 = t1 + " " + s1 + " " + s2
            words = out11.split()
            v2.append(' '.join(words[:400]))
            v2.append(articles_details_output[i][4])
            v1.append(tuple(v2))
            ids.append(articles_details_output[i][0])

        if len(ids) > 1:
            ids_t = tuple(ids)
            q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                    SET is_summerized = 1
                    WHERE id in {ids_t};"""
        else:
          ids_t = ids[0]
          q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                  SET is_summerized = 1
                  WHERE id = {ids_t};"""

        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary, language) VALUES (%s, %s, %s)  ON CONFLICT DO NOTHING;"
        insert_conn_source(v1_insert_query, v1)

#set all in summerize:
def set_all_summerize(offset):
  print( "set_all_summerize " + str(offset))
  query = """select a.id, a.summary, a.language
    from synopse_articles.t_v1_rss1_articles a
    where a.is_summerized != 1
    limit 100 offset """ + str(offset) + """;
    """
  while True:
    articles_details_output = create_conn_source(query)
    if len(articles_details_output) == 0:
        break
    v1 = []
    ids = []
    for i in range(len(articles_details_output)):
        v2 = []
        v2.append(articles_details_output[i][0])
        words = articles_details_output[i][1].split()
        word_count = len(words)
        if word_count > 300:
            words = words[:300]
        limited_text = ' '.join(words)
        v2.append(limited_text)
        v2.append(articles_details_output[i][2])
        v1.append(tuple(v2))
        ids.append(articles_details_output[i][0])
    if len(ids) > 1:
        ids_t = tuple(ids)
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_summerized = 1
                WHERE id in {ids_t};"""
    else:
        ids_t = ids[0]
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_summerized = 1
            WHERE id = {ids_t};"""
    update_conn_source(q1)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary, language) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING;"
    insert_conn_source(v1_insert_query, v1)


def normalize_l2(x):
    x = np.array(x)
    if x.ndim == 1:
        norm = np.linalg.norm(x)
        if norm == 0:
            return x
        return x / norm
    else:
        norm = np.linalg.norm(x, 2, axis=1, keepdims=True)
        return np.where(norm == 0, x, x / norm)


def vectorize_en(offset1):
  print(offset1)
  esecret_ANYSCALE_API_KEY = "as"
  client = openai.OpenAI(
      api_key = esecret_ANYSCALE_API_KEY
  )
  tovetorize = f"""SELECT
    t_v1_rss1_articles.id,
    t_v1_rss1_articles.title,
    t_v1_rss1_articles.summary as s1,
    t_v2_articles_summary.summary as s2
FROM
    synopse_articles.t_v1_rss1_articles
LEFT JOIN
    synopse_articles.t_v2_articles_summary
ON
    t_v1_rss1_articles.id = t_v2_articles_summary.article_id
WHERE
    t_v1_rss1_articles.is_summerized = 1
AND
    t_v1_rss1_articles.is_vectorized = 0
AND
    t_v1_rss1_articles.language = 'en'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""
  while True:
    tovetorize_output = create_conn_source(tovetorize)
    if (len(tovetorize_output) == 0):
      break
    article_ids = []
    p1 = []
    for i in range(len(tovetorize_output)):
      article_ids.append(tovetorize_output[i][0])
      t1 = ""
      s1 = ""
      s2 = ""
      try:
        if tovetorize_output[i][1] is not None:
          t1 = tovetorize_output[i][1]
      except:
        t1 = ""
      try:
        if tovetorize_output[i][2] is not None:
          s1 = tovetorize_output[i][2]
      except:
        s1 = ""
      try:
        if tovetorize_output[i][3] is not None:
          s2 = tovetorize_output[i][3]
      except:
        s2 = ""
      p12 = t1 + "\n" + s1  + "\n" + s2
      response = client.embeddings.create(
          model="text-embedding-3-small", input=p12, encoding_format="float"
      )

      cut_dim = response.data[0].embedding[:1024]
      norm_dim = normalize_l2(cut_dim)

      v11 = []
      v11.append(tovetorize_output[i][0])
      v11.append(str(norm_dim.tolist()))
      v10.append(tuple(v11))

    v15 = tuple(v10)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_vectors (article_id, a_vector) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v15)

    if(len(article_ids) > 1):
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)
    if(len(article_ids) == 1):
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)


def vectorize_tel(offset1):
  print(offset1)
  esecret_ANYSCALE_API_KEY = "as"
  client = openai.OpenAI(
      api_key = esecret_ANYSCALE_API_KEY
  )
  tovetorize = f"""SELECT
    t_v1_rss1_articles.id,
    t_v1_rss1_articles.title,
    t_v1_rss1_articles.summary as s1,
    t_v2_articles_summary.summary as s2
FROM
    synopse_articles.t_v1_rss1_articles
LEFT JOIN
    synopse_articles.t_v2_articles_summary
ON
    t_v1_rss1_articles.id = t_v2_articles_summary.article_id
WHERE
    t_v1_rss1_articles.is_summerized = 1
AND
    t_v1_rss1_articles.is_vectorized = 0
AND
    t_v1_rss1_articles.language = 'tel'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""
  while True:
    tovetorize_output = create_conn_source(tovetorize)
    if (len(tovetorize_output) == 0):
      break
    article_ids = []
    p1 = []
    v10 = []
    for i in range(len(tovetorize_output)):
      article_ids.append(tovetorize_output[i][0])
      t1 = ""
      s1 = ""
      s2 = ""
      try:
        if tovetorize_output[i][1] is not None:
          t1 = tovetorize_output[i][1]
      except:
        t1 = ""
      try:
        if tovetorize_output[i][2] is not None:
          s1 = tovetorize_output[i][2]
      except:
        s1 = ""
      try:
        if tovetorize_output[i][3] is not None:
          s2 = tovetorize_output[i][3]
      except:
        s2 = ""
      p12 = t1 + "\n" + s1  + "\n" + s2
      response = client.embeddings.create(
          model="text-embedding-3-small", input=p12, encoding_format="float"
      )

      cut_dim = response.data[0].embedding[:786]
      norm_dim = normalize_l2(cut_dim)

      v11 = []
      v11.append(tovetorize_output[i][0])
      v11.append(str(norm_dim.tolist()))
      v10.append(tuple(v11))

    v15 = tuple(v10)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_vectors_tel (article_id, a_vector) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v15)

    if(len(article_ids) > 1):
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)
    if(len(article_ids) == 1):
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)

def vectorize_hin(offset1):
  print(offset1)
  esecret_ANYSCALE_API_KEY = "as"
  client = openai.OpenAI(
      api_key = esecret_ANYSCALE_API_KEY
  )
  tovetorize = f"""SELECT
    t_v1_rss1_articles.id,
    t_v1_rss1_articles.title,
    t_v1_rss1_articles.summary as s1,
    t_v2_articles_summary.summary as s2
FROM
    synopse_articles.t_v1_rss1_articles
LEFT JOIN
    synopse_articles.t_v2_articles_summary
ON
    t_v1_rss1_articles.id = t_v2_articles_summary.article_id
WHERE
    t_v1_rss1_articles.is_summerized = 1
AND
    t_v1_rss1_articles.is_vectorized = 0
AND
    t_v1_rss1_articles.language = 'hin'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""
  while True:
    tovetorize_output = create_conn_source(tovetorize)
    if (len(tovetorize_output) == 0):
      break
    article_ids = []
    p1 = []
    for i in range(len(tovetorize_output)):
      article_ids.append(tovetorize_output[i][0])
      t1 = ""
      s1 = ""
      s2 = ""
      try:
        if tovetorize_output[i][1] is not None:
          t1 = tovetorize_output[i][1]
      except:
        t1 = ""
      try:
        if tovetorize_output[i][2] is not None:
          s1 = tovetorize_output[i][2]
      except:
        s1 = ""
      try:
        if tovetorize_output[i][3] is not None:
          s2 = tovetorize_output[i][3]
      except:
        s2 = ""
      p12 = t1 + "\n" + s1  + "\n" + s2
      response = client.embeddings.create(
          model="text-embedding-3-small", input=p12, encoding_format="float"
      )

      cut_dim = response.data[0].embedding[:786]
      norm_dim = normalize_l2(cut_dim)

      v11 = []
      v11.append(tovetorize_output[i][0])
      v11.append(str(norm_dim.tolist()))
      v10.append(tuple(v11))

    v15 = tuple(v10)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_vectors_hin (article_id, a_vector) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v15)

    if(len(article_ids) > 1):
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)
    if(len(article_ids) == 1):
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)

def vectorize_tam(offset1):
  print(offset1)
  esecret_ANYSCALE_API_KEY = "as"
  client = openai.OpenAI(
      api_key = esecret_ANYSCALE_API_KEY
  )
  tovetorize = f"""SELECT
    t_v1_rss1_articles.id,
    t_v1_rss1_articles.title,
    t_v1_rss1_articles.summary as s1,
    t_v2_articles_summary.summary as s2
FROM
    synopse_articles.t_v1_rss1_articles
LEFT JOIN
    synopse_articles.t_v2_articles_summary
ON
    t_v1_rss1_articles.id = t_v2_articles_summary.article_id
WHERE
    t_v1_rss1_articles.is_summerized = 1
AND
    t_v1_rss1_articles.is_vectorized = 0
AND
    t_v1_rss1_articles.language = 'tam'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""
  while True:
    tovetorize_output = create_conn_source(tovetorize)
    if (len(tovetorize_output) == 0):
      break
    article_ids = []
    p1 = []
    for i in range(len(tovetorize_output)):
      article_ids.append(tovetorize_output[i][0])
      t1 = ""
      s1 = ""
      s2 = ""
      try:
        if tovetorize_output[i][1] is not None:
          t1 = tovetorize_output[i][1]
      except:
        t1 = ""
      try:
        if tovetorize_output[i][2] is not None:
          s1 = tovetorize_output[i][2]
      except:
        s1 = ""
      try:
        if tovetorize_output[i][3] is not None:
          s2 = tovetorize_output[i][3]
      except:
        s2 = ""
      p12 = t1 + "\n" + s1  + "\n" + s2
      response = client.embeddings.create(
          model="text-embedding-3-small", input=p12, encoding_format="float"
      )

      cut_dim = response.data[0].embedding[:786]
      norm_dim = normalize_l2(cut_dim)

      v11 = []
      v11.append(tovetorize_output[i][0])
      v11.append(str(norm_dim.tolist()))
      v10.append(tuple(v11))

    v15 = tuple(v10)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_vectors_tam (article_id, a_vector) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v15)

    if(len(article_ids) > 1):
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)
    if(len(article_ids) == 1):
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)


def vectorize_de(offset1):
  print(offset1)
  esecret_ANYSCALE_API_KEY = "as"
  client = openai.OpenAI(
      api_key = esecret_ANYSCALE_API_KEY
  )
  tovetorize = f"""SELECT
    t_v1_rss1_articles.id,
    t_v1_rss1_articles.title,
    t_v1_rss1_articles.summary as s1,
    t_v2_articles_summary.summary as s2
FROM
    synopse_articles.t_v1_rss1_articles
LEFT JOIN
    synopse_articles.t_v2_articles_summary
ON
    t_v1_rss1_articles.id = t_v2_articles_summary.article_id
WHERE
    t_v1_rss1_articles.is_summerized = 1
AND
    t_v1_rss1_articles.is_vectorized = 0
AND
    t_v1_rss1_articles.language = 'de'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""
  while True:
    tovetorize_output = create_conn_source(tovetorize)
    if (len(tovetorize_output) == 0):
      break
    article_ids = []
    p1 = []
    for i in range(len(tovetorize_output)):
      article_ids.append(tovetorize_output[i][0])
      t1 = ""
      s1 = ""
      s2 = ""
      try:
        if tovetorize_output[i][1] is not None:
          t1 = tovetorize_output[i][1]
      except:
        t1 = ""
      try:
        if tovetorize_output[i][2] is not None:
          s1 = tovetorize_output[i][2]
      except:
        s1 = ""
      try:
        if tovetorize_output[i][3] is not None:
          s2 = tovetorize_output[i][3]
      except:
        s2 = ""
      p12 = t1 + "\n" + s1  + "\n" + s2
      response = client.embeddings.create(
          model="text-embedding-3-small", input=p12, encoding_format="float"
      )

      cut_dim = response.data[0].embedding[:786]
      norm_dim = normalize_l2(cut_dim)

      v11 = []
      v11.append(tovetorize_output[i][0])
      v11.append(str(norm_dim.tolist()))
      v10.append(tuple(v11))

    v15 = tuple(v10)
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_vectors_de (article_id, a_vector) VALUES (%s, %s)"
    insert_conn_source(v1_insert_query, v15)

    if(len(article_ids) > 1):
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)
    if(len(article_ids) == 1):
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_vectorized = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)


def grouping_l1_en(offset1):
  print(offset1)
  l1 = f"""SELECT
    t_v1_rss1_articles.id
FROM
    synopse_articles.t_v1_rss1_articles
WHERE
    t_v1_rss1_articles.is_grouped = 0
AND
    t_v1_rss1_articles.is_vectorized = 1
AND
    t_v1_rss1_articles.language = 'en'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""

  while True:
    l1_output = create_conn_source(l1)
    if (len(l1_output) == 0):
      break
    article_ids = []
    v2 = []
    for i in range(len(l1_output)):
      article_ids.append(l1_output[i][0])
      v1 = []
      v1.append(l1_output[i][0])
      func_query = f"""
      SELECT
    f_get_similar_articles_l1.article_id
FROM
    synopse_articles.f_get_similar_articles_l1( """ +str(l1_output[i][0]) + """);"""
      func_query_output = create_conn_source(func_query)
      article_group = []
      if len(func_query_output) > 0:
          for func_response in range(len(func_query_output)):
              article_group.append(func_query_output[func_response][0])
      v1.append(article_group)
      v1.append(len(article_group))
      v1.append("en")
      v2.append(tuple(v1))
    v3=tuple(v2)
    v1_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l1 (article_id, initial_group, article_count, language) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v3)

    if len(article_ids) == 1:
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)
    else:
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id in " + str(t_ids) + ";"
      update_conn_source(update_query)

def grouping_l1_tel(offset1):
  print(offset1)
  l1 = f"""SELECT
    t_v1_rss1_articles.id
FROM
    synopse_articles.t_v1_rss1_articles
WHERE
    t_v1_rss1_articles.is_grouped = 0
AND
    t_v1_rss1_articles.is_vectorized = 1
AND
    t_v1_rss1_articles.language = 'tel'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""

  while True:
    l1_output = create_conn_source(l1)
    if (len(l1_output) == 0):
      break
    article_ids = []
    v2 = []
    for i in range(len(l1_output)):
      article_ids.append(l1_output[i][0])
      v1 = []
      v1.append(l1_output[i][0])
      func_query = f"""
      SELECT
    f_get_similar_articles_l1_tel.article_id
FROM
    synopse_articles.f_get_similar_articles_l1_tel( """ +str(l1_output[i][0]) + """);"""
      func_query_output = create_conn_source(func_query)
      article_group = []
      if len(func_query_output) > 0:
          for func_response in range(len(func_query_output)):
              article_group.append(func_query_output[func_response][0])
      v1.append(article_group)
      v1.append(len(article_group))
      v1.append("tel")
      v2.append(tuple(v1))
    v3=tuple(v2)
    v1_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l1 (article_id, initial_group, article_count, language) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v3)

    if len(article_ids) == 1:
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)
    else:
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id in " + str(t_ids) + ";"
      update_conn_source(update_query)

def grouping_l1_tam(offset1):
  print(offset1)
  l1 = f"""SELECT
    t_v1_rss1_articles.id
FROM
    synopse_articles.t_v1_rss1_articles
WHERE
    t_v1_rss1_articles.is_grouped = 0
AND
    t_v1_rss1_articles.is_vectorized = 1
AND
    t_v1_rss1_articles.language = 'tam'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""

  while True:
    l1_output = create_conn_source(l1)
    if (len(l1_output) == 0):
      break
    article_ids = []
    v2 = []
    for i in range(len(l1_output)):
      article_ids.append(l1_output[i][0])
      v1 = []
      v1.append(l1_output[i][0])
      func_query = f"""
      SELECT
    f_get_similar_articles_l1_tam.article_id
FROM
    synopse_articles.f_get_similar_articles_l1_tam( """ +str(l1_output[i][0]) + """);"""
      func_query_output = create_conn_source(func_query)
      article_group = []
      if len(func_query_output) > 0:
          for func_response in range(len(func_query_output)):
              article_group.append(func_query_output[func_response][0])
      v1.append(article_group)
      v1.append(len(article_group))
      v1.append("tam")
      v2.append(tuple(v1))
    v3=tuple(v2)
    v1_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l1 (article_id, initial_group, article_count, language) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v3)

    if len(article_ids) == 1:
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)
    else:
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id in " + str(t_ids) + ";"
      update_conn_source(update_query)

def grouping_l1_de(offset1):
  print(offset1)
  l1 = f"""SELECT
    t_v1_rss1_articles.id
FROM
    synopse_articles.t_v1_rss1_articles
WHERE
    t_v1_rss1_articles.is_grouped = 0
AND
    t_v1_rss1_articles.is_vectorized = 1
AND
    t_v1_rss1_articles.language = 'de'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""

  while True:
    l1_output = create_conn_source(l1)
    if (len(l1_output) == 0):
      break
    article_ids = []
    v2 = []
    for i in range(len(l1_output)):
      article_ids.append(l1_output[i][0])
      v1 = []
      v1.append(l1_output[i][0])
      func_query = f"""
      SELECT
    f_get_similar_articles_l1_de.article_id
FROM
    synopse_articles.f_get_similar_articles_l1_de( """ +str(l1_output[i][0]) + """);"""
      func_query_output = create_conn_source(func_query)
      article_group = []
      if len(func_query_output) > 0:
          for func_response in range(len(func_query_output)):
              article_group.append(func_query_output[func_response][0])
      v1.append(article_group)
      v1.append(len(article_group))
      v1.append("de")
      v2.append(tuple(v1))
    v3=tuple(v2)
    v1_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l1 (article_id, initial_group, article_count, language) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v3)

    if len(article_ids) == 1:
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)
    else:
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id in " + str(t_ids) + ";"
      update_conn_source(update_query)

def grouping_l1_hin(offset1):
  print(offset1)
  l1 = f"""SELECT
    t_v1_rss1_articles.id
FROM
    synopse_articles.t_v1_rss1_articles
WHERE
    t_v1_rss1_articles.is_grouped = 0
AND
    t_v1_rss1_articles.is_vectorized = 1
AND
    t_v1_rss1_articles.language = 'hin'
ORDER BY
    t_v1_rss1_articles.created_at DESC
LIMIT 10 OFFSET """+ str(offset1) +""";"""

  while True:
    l1_output = create_conn_source(l1)
    if (len(l1_output) == 0):
      break
    article_ids = []
    v2 = []
    for i in range(len(l1_output)):
      article_ids.append(l1_output[i][0])
      v1 = []
      v1.append(l1_output[i][0])
      func_query = f"""
      SELECT
    f_get_similar_articles_l1_hin.article_id
FROM
    synopse_articles.f_get_similar_articles_l1_hin( """ +str(l1_output[i][0]) + """);"""
      func_query_output = create_conn_source(func_query)
      article_group = []
      if len(func_query_output) > 0:
          for func_response in range(len(func_query_output)):
              article_group.append(func_query_output[func_response][0])
      v1.append(article_group)
      v1.append(len(article_group))
      v1.append("hin")
      v2.append(tuple(v1))
    v3=tuple(v2)
    v1_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l1 (article_id, initial_group, article_count, language) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v3)

    if len(article_ids) == 1:
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id = " + str(article_ids[0]) + ";"
      update_conn_source(update_query)
    else:
      t_ids = tuple(article_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 1 WHERE id in " + str(t_ids) + ";"
      update_conn_source(update_query)

# grouping L2
def grouping_l2():
  print("grouping_l2")
  l1_q = f"""SELECT
      a.article_id,
      a.initial_group,
      a.language
  FROM
      synopse_articles.t_v3_article_groups_l1 a
  JOIN
      synopse_articles.t_v1_rss1_articles b
  ON
      a.article_id = b.id
  WHERE
      b.is_grouped = 1 AND
      a.article_count > 1
  ORDER BY
      b.updated_at DESC
  LIMIT 1;"""
  while True:
    l1_q_output = create_conn_source(l1_q)
    lang = "en"
    if (len(l1_q_output) == 0):
      break
    articles_ids = []
    # print(l1_q_output[0][0])
    for j in range(len(l1_q_output[0][1])):
      q12 = f"""SELECT
      article_id,
      initial_group,
      language
  FROM
      synopse_articles.t_v3_article_groups_l1
  WHERE
      """ + str(l1_q_output[0][1][j]) + """  = ANY(initial_group);"""
      q12_output = create_conn_source(q12)
      for func_response in range(len(q12_output)):
        articles_ids.append(q12_output[func_response][1])
        lang = q12_output[func_response][2]
    n1 = []
    n1 = [item for sublist in articles_ids for item in sublist]
    articles_ids = list(set(n1))
    articles_ids.sort(reverse=True)
    done = []
    articles_news = articles_ids
    unique_elements = articles_news
    while True:
      if(len(unique_elements)> 1):
        q2123 = f"""SELECT
                          id,
                          is_grouped
                      FROM
                          synopse_articles.t_v1_rss1_articles
                      WHERE
                          id in   """ + str(tuple(unique_elements)) + """;"""
      if(len(unique_elements) == 1):
        q2123 = f"""SELECT
                          id,
                          is_grouped
                      FROM
                          synopse_articles.t_v1_rss1_articles
                      WHERE
                          id =   """ + str(unique_elements[0]) + """;"""
      q2123_output2 = create_conn_source(q2123)
      for i in range(0,len(q2123_output2)):
        done.append(q2123_output2[i][0])
        if q2123_output2[i][1] == 2:
          q12 = f"""SELECT
                articles_group
            FROM
                synopse_articles.t_v3_article_groups_l2
            WHERE
                """ + str(q2123_output2[i][0]) + """  = ANY(articles_group);"""
          q12_output2 = create_conn_source(q12)
          for func_response in range(len(q12_output2)):
            for article in q12_output2[func_response][0]:
              articles_news.append(article)
              done.append(article)
        if q2123_output2[i][1] == 1:
          q12 = f"""SELECT
                article_id,
                initial_group
            FROM
                synopse_articles.t_v3_article_groups_l1
            WHERE
                """ + str(q2123_output2[i][0])  + """  = ANY(initial_group);"""
          q12_output2 = create_conn_source(q12)
          for func_response in range(len(q12_output2)):
            for article in q12_output2[func_response][1]:
              articles_news.append(article)
      articles_news = list(set(articles_news))
      articles_news.sort(reverse=True)
      done = list(set(done))
      done.sort(reverse=True)
      unique_elements = list(set(articles_news) ^ set(done))
      # print(articles_news)
      # print(done)
      # print("aqwd")
      if len(unique_elements) == 0:
        articles_ids = articles_news
        break
    articles_ids.append(l1_q_output[0][0])
    articles_ids = list(set(articles_ids))
    articles_ids.sort(reverse=True)
    print(lang + "  " + str(articles_ids) )
    q51 = f"""SELECT
        id
      FROM
        synopse_articles.t_v3_article_groups_l2
      WHERE
        is_summerized != 1 AND
        """ + str(articles_ids[-1]) + """ = ANY(articles_group)
      ORDER BY
        updated_at DESC
      LIMIT 1;"""
    q51_output2 = create_conn_source(q51)
    if len(q51_output2) == 1:
      update_query2 = """
          UPDATE synopse_articles.t_v3_article_groups_l2
          SET articles_group = ARRAY""" + str(articles_ids) + """,
              articles_in_group = """ + str(len(articles_ids)) + """
          WHERE id = """ + str(q51_output2[0][0]) + """;"""
      # print(update_query2)
      update_conn_source(update_query2)
      t_ids = tuple(articles_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 2 WHERE id IN " + str(t_ids) + ";"
      # print(update_query)
      update_conn_source(update_query)
    else:
      v1=[]
      v1.append(articles_ids)
      v1.append(len(articles_ids))
      v1.append(lang)
      v2=[]
      v2.append(tuple(v1))
      v3=tuple(v2)
      insert_object = "INSERT INTO synopse_articles.t_v3_article_groups_l2 (articles_group, articles_in_group, language) VALUES (%s, %s, %s)"
      # print(insert_object)
      insert_conn_source(insert_object, v3)
      t_ids = tuple(articles_ids)
      update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET is_grouped = 2 WHERE id IN " + str(t_ids) + ";"
      update_conn_source(update_query)


#get dinal article
def gen_final_article_en(offset):
    esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
    client = openai.OpenAI(
        base_url = "https://api.endpoints.anyscale.com/v1",
        api_key = esecret_ANYSCALE_API_KEY
    )
    q12 = "select a.tag from synopse_articles.t_v4_tags_hierarchy a where a.tag_hierachy != 0;"
    q12_output = create_conn_source(q12)
    tags11 = []
    for i in range(0,len(q12_output)):
      tags11.append(q12_output[i][0])
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
            and a.language = 'en'
            and is_summerized = 0
          order by a.id desc
            LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        system_prompt = """
          Create a JSON object with the following structure:
          {
            "title": "The title of the article with around 10 to 15 words",
            "keypoints": [
              {"point": "First main keypoint with approximately one or two sentences."},
              {"point": "Second main keypoint with approximately one or two sentences."},
              {"point": "Third main keypoint with approximately one or two sentences."}
            ],
            "body": "The main body of the article, provide a balanced and objective summary of the articles limited to a maximum of 2 paragraphs maximum 100 words",
            "tags": ["tag1", "tag2","tag3","tag4"]
            "keywords: ["keyword1", "keyword2", "keyword3", "keyword4"]
          }

          Please ensure that the title is Unbiased and the keypoints accurately summarize the article.
          Capture only three key points acknowledging diverse perspectives showcasing factual information without personal opinion.
          The body should be informative and engaging, while the keyword points should be relevant to the content of the article.
          Explain the topic's context and potential implications allowing readers to form their own informed conclusions.
          Remember to strive for neutrality while remaining engaging and informative to focus on factual information by avoiding emotional language or sensationalism.
          Employ active voice and concise sentences for maximum clarity to ensure the summary is easily understood.
          Ensure the selected tags is amoung """ + str(tags11) + """
            """
        article_get_only_relevent = """
          select a.id, b.summary
          from synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v2_articles_summary b
          where a.id in """ + str(tuple(articles_details_output[0][1])) + """
          and a.id = b.article_id
          order by a.id desc;
          """
        article_get_only_relevent_output = create_conn_source(article_get_only_relevent)
        gen_article = ""
        for i in range(len(article_get_only_relevent_output)):
            gen_article = gen_article + "\n" + article_get_only_relevent_output[i][1]
        if (len(gen_article.split()) > 7000):
            gen_article = ' '.join(gen_article.split()[:7000])
        user_prompt = "all article data: " +  gen_article

        t5 = True
        t6 = 0
        out3=""
        while t5:
          t6 = t6 + 1
          chat_completion = client.chat.completions.create(
            model="mistralai/Mixtral-8x7B-Instruct-v0.1",
            messages=[{"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}],
            max_tokens = 500,
            temperature = 0.3 + (t6 * 0.1),
            top_p = 0.9,
          )
          json_obj = extract_json(chat_completion.choices[0].message.content)
        #   print(json_obj)
          v1 = []
          v2 = []
          v2.append(articles_details_output[0][0])
          isSummerized = 1
          out3=""
          try:
            v2.append(json_obj['title'])
          except:
            v2.append('na')
            out3="na"
          try:
            v2.append(json_obj['body'])
          except:
            v2.append('na')
            out3="na"
          try:
            result123 = [item['point'] for item in json_obj['keypoints']]
            v2.append(result123)
          except:
            v2.append([])
          try:
            v2.append(json_obj['keywords'])
          except:
            v2.append([])
          try:
            v2.append(json_obj['tags'])
          except:
            v2.append([])
          v2.append("en")
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags, language) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            # print(v1_insert_query)
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)
        # break


#get dinal article
def gen_final_article_de(offset):
    esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
    client = openai.OpenAI(
        base_url = "https://api.endpoints.anyscale.com/v1",
        api_key = esecret_ANYSCALE_API_KEY
    )
    q12 = "select a.tag_de from synopse_articles.t_v4_tags_hierarchy a where a.tag_hierachy != 0;"
    q12_output = create_conn_source(q12)
    tags11 = []
    for i in range(0,len(q12_output)):
      tags11.append(q12_output[i][0])
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
            and a.language = 'de'
            and is_summerized = 0
          order by a.id desc
            LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        system_prompt = """
          Erstellen Sie ein JSON-Objekt mit der folgenden Struktur::
          {
            "title": "Die Bedeutung von künstlicher Intelligenz in der modernen Gesellschaft",
            "keypoints": [
              {"point": "Künstliche Intelligenz revolutioniert Branchen wie Medizin, Finanzen und Transportwesen, indem sie effizientere Prozesse ermöglicht und neue Möglichkeiten für Innovation eröffnet."},
              {"point": "Die ethischen und sozialen Auswirkungen von künstlicher Intelligenz sind vielfältig und umfassen Fragen der Privatsphäre, der Arbeitsplatzautomatisierung und des Potenzials für algorithmische Voreingenommenheit."},
              {"point": "Die Entwicklung und Nutzung von künstlicher Intelligenz erfordert eine ausgewogene Regulierung und eine breite gesellschaftliche Debatte, um sicherzustellen, dass die Vorteile für alle zugänglich sind und potenzielle Risiken minimiert werden."}
            ],
            "body": "Künstliche Intelligenz (KI) hat sich zu einem integralen Bestandteil der modernen Gesellschaft entwickelt. Ihre Auswirkungen sind weitreichend, von der Optimierung von Produktionsprozessen bis hin zur Transformation des Gesundheitswesens. Jedoch sind mit diesem Fortschritt auch ethische und soziale Fragen verbunden. Datenschutz, Arbeitsplatzveränderungen und die Fairness von Algorithmen sind nur einige der Herausforderungen, mit denen wir konfrontiert sind. Daher ist eine ausgewogene Regulierung und eine breite gesellschaftliche Debatte unerlässlich, um die Potenziale von KI zu nutzen und gleichzeitig Risiken zu minimieren.",
            "tags": ["tag1", "tag2","tag3","tag4"]
            "keywords: ["keyword1", "keyword2", "keyword3", "keyword4"]
          }

          Bitte stellen Sie sicher, dass der Titel unvoreingenommen ist und die Kernpunkte den Artikel genau zusammenfassen.
          Erfassen Sie nur drei Schlüsselpunkte, die vielfältige Perspektiven anerkennen und sachliche Informationen ohne persönliche Meinung präsentieren.
          Der Text sollte informativ und ansprechend sein, während die Schlüsselpunkte relevant für den Inhalt des Artikels sein sollten.
          Erklären Sie den Kontext des Themas und potenzielle Auswirkungen, damit die Leser ihre eigenen informierten Schlussfolgerungen ziehen können.
          Denken Sie daran, nach Neutralität zu streben, während Sie gleichzeitig ansprechend und informativ bleiben, um sich auf sachliche Informationen zu konzentrieren, indem Sie emotionale Sprache oder Sensationalismus vermeiden.
          Verwenden Sie eine aktive Stimme und prägnante Sätze für maximale Klarheit, um sicherzustellen, dass die Zusammenfassung leicht verständlich ist.
          Stellen Sie sicher, dass die ausgewählten Tags passend sind. """ + str(tags11) + """
            """
        article_get_only_relevent = """
          select a.id, b.summary
          from synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v2_articles_summary b
          where a.id in """ + str(tuple(articles_details_output[0][1])) + """
          and a.id = b.article_id
          order by a.id desc;
          """
        article_get_only_relevent_output = create_conn_source(article_get_only_relevent)
        gen_article = ""
        for i in range(len(article_get_only_relevent_output)):
            gen_article = gen_article + "\n" + article_get_only_relevent_output[i][1]
        if (len(gen_article.split()) > 7000):
            gen_article = ' '.join(gen_article.split()[:7000])
        user_prompt = "all article data: " +  gen_article

        t5 = True
        t6 = 0
        out3=""
        while t5:
          t6 = t6 + 1
          chat_completion = client.chat.completions.create(
            model="mistralai/Mixtral-8x7B-Instruct-v0.1",
            messages=[{"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}],
            max_tokens = 500,
            temperature = 0.3 + (t6 * 0.1),
            top_p = 0.9,
          )
          json_obj = extract_json(chat_completion.choices[0].message.content)
        #   print(json_obj)
          v1 = []
          v2 = []
          v2.append(articles_details_output[0][0])
          isSummerized = 1
          out3=""
          try:
            v2.append(json_obj['title'])
          except:
            v2.append('na')
            out3="na"
          try:
            v2.append(json_obj['body'])
          except:
            v2.append('na')
            out3="na"
          try:
            result123 = [item['point'] for item in json_obj['keypoints']]
            v2.append(result123)
          except:
            v2.append([])
          try:
            v2.append(json_obj['keywords'])
          except:
            v2.append([])
          try:
            v2.append(json_obj['tags'])
          except:
            v2.append([])
          v2.append("de")
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags, language) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)


def gen_final_article_tel(offset):
    esecret_ANYSCALE_API_KEY = "as"
    client = openai.OpenAI(
        api_key = esecret_ANYSCALE_API_KEY
    )
    q12 = "select a.tag_tel from synopse_articles.t_v4_tags_hierarchy a where a.tag_hierachy != 0;"
    q12_output = create_conn_source(q12)
    tags11 = []
    for i in range(0,len(q12_output)):
      tags11.append(q12_output[i][0])
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
            and a.language = 'tel'
            and is_summerized = 0
          order by a.id desc
            LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        system_prompt = """
          కింది నిర్మాణంతో JSON వస్తువును సృష్టించండి:
           {
             "title": "సుమారు 10 నుండి 15 పదాలతో వ్యాసం యొక్క శీర్షిక",
             "keypoints": [
               {"point": "సుమారు ఒకటి లేదా రెండు వాక్యాలతో మొదటి ప్రధాన కీ పాయింట్."},
               {"point": "సుమారు ఒకటి లేదా రెండు వాక్యాలతో రెండవ ప్రధాన కీ పాయింట్."},
               {"point": "సుమారు ఒకటి లేదా రెండు వాక్యాలతో మూడవ ప్రధాన కీ పాయింట్."}
             ],
             "body": "వ్యాసం యొక్క ప్రధాన భాగం, గరిష్టంగా 2 పేరాగ్రాఫ్‌లు గరిష్టంగా 100 పదాలకు పరిమితం చేయబడిన కథనాల యొక్క సమతుల్య మరియు లక్ష్యం సారాంశాన్ని అందించండి",
             "tags": ["tag1", "tag2","tag3","tag4"]
             "keywords: ["కీవర్డ్1", "కీవర్డ్2", "కీవర్డ్3", "కీవర్డ్4"]
           }

           దయచేసి శీర్షిక నిష్పక్షపాతంగా ఉందని మరియు ముఖ్యాంశాలు కథనాన్ని ఖచ్చితంగా సంగ్రహించాయని నిర్ధారించుకోండి.
           వ్యక్తిగత అభిప్రాయం లేకుండా వాస్తవ సమాచారాన్ని ప్రదర్శించే విభిన్న దృక్కోణాలను అంగీకరిస్తూ మూడు కీలక అంశాలను మాత్రమే క్యాప్చర్ చేయండి.
           ప్రధానాంశాలు కథనం యొక్క కంటెంట్‌కు సంబంధించినవిగా ఉండాలి, అయితే శరీరం సమాచారంగా మరియు ఆకర్షణీయంగా ఉండాలి.
           పాఠకులు వారి స్వంత సమాచార నిర్ధారణలను రూపొందించడానికి అనుమతించే అంశం యొక్క సందర్భం మరియు సంభావ్య చిక్కులను వివరించండి.
           ఉద్వేగభరితమైన భాష లేదా సంచలనాత్మకతను నివారించడం ద్వారా వాస్తవ సమాచారంపై దృష్టి సారించడానికి నిమగ్నమై మరియు సమాచారంగా ఉంటూనే తటస్థత కోసం ప్రయత్నించాలని గుర్తుంచుకోండి.
           సారాంశం సులభంగా అర్థమయ్యేలా నిర్ధారించుకోవడానికి గరిష్ట స్పష్టత కోసం యాక్టివ్ వాయిస్ మరియు సంక్షిప్త వాక్యాలను ఉపయోగించండి.
           ఎంచుకున్న ట్యాగ్‌లు అమోంగ్‌గా ఉన్నాయని నిర్ధారించుకోండి """ + str(tags11) + """
            """
        article_get_only_relevent = """
          select a.id, b.summary
          from synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v2_articles_summary b
          where a.id in """ + str(tuple(articles_details_output[0][1])) + """
          and a.id = b.article_id
          order by a.id desc;
          """
        article_get_only_relevent_output = create_conn_source(article_get_only_relevent)
        gen_article = ""
        for i in range(len(article_get_only_relevent_output)):
            gen_article = gen_article + "\n" + article_get_only_relevent_output[i][1]
        if (len(gen_article.split()) > 7000):
            gen_article = ' '.join(gen_article.split()[:7000])
        user_prompt = "all article data: " +  gen_article

        t5 = True
        t6 = 0
        out3=""
        while t5:
          t6 = t6 + 1
          time.sleep(30)
          chat_completion = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}],
            # max_tokens = 2048,
            temperature = 0.3 + (t6 * 0.1),
            top_p = 0.9,
          )
          json_obj = extract_json(chat_completion.choices[0].message.content)
          v1 = []
          v2 = []
          v2.append(articles_details_output[0][0])
          isSummerized = 1
          out3=""
          try:
            v2.append(json_obj['title'])
          except:
            v2.append('na')
            out3="na"
          try:
            v2.append(json_obj['body'])
          except:
            v2.append('na')
            out3="na"
          try:
            result123 = [item['point'] for item in json_obj['keypoints']]
            v2.append(result123)
          except:
            v2.append([])
          try:
            v2.append(json_obj['keywords'])
          except:
            v2.append([])
          try:
            v2.append(json_obj['tags'])
          except:
            v2.append([])
          v2.append("tel")
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags, language) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)


#get dinal article
def gen_final_article_tam(offset):
    esecret_ANYSCALE_API_KEY = "as"
    client = openai.OpenAI(
        api_key = esecret_ANYSCALE_API_KEY
    )
    q12 = "select a.tag_tam from synopse_articles.t_v4_tags_hierarchy a where a.tag_hierachy != 0;"
    q12_output = create_conn_source(q12)
    tags11 = []
    for i in range(0,len(q12_output)):
      tags11.append(q12_output[i][0])
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
            and a.language = 'tam'
            and is_summerized = 0
          order by a.id desc
            LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        system_prompt = """
          பின்வரும் கட்டமைப்புடன் JSON பொருளை உருவாக்கவும்:
           {
             "title": "சுமார் 10 முதல் 15 சொற்களைக் கொண்ட கட்டுரையின் தலைப்பு",
             "keypoints": [
               {"point": "தோராயமாக ஒன்று அல்லது இரண்டு வாக்கியங்கள் கொண்ட முதல் முக்கிய முக்கிய புள்ளி."},
               {"point": "தோராயமாக ஒன்று அல்லது இரண்டு வாக்கியங்கள் கொண்ட இரண்டாவது முக்கிய புள்ளி."},
               {"point": "தோராயமாக ஒன்று அல்லது இரண்டு வாக்கியங்கள் கொண்ட மூன்றாவது முக்கிய புள்ளி."}
             ],
             "body": "கட்டுரையின் முக்கிய பகுதி, அதிகபட்சம் 2 பத்திகள் அதிகபட்சம் 100 வார்த்தைகள் வரை வரையறுக்கப்பட்ட கட்டுரைகளின் சமநிலை மற்றும் புறநிலை சுருக்கத்தை வழங்கவும்",
             "tags": ["tag1", "tag2","tag3","tag4"]
             "keywords: ["முக்கிய சொல் 1", "முக்கிய சொல் 2", "முக்கிய சொல் 3", "முக்கிய சொல் 4"]
           }

           தலைப்பு பக்கச்சார்பற்றது என்பதையும் முக்கிய குறிப்புகள் கட்டுரையை துல்லியமாக சுருக்கமாக இருப்பதையும் உறுதி செய்யவும்.
           தனிப்பட்ட கருத்து இல்லாமல் உண்மைத் தகவலைக் காண்பிக்கும் மாறுபட்ட கண்ணோட்டங்களை ஒப்புக்கொண்டு மூன்று முக்கிய புள்ளிகளை மட்டும் படமெடுக்கவும்.
           உடல் தகவல் மற்றும் ஈடுபாடு கொண்டதாக இருக்க வேண்டும், அதே சமயம் முக்கிய குறிப்புகள் கட்டுரையின் உள்ளடக்கத்துடன் தொடர்புடையதாக இருக்க வேண்டும்.
           தலைப்பின் சூழல் மற்றும் வாசகர்கள் தங்கள் சொந்த தகவலறிந்த முடிவுகளை உருவாக்க அனுமதிக்கும் சாத்தியமான தாக்கங்களை விளக்குங்கள்.
           உணர்ச்சிப்பூர்வமான மொழி அல்லது பரபரப்பானதைத் தவிர்ப்பதன் மூலம் உண்மைத் தகவலில் கவனம் செலுத்துவதற்கு ஈடுபாட்டுடனும் தகவலறிந்ததாகவும் இருக்கும் போது நடுநிலைமைக்காக பாடுபடுவதை நினைவில் கொள்ளுங்கள்.
           சுருக்கம் எளிதில் புரிந்துகொள்ளப்படுவதை உறுதிசெய்ய, அதிகபட்ச தெளிவுக்காக செயலில் உள்ள குரல் மற்றும் சுருக்கமான வாக்கியங்களைப் பயன்படுத்தவும்.
           தேர்ந்தெடுக்கப்பட்ட குறிச்சொற்கள் ஏராளமானவை என்பதை உறுதிப்படுத்தவும் """ + str(tags11) + """
            """
        article_get_only_relevent = """
          select a.id, b.summary
          from synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v2_articles_summary b
          where a.id in """ + str(tuple(articles_details_output[0][1])) + """
          and a.id = b.article_id
          order by a.id desc;
          """
        article_get_only_relevent_output = create_conn_source(article_get_only_relevent)
        gen_article = ""
        for i in range(len(article_get_only_relevent_output)):
            gen_article = gen_article + "\n" + article_get_only_relevent_output[i][1]
        if (len(gen_article.split()) > 7000):
            gen_article = ' '.join(gen_article.split()[:7000])
        user_prompt = "all article data: " +  gen_article

        t5 = True
        t6 = 0
        out3=""
        while t5:
          t6 = t6 + 1
          time.sleep(30)
          chat_completion = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}],
            # max_tokens = 2048,
            temperature = 0.3 + (t6 * 0.1),
            top_p = 0.9,
          )
          json_obj = extract_json(chat_completion.choices[0].message.content)
          v1 = []
          v2 = []
          v2.append(articles_details_output[0][0])
          isSummerized = 1
          out3=""
          try:
            v2.append(json_obj['title'])
          except:
            v2.append('na')
            out3="na"
          try:
            v2.append(json_obj['body'])
          except:
            v2.append('na')
            out3="na"
          try:
            result123 = [item['point'] for item in json_obj['keypoints']]
            v2.append(result123)
          except:
            v2.append([])
          try:
            v2.append(json_obj['keywords'])
          except:
            v2.append([])
          try:
            v2.append(json_obj['tags'])
          except:
            v2.append([])
          v2.append("tam")
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags, language) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)


#get dinal article
def gen_final_article_hin(offset):
    esecret_ANYSCALE_API_KEY = "as"
    client = openai.OpenAI(
        api_key = esecret_ANYSCALE_API_KEY
    )
    q12 = "select a.tag_hin from synopse_articles.t_v4_tags_hierarchy a where a.tag_hierachy != 0;"
    q12_output = create_conn_source(q12)
    tags11 = []
    for i in range(0,len(q12_output)):
      tags11.append(q12_output[i][0])
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
            and a.language = 'hin'
            and is_summerized = 0
          order by a.id desc
            LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        system_prompt = """
          निम्नलिखित संरचना के साथ एक JSON ऑब्जेक्ट बनाएं::
           {
             "title": "लगभग 10 से 15 शब्दों वाला लेख का शीर्षक",
             "keypoints": [
               {"point": "लगभग एक या दो वाक्यों वाला पहला मुख्य मुख्य बिंदु।"},
               {"point": "लगभग एक या दो वाक्यों वाला दूसरा मुख्य मुख्य बिंदु।"},
               {"point": "लगभग एक या दो वाक्यों वाला तीसरा मुख्य मुख्य बिंदु।"}
             ],
             "body": "लेख का मुख्य भाग, अधिकतम 2 पैराग्राफ अधिकतम 100 शब्दों तक सीमित लेखों का एक संतुलित और वस्तुनिष्ठ सारांश प्रदान करता है",
             "tags": ["tag1", "tag2","tag3","tag4"]
             "keywords: ["कीवर्ड 1", "कीवर्ड 2", "कीवर्ड 3", "कीवर्ड 4"]
           }

           कृपया सुनिश्चित करें कि शीर्षक निष्पक्ष है और मुख्य बिंदु लेख का सटीक सारांश प्रस्तुत करते हैं।
           व्यक्तिगत राय के बिना तथ्यात्मक जानकारी प्रदर्शित करते हुए विविध दृष्टिकोणों को स्वीकार करते हुए केवल तीन प्रमुख बिंदुओं को कैप्चर करें।
           मुख्य भाग जानकारीपूर्ण और आकर्षक होना चाहिए, जबकि कीवर्ड बिंदु लेख की सामग्री के लिए प्रासंगिक होने चाहिए।
           विषय के संदर्भ और संभावित निहितार्थों को स्पष्ट करें जिससे पाठकों को अपने स्वयं के सूचित निष्कर्ष बनाने में मदद मिल सके।
           भावनात्मक भाषा या सनसनीखेज से बचकर तथ्यात्मक जानकारी पर ध्यान केंद्रित करने के लिए आकर्षक और जानकारीपूर्ण रहते हुए तटस्थता के लिए प्रयास करना याद रखें।
           यह सुनिश्चित करने के लिए कि सारांश आसानी से समझा जा सके, अधिकतम स्पष्टता के लिए सक्रिय आवाज़ और संक्षिप्त वाक्यों का उपयोग करें।
           सुनिश्चित करें कि चयनित टैग शामिल हैं """ + str(tags11) + """
            """
        article_get_only_relevent = """
          select a.id, b.summary
          from synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v2_articles_summary b
          where a.id in """ + str(tuple(articles_details_output[0][1])) + """
          and a.id = b.article_id
          order by a.id desc;
          """
        article_get_only_relevent_output = create_conn_source(article_get_only_relevent)
        gen_article = ""
        for i in range(len(article_get_only_relevent_output)):
            gen_article = gen_article + "\n" + article_get_only_relevent_output[i][1]
        if (len(gen_article.split()) > 7000):
            gen_article = ' '.join(gen_article.split()[:7000])
        user_prompt = "all article data: " +  gen_article

        t5 = True
        t6 = 0
        out3=""
        while t5:
          t6 = t6 + 1
          time.sleep(30)
          chat_completion = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt}],
            # max_tokens = 2048,
            temperature = 0.3 + (t6 * 0.1),
            top_p = 0.9,
          )
          json_obj = extract_json(chat_completion.choices[0].message.content)
          v1 = []
          v2 = []
          v2.append(articles_details_output[0][0])
          isSummerized = 1
          out3=""
          try:
            v2.append(json_obj['title'])
          except:
            v2.append('na')
            out3="na"
          try:
            v2.append(json_obj['body'])
          except:
            v2.append('na')
            out3="na"
          try:
            result123 = [item['point'] for item in json_obj['keypoints']]
            v2.append(result123)
          except:
            v2.append([])
          try:
            v2.append(json_obj['keywords'])
          except:
            v2.append([])
          try:
            v2.append(json_obj['tags'])
          except:
            v2.append([])
          v2.append("hin")
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags, language) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)

#get final article en
def ai_tagging_groups_bertwiki_en(offset1):
  topic_model = BERTopic.load("MaartenGr/BERTopic_Wikipedia")
  while True:
    articles_details = """
            SELECT
      a.article_group_id,
      COALESCE(a.title, ' ') || ' ' || COALESCE(a.summary, ' ') || ' ' || COALESCE(array_to_string(a.llm_keypoints, ' '), ' ') || ' ' || COALESCE(array_to_string(a.llm_keywords, ' '), ' ') || ' ' || COALESCE(array_to_string(a.llm_tags, ' '), ' ') AS combined_column
  FROM
      synopse_articles.t_v4_article_groups_l2_detail a,
      synopse_articles.t_v3_article_groups_l2 b
  WHERE
      a.language = 'en'
      AND a.article_group_id = b.id
      AND b.is_ai_tagged = 0
      AND b.is_summerized = 1
      limit 10 offset """ + str(offset1) + """;
    """
    articles_details_output = create_conn_source(articles_details)
    if(len(articles_details_output) == 0):
      break
    for i in range(0,len(articles_details_output)):
      topic, prob = topic_model.transform(articles_details_output[i][1])
      topic_label = topic_model.topic_labels_[topic[0]]
      q2= f"""UPDATE synopse_articles.t_v4_article_groups_l2_detail
                SET group_ai_tags_l1 ='{topic_label}'
                WHERE article_group_id  = """+ str(articles_details_output[i][0]) + """;"""
      update_conn_source(q2)
      q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_ai_tagged = 1
                WHERE id  = """+ str(articles_details_output[i][0]) + """;"""
      update_conn_source(q1)

#get dinal article
def ai_tagging_groups_bertwiki_nen(offset1):
  topic_model = BERTopic.load("MaartenGr/BERTopic_Wikipedia")
  model = MBartForConditionalGeneration.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")
  tokenizer = MBart50TokenizerFast.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")

  while True:
    articles_details = """
            SELECT
      a.article_group_id,
      COALESCE(a.title, ' ')  || ' ' || COALESCE(array_to_string(a.llm_tags, ' '), ' ') || ' ' || COALESCE(a.summary, ' ') || ' ' || COALESCE(array_to_string(a.llm_keypoints, ' '), ' ') || ' ' || COALESCE(array_to_string(a.llm_keywords, ' '), ' ') AS combined_column,
      a.language
  FROM
      synopse_articles.t_v4_article_groups_l2_detail a,
      synopse_articles.t_v3_article_groups_l2 b
  WHERE
      a.language != 'en'
      AND a.article_group_id = b.id
      AND b.is_ai_tagged = 0
      AND b.is_summerized = 1
      limit 10 offset """ + str(offset1) + """;
    """
    articles_details_output = create_conn_source(articles_details)
    if(len(articles_details_output) == 0):
      break
    for i in range(0,len(articles_details_output)):
      if (articles_details_output[i][2] == "hin"):
        tokenizer.src_lang = "hi_IN"
      elif (articles_details_output[i][2] == "tel"):
        tokenizer.src_lang = "te_IN"
      elif (articles_details_output[i][2] == "tam"):
        tokenizer.src_lang = "ta_IN"
      elif (articles_details_output[i][2] == "de"):
        tokenizer.src_lang = "de_DE"
      encoded_hi = tokenizer(articles_details_output[i][1], return_tensors="pt")
      generated_tokens = model.generate(
          **encoded_hi,
          forced_bos_token_id=tokenizer.lang_code_to_id["fr_XX"]
      )
      translation = tokenizer.batch_decode(generated_tokens, skip_special_tokens=True)
      print(translation[0])
      topic, prob = topic_model.transform(translation[0])
      topic_label = topic_model.topic_labels_[topic[0]]
      print(topic_label)
      q2= f"""UPDATE synopse_articles.t_v4_article_groups_l2_detail
                SET group_ai_tags_l1 ='{topic_label}'
                WHERE article_group_id  = """+ str(articles_details_output[i][0]) + """;"""
      update_conn_source(q2)
      q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_ai_tagged = 1
                WHERE id  = """+ str(articles_details_output[i][0]) + """;"""
      update_conn_source(q1)

#set detail tags
def detail_tags(offset1):
  graphql_query = '''
  query MyQuery($limit: Int!, $offset: Int!) {
  synopse_articles_t_v4_article_groups_l2_detail(where: {logo_urls: {_is_null: true}}, limit: $limit, offset: $offset) {
      id
      t_v3_article_groups_l2 {
        articles_group
      }
    }
  }
  '''
  query2 = '''
  query MyQuery($article_ids: [bigint!] = "") {
      synopse_articles_t_v1_rss1_articles(where: {id: {_in: $article_ids}}) {
        image_link
        tags
        t_v1_rss1_feed_link {
          t_v1_outlet {
            logo_url
          }
        }
        t_v2_articles_summary {
          keywords_tags
          location_tags
          org_tags
          person_tags
        }
      }
    }

  '''
  offset = offset1
  mutation_query = """
  mutation MyMutation($updates: [synopse_articles_t_v4_article_groups_l2_detail_updates!] = {where: {}}) {
    update_synopse_articles_t_v4_article_groups_l2_detail_many(updates: $updates) {
      affected_rows
    }
  }
  """
  while True:
      variables = {
      "limit": 1,
      "offset": offset
      }
      response_data = query_hasura_graphql(endpoint, admin_key, graphql_query, variables)
      synopse_articles_t_v4_article_groups_l2_detail_updates_loc=[]
      image_urls=[]
      logo_urls=[]
      keywords_tags=[]
      location_tags=[]
      org_tags=[]
      person_tags=[]
      if len(response_data['data']['synopse_articles_t_v4_article_groups_l2_detail']) == 0:
            break
      for response in response_data['data']['synopse_articles_t_v4_article_groups_l2_detail']:
          variables2 = {
              "article_ids": response['t_v3_article_groups_l2']['articles_group']
              }
          response_data1 = query_hasura_graphql(endpoint, admin_key, query2, variables2)
          for response1 in response_data1['data']['synopse_articles_t_v1_rss1_articles']:
              try:
                if (response1['image_link'] is not None):
                    image_urls.append(response1['image_link'])
              except:
                continue
              try:
                if (response1['t_v1_rss1_feed_link']['t_v1_outlet']['logo_url'] is not None):
                    logo_urls.append(response1['t_v1_rss1_feed_link']['t_v1_outlet']['logo_url'])
              except:
                continue
              try:
                if (response1['tags'] is not None):
                    keywords_tags.append(response1['tags'])
              except:
                continue
              try:
                if (response1['t_v2_articles_summary']['keywords_tags'] is not None):
                    keywords_tags.append(response1['t_v2_articles_summary']['keywords_tags'])
              except:
                continue
              try:
                if (response1['t_v2_articles_summary']['location_tags'] is not None):
                    location_tags.append(response1['t_v2_articles_summary']['location_tags'])
              except:
                continue
              try:
                if (response1['t_v2_articles_summary']['org_tags'] is not None):
                    org_tags.append(response1['t_v2_articles_summary']['org_tags'])
              except:
                continue
              try:
                if (response1['t_v2_articles_summary']['person_tags'] is not None):
                    person_tags.append(response1['t_v2_articles_summary']['person_tags'])
              except:
                continue
      image_urls = list(set(image_urls))
      image_urls = [url for url in image_urls if url != ""]
      logo_urls = list(set(logo_urls))
      logo_urls = [url for url in logo_urls if url != ""]
      keywords_tags = array2dto2d(keywords_tags)
      location_tags = array2dto2d(location_tags)
      org_tags = array2dto2d(org_tags)
      person_tags = array2dto2d(person_tags)
      synopse_articles_t_v4_article_groups_l2_detail_updates_loc.append({
          "where": {"id" : { "_eq": response['id'] }},
          "_set": {"image_urls": image_urls,
                  "logo_urls": logo_urls,
                  "keywords_tags": keywords_tags,
                  "location_tags": location_tags,
                  "org_tags": org_tags,
                  "person_tags": person_tags,
                   }
          })
      mutation_variables = {
      "updates": synopse_articles_t_v4_article_groups_l2_detail_updates_loc,
      }
      out1 = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutation_query, mutation_variables=mutation_variables)

def delete_article_detail():
    mutation_query = """
    mutation MyMutation {
        delete_synopse_articles_t_v1_rss1_articles_detail(where: {}) {
            affected_rows
        }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def set_publish_date():
    while True:
        articles_l2 = """
        SELECT
            a.id,
            c.post_published
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a, synopse_articles.t_v1_rss1_articles c
        WHERE
            a.post_published IS NULL
            and (SELECT b.articles_group[0] FROM synopse_articles.t_v3_article_groups_l2 b WHERE a.article_group_id = b.id) = c.id
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ articles_l2_output[i][1].strftime('%Y-%m-%d %H:%M:%S') +"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)
    while True:
        articles_l2 = """
        SELECT
            a.id,
            c.post_published
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a, synopse_articles.t_v1_rss1_articles c
        WHERE
            a.post_published IS NULL
            and (SELECT b.articles_group[1] FROM synopse_articles.t_v3_article_groups_l2 b WHERE a.article_group_id = b.id) = c.id
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ articles_l2_output[i][1].strftime('%Y-%m-%d %H:%M:%S') +"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)
    while True:
        articles_l2 = """
        SELECT
            a.id,
            c.post_published
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a, synopse_articles.t_v1_rss1_articles c
        WHERE
            a.post_published IS NULL
            and (SELECT b.articles_group[2] FROM synopse_articles.t_v3_article_groups_l2 b WHERE a.article_group_id = b.id) = c.id
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ articles_l2_output[i][1].strftime('%Y-%m-%d %H:%M:%S') +"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)
    while True:
        articles_l2 = """
        SELECT
            a.id,
            c.post_published
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a, synopse_articles.t_v1_rss1_articles c
        WHERE
            a.post_published IS NULL
            and (SELECT b.articles_group[3] FROM synopse_articles.t_v3_article_groups_l2 b WHERE a.article_group_id = b.id) = c.id
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ articles_l2_output[i][1].strftime('%Y-%m-%d %H:%M:%S') +"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)
    while True:
        articles_l2 = """
        SELECT
            a.id,
            c.post_published
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a, synopse_articles.t_v1_rss1_articles c
        WHERE
            a.post_published IS NULL
            and (SELECT b.articles_group[4] FROM synopse_articles.t_v3_article_groups_l2 b WHERE a.article_group_id = b.id) = c.id
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ articles_l2_output[i][1].strftime('%Y-%m-%d %H:%M:%S') +"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)
    while True:
        articles_l2 = """
        SELECT
            a.id
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a
        WHERE
            a.post_published IS NULL
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        for i in range(len(articles_l2_output)):
            update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET post_published = '"+ datetime.now().astimezone(timezone.utc).isoformat()+"' WHERE id = " + str(articles_l2_output[i][0]) + ";"
            # print(update_query)
            update_conn_source(update_query)

def load_to_prod():
    print("#outlet")

    outlet1 = "SELECT id, outlet_display, logo_url, language FROM synopse_articles.t_v1_outlets"
    outlet1_output = create_conn_source(outlet1)
    # print(outlet1_output)
    outlet_insert_query = """
    INSERT INTO synopse_articles.t_v1_outlets (outlet_id, outlet_display, logo_url, language)
    VALUES (%s, %s, %s, %s)
    ON CONFLICT (outlet_id)
    DO UPDATE SET outlet_display = EXCLUDED.outlet_display, logo_url = EXCLUDED.logo_url, language = EXCLUDED.language
    """
    outlet_data = outlet1_output
    create_conn_destination(outlet_insert_query, outlet_data)

    print("#tags")
    t_v4_tags_hierarchy = """
    SELECT
        id,
        tag,
        tag_hierachy,
        tag_description,
        is_valid,
        tag_tel,
        tag_de,
        tag_tam,
        tag_hin
    FROM
        synopse_articles.t_v4_tags_hierarchy;
    """
    t_v4_tags_hierarchy_output = create_conn_source(t_v4_tags_hierarchy)

    t_v4_tags_hierarchy_insert_query ="""
    INSERT INTO synopse_articles.t_v4_tags_hierarchy (
        tag_id,
        tag,
        tag_hierachy,
        tag_description,
        is_valid,
        tag_tel,
        tag_de,
        tag_tam,
        tag_hin
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (tag_id) DO UPDATE SET
        tag = EXCLUDED.tag,
        tag_hierachy = EXCLUDED.tag_hierachy,
        tag_description = EXCLUDED.tag_description,
        is_valid = EXCLUDED.is_valid,
        tag_tel = EXCLUDED.tag_tel,
        tag_de = EXCLUDED.tag_de,
        tag_tam = EXCLUDED.tag_tam,
        tag_hin = EXCLUDED.tag_hin;
    """
    create_conn_destination(t_v4_tags_hierarchy_insert_query, t_v4_tags_hierarchy_output)

    print("main articles")
    while True:
        articles = """
        SELECT
            a.id,
            a.title,
            a.post_link,
            a.author,
            a.image_link,
            a.post_published,
            c.id as outlet_id,
            a.language
        FROM
            synopse_articles.t_v1_rss1_articles a
        INNER JOIN
            synopse_articles.t_v1_rss1_feed_links b ON a.rss1_feed_id = b.id
        INNER JOIN
            synopse_articles.t_v1_outlets c ON b.outlet  = c.outlet
        WHERE  a.prod = 0
        ORDER BY
            a.id DESC
        LIMIT 200
        """
        articles_output = create_conn_source(articles)
        if len(articles_output) == 0:
            break
        articles_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles (article_id, title, post_link, author, image_link, post_published, outlet_id, language) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        create_conn_destination(articles_insert_query, articles_output)
        ids = []
        for i in range(len(articles_output)):
            ids.append(articles_output[i][0])
        if (len(ids) > 1):
            t_ids = tuple(ids)
            update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET prod = 1 WHERE id IN " + str(t_ids) + ";"
        else:
            update_query = "UPDATE synopse_articles.t_v1_rss1_articles SET prod = 1 WHERE id = " + str(ids[0]) + ";"
        update_conn_source(update_query)

    print("article_grouping_l2")
    while True:
        articles_l2 = """
        SELECT
            a.id,
            a.is_valid,
            a.articles_group,
            a.articles_in_group,
            a.article_comment_id,
            a.language
        FROM
            synopse_articles.t_v3_article_groups_l2 a
        WHERE
            a.prod = 0
            and a.is_ai_tagged = 1
            ORDER BY
                a.id DESC
            LIMIT 200
        """
        articles_l2_output = create_conn_source(articles_l2)
        if len(articles_l2_output) == 0:
            break
        articles_l2_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l2 (article_group_id, is_valid, articles_group, articles_in_group, article_comment_id, language) VALUES (%s, %s, %s, %s, %s, %s)"
        create_conn_destination(articles_l2_insert_query, articles_l2_output)
        ids = []
        for i in range(len(articles_l2_output)):
            ids.append(articles_l2_output[i][0])
        t_ids = tuple(ids)
        update_query = "UPDATE synopse_articles.t_v3_article_groups_l2 SET prod = 1 WHERE id IN " + str(t_ids) + ";"
        update_conn_source(update_query)

    print("article_grouping_l2_detail")
    while True:
        articles_l2_details = """
        SELECT
            a.article_group_id,
            a.title,
            a.summary,
            a.is_valid,
            a.image_urls,
            a.logo_urls,
            a.summary_60_words,
            a.keywords_tags,
            a.location_tags,
            a.org_tags,
            a.person_tags,
            a.group_ai_tags_l1,
            d.tag as tag_root,
            CASE
                WHEN a.language = 'en' THEN c.tag
                WHEN a.language = 'de' THEN c.tag_de
                WHEN a.language = 'tel' THEN c.tag_tel
                WHEN a.language = 'tam' THEN c.tag_tam
                WHEN a.language = 'hin' THEN c.tag_hin
                ELSE c.tag
            END as tag,
            a.is_audio_created_valid,
            a.llm_keypoints,
            a.post_published,
            a.language,
            c.id
        FROM
            synopse_articles.t_v4_article_groups_l2_detail a
        LEFT OUTER JOIN
            synopse_articles.t_v4_berttopics b
        ON
            b.topic_name = a.group_ai_tags_l1
        LEFT OUTER JOIN
            synopse_articles.t_v4_tags_hierarchy c
        ON
            b.tag_tree = c.tag
        LEFT OUTER JOIN
            synopse_articles.t_v4_tags_hierarchy d
        ON
            c.tag_hierachy = d.id
        WHERE
            a.prod = 0 AND b.tag_id != 0 AND a.logo_urls is not null
            ORDER BY
                a.id DESC
            LIMIT 200;
        """
        articles_l2_details_output = create_conn_source(articles_l2_details)
        if len(articles_l2_details_output) == 0:
            break
        articles_l2_details_insert_query ="""
        INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (
            article_group_id,
            title,
            summary,
            is_valid,
            image_urls,
            logo_urls,
            summary_60_words,
            keywords_tags,
            location_tags,
            org_tags,
            person_tags,
            group_ai_tags_l1,
            group_ai_tags_l2,
            group_ai_tags_l3,
            is_audio_created_valid,
            keypoints,
            post_published,
            language,
            tag_id
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)  ON CONFLICT DO NOTHING;
        """
        create_conn_destination(articles_l2_details_insert_query, articles_l2_details_output)
        ids = []
        for i in range(len(articles_l2_details_output)):
            ids.append(articles_l2_details_output[i][0])
        t_ids = tuple(ids)
        update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET prod = 1 WHERE article_group_id IN " + str(t_ids) + ";"
        update_conn_source(update_query)

def is_valid_image(url):
    try:
        response = requests.get(url)
        return response.status_code == 200
    except requests.exceptions.RequestException as e:
        return False

def remove_invalid_images_prod():
    t_v4_tags_hierarchy = """
    SELECT
        a.image_url
    FROM
        synopse_articles.t_temp_remove_images a;
    """
    t_v4_tags_hierarchy_output = select_conn_destination(t_v4_tags_hierarchy)
    for link in t_v4_tags_hierarchy_output:
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET image_link = ''
            WHERE image_link = '{link[0]}';"""
        q2 = f"""UPDATE synopse_articles.t_v4_article_groups_l2_detail
            SET image_urls = array_remove(image_urls, '{link[0]}')
            WHERE '{link[0]}' = ANY(image_urls);"""
        update_conn_source(q1)
        update_conn_source(q2)
        update_conn_destination(q1)
        update_conn_destination(q2)
        q3 = f"""DELETE FROM synopse_articles.t_temp_remove_images;"""
        update_conn_destination(q3)


def create_latest_8hours_en():
    language = 'en'
    latest_8hours = f"""
    select count(a.*) from synopse_articles.t_v7_all_article_summary_8hours a where a.created_at > (now() - '10:00:00'::interval) and a.language = '{language}';
    """
    latest_8hours_output = select_conn_destination(latest_8hours)

    if latest_8hours_output[0][0] > 0:
        esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
        client = openai.OpenAI(
            base_url = "https://api.endpoints.anyscale.com/v1",
            api_key = esecret_ANYSCALE_API_KEY
        )
        now_utc = datetime.utcnow()
        formatted_date = now_utc.strftime('%Y%m%d%H')
        formatted_date_out1 = now_utc.strftime('%B %d') + suffix(now_utc.day)  + ', ' + get_part_of_day(now_utc.hour)
        date_int = int(formatted_date)
        article1 = f"""
        SELECT COALESCE(count(a.*), 0), b.article_group_id, b.title, b.summary
        FROM synopse_articles.t_v4_article_groups_l2_detail AS b
        JOIN synopse_realtime.t_user_article_views AS a
        ON a.article_group_id = b.article_group_id
        and (a.created_at > (now() - '15:00:00'::interval) OR a.created_at IS NULL)
        and b.language = '{language}'
        group by b.article_group_id, b.title, b.summary
        order by COALESCE(count(a.*), 0) desc, b.article_group_id desc
        LIMIT 10;"""
        art1 = ""
        article1_output = select_conn_destination(article1)
        title = ""
        article_group = []
        for j in range(len(article1_output)):
            article_group.append(article1_output[j][1])
            title += f"{article1_output[j][2]}\n"
            art1 += f"{article1_output[j][2]} - {article1_output[j][3]}\n"
        filename = "trending_ " + str(language) + "_" + str(date_int) + ".wav"
        system_prompt = """
        you are news anchor reporting trending news and you have to provide a transcript for a news anchor with around 150 words.
        Capture around 5 to 7 key points acknowledging diverse perspectives showcasing factual information without personal opinion.
        The keypoints should be informative and engaging, while the keyword points should be relevant to the content of the articles.
        Remember to strive for neutrality while remaining engaging and informative to focus on factual information by avoiding emotional language or sensationalism.
        Employ active voice and concise sentences for maximum clarity to ensure the summary is easily understood.
        provide and intro to the script and here are some sample intro lines modify and provide a similar intro for the script

        "Good evening and welcome to tonight's edition of trending news. It's  """ + str(formatted_date_out1) + """ , and we've got the latest updates on stories making waves around the globe."
        "Hello, and thank you for joining us for trending news on this  """ + str(formatted_date_out1) + """ . From breaking developments to viral sensations, we've got you covered."
        "From the heart of the newsroom, this is your update on trending headlines for  """ + str(formatted_date_out1) + """ . Sit tight as we delve into the stories captivating the world's attention."
        "Welcome to our broadcast on this  """ + str(formatted_date_out1) + """ , where we bring you the hottest topics dominating social media feeds and news cycles alike."
        "It's  """ + str(formatted_date_out1) + """ , and you're tuned in to our trending news segment. Stay with us as we explore the most talked-about stories of the day."
        "Good day, everyone, and thank you for joining us for trending news. I'm here to bring you the latest buzz and updates from around the world as of  """ + str(formatted_date_out1) + """ ."
        "Greetings, viewers. As we kick off  """ + str(formatted_date_out1) + """ , let's dive into the trending news stories making headlines and sparking conversations globally."
        "Welcome aboard our trending news express. Buckle up as we navigate through the top stories dominating the internet and airwaves on this  """ + str(formatted_date_out1) + """ ."
        "It's  """ + str(formatted_date_out1) + """ , and you're watching our trending news roundup. Stick around as we unpack the day's most significant events and trending topics."
        "Hello, and a warm welcome to our trending news segment. On this  """ + str(formatted_date_out1) + """ , we're here to bring you up to speed on the stories everyone's talking about."
        the entire script should be maximum of 350 words.
        """
        user_prompt = "all article data: " +  art1
        chat_completion = client.chat.completions.create(
        model="mistralai/Mixtral-8x7B-Instruct-v0.1",
        messages=[{"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}],
        max_tokens = 1000,
        temperature = 0.3,
        top_p = 0.9
        )
        # print(chat_completion.choices[0].message.content)
        v1 = []
        v2 = []
        v2.append("Trending News: " + str(formatted_date_out1) + " : " + title)
        v2.append(chat_completion.choices[0].message.content)
        v2.append(filename)
        v2.append(tuple(article_group))
        v2.append(language)
        v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v7_all_article_summary_8hours (title, summary, filename,article_group,language) VALUES (%s, %s, %s, %s)"
        create_conn_destination(v1_insert_query, v1)

def create_latest_8hours_de():
    language = 'de'
    latest_8hours = f"""
    select count(a.*) from synopse_articles.t_v7_all_article_summary_8hours a where a.created_at > (now() - '10:00:00'::interval) and a.language = '{language}';
    """
    latest_8hours_output = select_conn_destination(latest_8hours)

    if latest_8hours_output[0][0] > 0:
        esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
        client = openai.OpenAI(
            base_url = "https://api.endpoints.anyscale.com/v1",
            api_key = esecret_ANYSCALE_API_KEY
        )
        now_utc = datetime.utcnow()
        formatted_date = now_utc.strftime('%Y%m%d%H')
        formatted_date_out1 = now_utc.strftime('%B %d') + suffix(now_utc.day)  + ', ' + get_part_of_day(now_utc.hour)
        date_int = int(formatted_date)
        article1 = f"""
        SELECT COALESCE(count(a.*), 0), b.article_group_id, b.title, b.summary
        FROM synopse_articles.t_v4_article_groups_l2_detail AS b
        JOIN synopse_realtime.t_user_article_views AS a
        ON a.article_group_id = b.article_group_id
        and (a.created_at > (now() - '15:00:00'::interval) OR a.created_at IS NULL)
        and b.language = '{language}'
        group by b.article_group_id, b.title, b.summary
        order by COALESCE(count(a.*), 0) desc, b.article_group_id desc
        LIMIT 10;"""
        art1 = ""
        article1_output = select_conn_destination(article1)
        title = ""
        article_group = []
        for j in range(len(article1_output)):
            article_group.append(article1_output[j][1])
            title += f"{article1_output[j][2]}\n"
            art1 += f"{article1_output[j][2]} - {article1_output[j][3]}\n"
        filename = "trending_ " + str(language) + "_" + str(date_int) + ".wav"
        system_prompt = """
        Sie sind Nachrichtensprecher und berichten über Trendnachrichten und müssen ein Transcript für einen Nachrichtensprecher mit etwa 150 Wörtern bereitstellen.
          Erfassen Sie etwa 5 bis 7 Schlüsselpunkte, betrachten Sie unterschiedliche Perspektiven und präsentieren Sie sachliche Informationen ohne persönliche Meinung.
          Die Schlüsselpunkte sollten informativ und ansprechend sein, während die Schlüsselpunkte für den Inhalt des Artikels relevant sein.
          Denken Sie daran, Neutralität anzustreben und gleichzeichnet engagiert und informativ zu bleiben, um sich auf sachliche Informationen zu konzentrieren und emotionale Sprache oder Sensationsgier zu vermeiden.
          Verwenden Sie eine aktive Stimme und prägnante Sätze für maximale Klarheit, um zurückzugreifen, dass die Zusammenfassung leicht verständlich ist.
          Einführung und Einführung in das Skript. Hier sind einige Beispiel-Einführungszeilen, die eine ähnliche Einleitung für das Skript ändern und bereitstellen

         "Guten Abend und willkommen zur heutigen Ausgabe der Trendnachrichten. Es ist """ + str(formatted_date_out1) + """ und wir haben die neuesten Updates zu Geschichten, die rund um den Globus für Aufsehen sorgen."
         "Hallo, und vielen Dank, dass Sie sich uns angeschlossen haben, um aktuelle Neuigkeiten zu diesem Thema zu erhalten. Von bahnbrechenden Entwicklungen bis hin zu viralen Sensationen sind Sie bei uns genau richtig."
         "Aus dem Herzen der Nachrichtenredaktion ist dies Ihr Update zu den angesagten Schlagzeilen für """ + str(formatted_date_out1) + """. Bleiben Sie gespannt, während wir uns mit den Geschichten befassen, die die Aufmerksamkeit der Welt auf sich ziehen."
         "Willkommen zu unserer Sendung zu diesem """ + str(formatted_date_out1) + """, in der wir Ihnen die heißesten Themen präsentieren, die Social-Media-Feeds und Nachrichtenzyklen gleichermaßen dominieren."
         "Es ist """ + str(formatted_date_out1) + """ , und Sie sind auf unserem Trendnachrichtensegment eingestellt. Bleiben Sie bei uns, während wir die am meisten diskutierten Geschichten des Tages erkunden."
         "Guten Tag allerseits und vielen Dank, dass Sie sich uns angeschlossen haben, um aktuelle Neuigkeiten zu erfahren. Ich bin hier, um Ihnen die neuesten Trends und Updates aus der ganzen Welt ab """ + str(formatted_date_out1) + """ zu präsentieren."
         "Grüße, Zuschauer. Lassen Sie uns zu Beginn von """ + str(formatted_date_out1) + """ in die angesagten Nachrichten eintauchen, die Schlagzeilen machen und weltweit Gespräche anregen."
         "Willkommen an Bord unseres angesagten Nachrichten-Express. Schnallen Sie sich an, während wir durch die Top-Storys navigieren, die das Internet und den Äther auf diesem """ + str(formatted_date_out1) + """ dominieren."
         "Es ist """ + str(formatted_date_out1) + """ und Sie sehen sich unsere Zusammenfassung der Trendnachrichten an. Bleiben Sie dabei, während wir die wichtigsten Ereignisse und Trendthemen des Tages vorstellen."
         "Hallo und herzlich willkommen in unserem Trendnachrichtensegment. In diesem """ + str(formatted_date_out1) + """ sind wir hier, um Sie über die Geschichten auf dem Laufenden zu halten, über die alle reden."
         Das gesamte Skript sollte maximal 350 Wörter umfassen.
        """
        user_prompt = "all article data: " +  art1
        chat_completion = client.chat.completions.create(
        model="mistralai/Mixtral-8x7B-Instruct-v0.1",
        messages=[{"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}],
        max_tokens = 1000,
        temperature = 0.3,
        top_p = 0.9
        )
        # print(chat_completion.choices[0].message.content)
        v1 = []
        v2 = []
        v2.append("Trending News: " + str(formatted_date_out1) + " : " + title)
        v2.append(chat_completion.choices[0].message.content)
        v2.append(filename)
        v2.append(tuple(article_group))
        v2.append(language)
        v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v7_all_article_summary_8hours (title, summary, filename,article_group,language) VALUES (%s, %s, %s, %s)"
        create_conn_destination(v1_insert_query, v1)


def create_latest_8hours_hin():
    language = 'hin'
    latest_8hours = f"""
    select count(a.*) from synopse_articles.t_v7_all_article_summary_8hours a where a.created_at > (now() - '10:00:00'::interval) and a.language = '{language}';
    """
    latest_8hours_output = select_conn_destination(latest_8hours)

    if latest_8hours_output[0][0] > 0:
        esecret_ANYSCALE_API_KEY = "as"
        client = openai.OpenAI(
            api_key = esecret_ANYSCALE_API_KEY
        )
        now_utc = datetime.utcnow()
        formatted_date = now_utc.strftime('%Y%m%d%H')
        formatted_date_out1 = now_utc.strftime('%B %d') + suffix(now_utc.day)  + ', ' + get_part_of_day(now_utc.hour)
        date_int = int(formatted_date)
        article1 = f"""
        SELECT COALESCE(count(a.*), 0), b.article_group_id, b.title, b.summary
        FROM synopse_articles.t_v4_article_groups_l2_detail AS b
        JOIN synopse_realtime.t_user_article_views AS a
        ON a.article_group_id = b.article_group_id
        and (a.created_at > (now() - '15:00:00'::interval) OR a.created_at IS NULL)
        and b.language = '{language}'
        group by b.article_group_id, b.title, b.summary
        order by COALESCE(count(a.*), 0) desc, b.article_group_id desc
        LIMIT 10;"""
        art1 = ""
        article1_output = select_conn_destination(article1)
        title = ""
        article_group = []
        for j in range(len(article1_output)):
            article_group.append(article1_output[j][1])
            title += f"{article1_output[j][2]}\n"
            art1 += f"{article1_output[j][2]} - {article1_output[j][3]}\n"
        filename = "trending_ " + str(language) + "_" + str(date_int) + ".wav"
        system_prompt = """
        आप न्यूज़ एंकर हैं जो ट्रेंडिंग न्यूज़ की रिपोर्टिंग कर रहे हैं और आपको न्यूज़ एंकर के लिए लगभग 150 शब्दों की एक प्रतिलिपि प्रदान करनी होगी।
         व्यक्तिगत राय के बिना तथ्यात्मक जानकारी प्रदर्शित करते हुए विविध दृष्टिकोणों को स्वीकार करते हुए लगभग 5 से 7 प्रमुख बिंदुओं को कैप्चर करें।
         मुख्य बिंदु जानकारीपूर्ण और आकर्षक होने चाहिए, जबकि कीवर्ड बिंदु लेख की सामग्री के लिए प्रासंगिक होने चाहिए।
         भावनात्मक भाषा या सनसनीखेज से बचकर तथ्यात्मक जानकारी पर ध्यान केंद्रित करने के लिए आकर्षक और जानकारीपूर्ण रहते हुए तटस्थता का प्रयास करना याद रखें।
         यह सुनिश्चित करने के लिए कि सारांश आसानी से समझ में आ जाए, अधिकतम स्पष्टता के लिए सक्रिय आवाज़ और संक्षिप्त वाक्यों का उपयोग करें।
         स्क्रिप्ट के लिए परिचय और परिचय प्रदान करें और यहां कुछ नमूना परिचय पंक्तियां संशोधित की गई हैं और स्क्रिप्ट के लिए एक समान परिचय प्रदान करती हैं

         "शुभ संध्या और ट्रेंडिंग न्यूज़ के आज रात के संस्करण में आपका स्वागत है। यह """ + str(formatted_date_out1) + """ है, और हमें दुनिया भर में हलचल मचाने वाली कहानियों पर नवीनतम अपडेट मिले हैं।"
         "नमस्कार, और इस """ + str(formatted_date_out1) + """ पर ट्रेंडिंग समाचारों के लिए हमसे जुड़ने के लिए धन्यवाद। ब्रेकिंग डेवलपमेंट से लेकर वायरल संवेदनाओं तक, हमने आपको कवर किया है।"
         "न्यूज़रूम के दिल से, यह """ + str(formatted_date_out1) + """ के लिए ट्रेंडिंग हेडलाइंस पर आपका अपडेट है। हम दुनिया का ध्यान आकर्षित करने वाली कहानियों पर ध्यान केंद्रित कर रहे हैं।
         "इस """ + str(formatted_date_out1) + """ पर हमारे प्रसारण में आपका स्वागत है, जहां हम आपके लिए सोशल मीडिया फ़ीड और समाचार चक्रों पर समान रूप से हावी होने वाले सबसे गर्म विषय लाते हैं।"
         "यह """ + str(formatted_date_out1) + """ है, और आप हमारे ट्रेंडिंग न्यूज़ सेगमेंट में शामिल हो गए हैं। हमारे साथ बने रहें क्योंकि हम दिन की सबसे चर्चित कहानियों का पता लगाते हैं।"
         "सभी को शुभ दिन, और ट्रेंडिंग न्यूज़ के लिए हमारे साथ जुड़ने के लिए धन्यवाद। मैं यहां आपके लिए """ + str(formatted_date_out1) + """ जैसी दुनिया भर से नवीनतम चर्चा और अपडेट लाने के लिए हूं।"
         "नमस्कार, दर्शकों। जैसे ही हम """ + str(formatted_date_out1) + """ की शुरुआत करते हैं, आइए विश्व स्तर पर सुर्खियाँ बनाने वाली और चर्चाओं को बढ़ावा देने वाली ट्रेंडिंग समाचार कहानियों पर गौर करें।
         "हमारे ट्रेंडिंग न्यूज़ एक्सप्रेस में आपका स्वागत है। जैसे ही हम इस """ + str(formatted_date_out1) + """ पर इंटरनेट और एयरवेव्स पर हावी होने वाली शीर्ष कहानियों के माध्यम से नेविगेट करते हैं, कमर कस लें।"
         "यह """ + str(formatted_date_out1) + """ है, और आप हमारा ट्रेंडिंग न्यूज़ राउंडअप देख रहे हैं। जब तक हम दिन की सबसे महत्वपूर्ण घटनाओं और ट्रेंडिंग विषयों को उजागर करते हैं, तब तक बने रहें।"
         "नमस्कार, और हमारे ट्रेंडिंग न्यूज़ सेगमेंट में आपका हार्दिक स्वागत है। इस """ + str(formatted_date_out1) + """ पर, हम आपको उन कहानियों के बारे में बताने के लिए यहां हैं जिनके बारे में हर कोई बात कर रहा है।"
         संपूर्ण स्क्रिप्ट अधिकतम 350 शब्दों की होनी चाहिए।
        """
        user_prompt = "all article data: " +  art1
        chat_completion = client.chat.completions.create(
          model="gpt-3.5-turbo",
          messages=[{"role": "system", "content": system_prompt},
                      {"role": "user", "content": user_prompt}],
          # max_tokens = 2048,
          temperature = 0.3 + (t6 * 0.1),
          top_p = 0.9,
        )
        # print(chat_completion.choices[0].message.content)
        v1 = []
        v2 = []
        v2.append("Trending News: " + str(formatted_date_out1) + " : " + title)
        v2.append(chat_completion.choices[0].message.content)
        v2.append(filename)
        v2.append(tuple(article_group))
        v2.append(language)
        v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v7_all_article_summary_8hours (title, summary, filename,article_group,language) VALUES (%s, %s, %s, %s)"
        create_conn_destination(v1_insert_query, v1)

def create_latest_8hours_tel():
    language = 'tel'
    latest_8hours = f"""
    select count(a.*) from synopse_articles.t_v7_all_article_summary_8hours a where a.created_at > (now() - '10:00:00'::interval) and a.language = '{language}';
    """
    latest_8hours_output = select_conn_destination(latest_8hours)

    if latest_8hours_output[0][0] > 0:
        esecret_ANYSCALE_API_KEY = "as"
        client = openai.OpenAI(
            api_key = esecret_ANYSCALE_API_KEY
        )
        now_utc = datetime.utcnow()
        formatted_date = now_utc.strftime('%Y%m%d%H')
        formatted_date_out1 = now_utc.strftime('%B %d') + suffix(now_utc.day)  + ', ' + get_part_of_day(now_utc.hour)
        date_int = int(formatted_date)
        article1 = f"""
        SELECT COALESCE(count(a.*), 0), b.article_group_id, b.title, b.summary
        FROM synopse_articles.t_v4_article_groups_l2_detail AS b
        JOIN synopse_realtime.t_user_article_views AS a
        ON a.article_group_id = b.article_group_id
        and (a.created_at > (now() - '15:00:00'::interval) OR a.created_at IS NULL)
        and b.language = '{language}'
        group by b.article_group_id, b.title, b.summary
        order by COALESCE(count(a.*), 0) desc, b.article_group_id desc
        LIMIT 10;"""
        art1 = ""
        article1_output = select_conn_destination(article1)
        title = ""
        article_group = []
        for j in range(len(article1_output)):
            article_group.append(article1_output[j][1])
            title += f"{article1_output[j][2]}\n"
            art1 += f"{article1_output[j][2]} - {article1_output[j][3]}\n"
        filename = "trending_ " + str(language) + "_" + str(date_int) + ".wav"
        system_prompt = """
        మీరు ట్రెండింగ్ వార్తలను నివేదించే న్యూస్ యాంకర్ మరియు మీరు దాదాపు 150 పదాలతో న్యూస్ యాంకర్ కోసం ట్రాన్స్క్రిప్ట్ అందించాలి.
         వ్యక్తిగత అభిప్రాయం లేకుండా వాస్తవ సమాచారాన్ని ప్రదర్శించే విభిన్న దృక్కోణాలను అంగీకరిస్తూ 5 నుండి 7 కీలక అంశాలను క్యాప్చర్ చేయండి.
         కీలకాంశాలు సమాచారం మరియు ఆకర్షణీయంగా ఉండాలి, అయితే కీవర్డ్ పాయింట్లు కథనాల కంటెంట్‌కు సంబంధించినవిగా ఉండాలి.
         ఉద్వేగభరితమైన భాష లేదా సంచలనాత్మకతను నివారించడం ద్వారా వాస్తవ సమాచారంపై దృష్టి కేంద్రీకరించడానికి నిమగ్నమై మరియు సమాచారంగా ఉంటూనే తటస్థత కోసం ప్రయత్నించాలని గుర్తుంచుకోండి.
         సారాంశాన్ని సులభంగా అర్థం చేసుకోవడానికి గరిష్ట స్పష్టత కోసం క్రియాశీల వాయిస్ మరియు సంక్షిప్త వాక్యాలను ఉపయోగించండి.
         స్క్రిప్ట్‌ను అందించండి మరియు పరిచయం చేయండి మరియు ఇక్కడ కొన్ని నమూనా పరిచయ పంక్తులు సవరించబడ్డాయి మరియు స్క్రిప్ట్‌కు సారూప్య పరిచయాన్ని అందిస్తాయి

         "శుభా సాయంత్రం మరియు ట్రెండింగ్ వార్తల యొక్క ఈ రాత్రి ఎడిషన్‌కు స్వాగతం. ఇది """ + str(formatted_date_out1) + """ , మరియు ప్రపంచవ్యాప్తంగా సంచలనం సృష్టించే కథనాలకు సంబంధించిన తాజా నవీకరణలను మేము పొందాము."
         "హలో, మరియు ఈ """ + str(formatted_date_out1) + """ గురించి ట్రెండింగ్ వార్తల కోసం మాతో చేరినందుకు ధన్యవాదాలు. బ్రేకింగ్ డెవలప్‌మెంట్‌ల నుండి వైరల్ సెన్సేషన్‌ల వరకు, మేము మిమ్మల్ని కవర్ చేసాము."
         "న్యూస్‌రూమ్ హృదయం నుండి, ఇది """ + str(formatted_date_out1) + """ కోసం ట్రెండింగ్ హెడ్‌లైన్‌లకు సంబంధించిన మీ అప్‌డేట్. ప్రపంచం దృష్టిని ఆకర్షించే కథనాలను మేము పరిశీలిస్తున్నప్పుడు గట్టిగా ఉండండి."
         "ఇది """ + str(formatted_date_out1) + """ , మరియు మీరు మా ట్రెండింగ్ వార్తల విభాగానికి ట్యూన్ చేసారు. మేము రోజులో ఎక్కువగా మాట్లాడే కథనాలను అన్వేషించేటప్పుడు మాతో ఉండండి."
         "శుభ రోజు, అందరికీ మరియు ట్రెండింగ్ వార్తల కోసం మాతో చేరినందుకు ధన్యవాదాలు. """ + str(formatted_date_out1) + """ నాటికి ప్రపంచవ్యాప్తంగా ఉన్న తాజా buzz మరియు నవీకరణలను మీకు అందించడానికి నేను ఇక్కడ ఉన్నాను.
         "శుభాకాంక్షలు, వీక్షకులు. ""
         "మా ట్రెండింగ్ న్యూస్ ఎక్స్‌ప్రెస్‌కి స్వాగతం. ఈ """ + str(formatted_date_out1) + """ పై ఇంటర్నెట్ మరియు ఎయిర్‌వేవ్‌లలో ఆధిపత్యం చెలాయించే అగ్ర కథనాల ద్వారా మేము నావిగేట్ చేస్తున్నప్పుడు అప్ చేయండి.
         "ఇది """ + str(formatted_date_out1) + """ , మరియు మీరు మా ట్రెండింగ్ వార్తల రౌండప్‌ను చూస్తున్నారు. మేము రోజు యొక్క అత్యంత ముఖ్యమైన ఈవెంట్‌లు మరియు ట్రెండింగ్ టాపిక్‌లను అన్‌ప్యాక్ చేస్తూనే ఉండండి."
         "హలో, మరియు మా ట్రెండింగ్ వార్తల విభాగానికి హృదయపూర్వక స్వాగతం. ఈ """ + str(formatted_date_out1) + """ , ప్రతి ఒక్కరూ మాట్లాడుకునే కథనాలను వేగవంతం చేయడానికి మేము ఇక్కడ ఉన్నాము."
         మొత్తం స్క్రిప్ట్ గరిష్టంగా 350 పదాలు ఉండాలి.
        """
        user_prompt = "all article data: " +  art1
        chat_completion = client.chat.completions.create(
          model="gpt-3.5-turbo",
          messages=[{"role": "system", "content": system_prompt},
                      {"role": "user", "content": user_prompt}],
          # max_tokens = 2048,
          temperature = 0.3 + (t6 * 0.1),
          top_p = 0.9,
        )
        # print(chat_completion.choices[0].message.content)
        v1 = []
        v2 = []
        v2.append("Trending News: " + str(formatted_date_out1) + " : " + title)
        v2.append(chat_completion.choices[0].message.content)
        v2.append(filename)
        v2.append(tuple(article_group))
        v2.append(language)
        v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v7_all_article_summary_8hours (title, summary, filename,article_group,language) VALUES (%s, %s, %s, %s)"
        create_conn_destination(v1_insert_query, v1)

def create_latest_8hours_tam():
    language = 'tam'
    latest_8hours = f"""
    select count(a.*) from synopse_articles.t_v7_all_article_summary_8hours a where a.created_at > (now() - '10:00:00'::interval) and a.language = '{language}';
    """
    latest_8hours_output = select_conn_destination(latest_8hours)

    if latest_8hours_output[0][0] > 0:
        esecret_ANYSCALE_API_KEY = "as"
        client = openai.OpenAI(
            api_key = esecret_ANYSCALE_API_KEY
        )
        now_utc = datetime.utcnow()
        formatted_date = now_utc.strftime('%Y%m%d%H')
        formatted_date_out1 = now_utc.strftime('%B %d') + suffix(now_utc.day)  + ', ' + get_part_of_day(now_utc.hour)
        date_int = int(formatted_date)
        article1 = f"""
        SELECT COALESCE(count(a.*), 0), b.article_group_id, b.title, b.summary
        FROM synopse_articles.t_v4_article_groups_l2_detail AS b
        JOIN synopse_realtime.t_user_article_views AS a
        ON a.article_group_id = b.article_group_id
        and (a.created_at > (now() - '15:00:00'::interval) OR a.created_at IS NULL)
        and b.language = '{language}'
        group by b.article_group_id, b.title, b.summary
        order by COALESCE(count(a.*), 0) desc, b.article_group_id desc
        LIMIT 10;"""
        art1 = ""
        article1_output = select_conn_destination(article1)
        title = ""
        article_group = []
        for j in range(len(article1_output)):
            article_group.append(article1_output[j][1])
            title += f"{article1_output[j][2]}\n"
            art1 += f"{article1_output[j][2]} - {article1_output[j][3]}\n"
        filename = "trending_ " + str(language) + "_" + str(date_int) + ".wav"
        system_prompt = """
        நீங்கள் பிரபலமான செய்திகளைப் புகாரளிக்கும் செய்தி தொகுப்பாளர் மற்றும் நீங்கள் ஒரு செய்தி தொகுப்பாளருக்கு சுமார் 150 வார்த்தைகளைக் கொண்ட டிரான்ஸ்கிரிப்டை வழங்க வேண்டும்.
         தனிப்பட்ட கருத்து இல்லாமல் உண்மைத் தகவலைக் காண்பிக்கும் பல்வேறு முன்னோக்குகளை ஒப்புக்கொண்டு 5 முதல் 7 முக்கிய புள்ளிகளைப் பிடிக்கவும்.
         முக்கிய புள்ளிகள் தகவல் மற்றும் ஈர்க்கக்கூடியதாக இருக்க வேண்டும், அதே சமயம் முக்கிய குறிப்புகள் கட்டுரைகளின் உள்ளடக்கத்துடன் தொடர்புடையதாக இருக்க வேண்டும்.
         உணர்ச்சிப்பூர்வமான மொழி அல்லது பரபரப்பானதைத் தவிர்ப்பதன் மூலம் உண்மைத் தகவலில் கவனம் செலுத்துவதற்கு ஈடுபாட்டுடனும் தகவலறிந்ததாகவும் இருக்கும் போது நடுநிலைமைக்காக பாடுபடுவதை நினைவில் கொள்ளுங்கள்.
         சுருக்கம் எளிதில் புரிந்து கொள்ளப்படுவதை உறுதிசெய்ய, அதிகபட்ச தெளிவுக்காக செயலில் குரல் மற்றும் சுருக்கமான வாக்கியங்களைப் பயன்படுத்தவும்.
         ஸ்கிரிப்டை வழங்குதல் மற்றும் அறிமுகம் செய்தல் மற்றும் சில மாதிரி அறிமுக வரிகளை மாற்றியமைத்து, ஸ்கிரிப்ட்டுக்கு ஒத்த அறிமுகத்தை வழங்கவும்

         "நல்ல மாலை வணக்கம் மற்றும் இன்றிரவு ட்ரெண்டிங் செய்திகளின் பதிப்பிற்கு வரவேற்கிறோம். இது """ + str(formatted_date_out1) + """ , மேலும் உலகம் முழுவதும் அலைகளை உருவாக்கும் கதைகள் பற்றிய சமீபத்திய புதுப்பிப்புகளைப் பெற்றுள்ளோம்."
         "வணக்கம், மேலும் இந்த """ + str(formatted_date_out1) + """ பற்றிய ட்ரெண்டிங் செய்திகளுக்காக எங்களுடன் இணைந்தமைக்கு நன்றி
         "செய்தி அறையின் இதயத்திலிருந்து, இது """ + str(formatted_date_out1) + """ க்கான டிரெண்டிங் தலைப்புச் செய்திகள் பற்றிய உங்களின் புதுப்பிப்பு. உலகின் கவனத்தை ஈர்க்கும் கதைகளை நாங்கள் ஆராய்ந்து பார்க்கும்போது அமைதியாக இருங்கள்."
         "இது """ + str(formatted_date_out1) + """ , மேலும் எங்களின் பிரபல செய்திப் பிரிவில் நீங்கள் இணைந்திருக்கிறீர்கள். இந்த நாளில் அதிகம் பேசப்படும் செய்திகளை நாங்கள் ஆராய எங்களுடன் இருங்கள்."
         "நல்ல நாள், அனைவருக்கும், மேலும் ட்ரெண்டிங் செய்திகளுக்காக எங்களுடன் இணைந்ததற்கு நன்றி. """ + str(formatted_date_out1) + """ இன் உலகெங்கிலும் உள்ள சமீபத்திய சலசலப்பு மற்றும் புதுப்பிப்புகளை உங்களுக்குக் கொண்டு வர நான் இங்கு வந்துள்ளேன்.
         "வாழ்த்துக்கள், பார்வையாளர்களே. """ + str(formatted_date_out1) + """ , உலகளவில் தலைப்புச் செய்திகள் மற்றும் உரையாடல்களைத் தூண்டும் பிரபலமான செய்திகளில் மூழ்குவோம்."
         "எங்கள் ட்ரெண்டிங் நியூஸ் எக்ஸ்பிரஸ் கப்பலுக்கு வரவேற்கிறோம். இந்த """ + str(formatted_date_out1) + """ இல் இணையம் மற்றும் அலைக்கற்றைகளில் ஆதிக்கம் செலுத்தும் முக்கிய செய்திகள் மூலம் செல்லவும்.
         "இது """ + str(formatted_date_out1) + """ , மேலும் எங்களின் பிரபலமான செய்தி ரவுண்டப்பை நீங்கள் பார்க்கிறீர்கள். அன்றைய மிக முக்கியமான நிகழ்வுகள் மற்றும் பிரபலமான தலைப்புகளை நாங்கள் பிரித்தெடுக்கும் வரை தொடர்ந்து இருங்கள்."
         "வணக்கம், எங்களின் டிரெண்டிங் செய்திப் பிரிவுக்கு அன்பான வரவேற்பு. இந்த """ + str(formatted_date_out1) + """ இல், அனைவரும் பேசும் கதைகளை உங்களுக்கு விரைவுபடுத்த நாங்கள் இங்கு வந்துள்ளோம்."
         முழு ஸ்கிரிப்டும் அதிகபட்சம் 350 வார்த்தைகள் இருக்க வேண்டும்.
        """
        user_prompt = "all article data: " +  art1
        chat_completion = client.chat.completions.create(
          model="gpt-3.5-turbo",
          messages=[{"role": "system", "content": system_prompt},
                      {"role": "user", "content": user_prompt}],
          # max_tokens = 2048,
          temperature = 0.3 + (t6 * 0.1),
          top_p = 0.9,
        )
        # print(chat_completion.choices[0].message.content)
        v1 = []
        v2 = []
        v2.append("Trending News: " + str(formatted_date_out1) + " : " + title)
        v2.append(chat_completion.choices[0].message.content)
        v2.append(filename)
        v2.append(tuple(article_group))
        v2.append(language)
        v1.append(tuple(v2))
        v1_insert_query ="INSERT INTO synopse_articles.t_v7_all_article_summary_8hours (title, summary, filename,article_group,language) VALUES (%s, %s, %s, %s)"
        create_conn_destination(v1_insert_query, v1)

if __name__ == "__main__":
    print("extract data from rss feeds")
    q1 = """select outlet from synopse_articles.t_v1_outlets;"""
    q1_out = create_conn_source(q1)
    outlets = [item[0] for item in q1_out]
    argss = []
    argsss = outlets

    for i in range(0, len(argsss), 10):
        argss.append(argsss[i:i+10])
    print(argss)
    processes = []
    for args in argss:
      for arg in args:
          process = multiprocessing.Process(target=update_articles, args=(arg,))
          processes.append(process)
          process.start()
      for process in processes:
          process.join()

    print("set all in detail")
    args = [0,300,600,900,1200,1500,1800,2100]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=set_all_in_detail, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("summerizer")
    args = [0,300,600,900,1200,1500,1800,2100]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=summerizer_under_300, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()
    args = [0,300,600,900,1200,1500,1800,2100]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=summerizer_over_300, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()
    args = [0,300,600,900,1200,1500,1800,2100]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=set_all_summerize, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("vectorizing english")
    set_start_method('spawn', force=True)
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=vectorize_en, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("vectorizing telugu")
    set_start_method('spawn', force=True)
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=vectorize_tel, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()


    print("vectorizing hindi")
    set_start_method('spawn', force=True)
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=vectorize_hin, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("vectorizing tamil")
    set_start_method('spawn', force=True)
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=vectorize_tam, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("vectorizing german")
    set_start_method('spawn', force=True)
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=vectorize_de, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l1_en")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1_en, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l1_hi")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1_hin, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l1_tel")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1_tel, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l1_tam")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1_tam, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l1_de")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1_de, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("grouping_l2")
    grouping_l2()


    print("gen final article_en")
    args = [0,10,20,30,40,50,60,70]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=gen_final_article_en, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()


    print("gen final article_de")
    args = [0,10,20,30,40,50,60,70]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=gen_final_article_de, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("gen final article_tel")
    gen_final_article_tel(0)
    print("gen final article_tam")
    gen_final_article_tam(0)
    print("gen final article_hin")
    gen_final_article_hin(0)

    print("tagging en")
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=ai_tagging_groups_bertwiki_en, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()


    print("tagging not en")
    n1 =  0
    mod = 50
    n2 = 4
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=ai_tagging_groups_bertwiki_nen, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    print("detail tags")
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
        args.append((i * mod) + offset)
    print(args)
    # Create a list to hold the processes
    processes = []
    # Create and start a process for each argument
    for arg in args:
        process = multiprocessing.Process(target=detail_tags, args=(arg,))
        processes.append(process)
        process.start()
    # Wait for all processes to finish
    for process in processes:
        process.join()

    print("PublishDate")
    set_publish_date()
    delete_article_detail()

    print("load to prod")
    load_to_prod()

    print("verify images")
    remove_invalid_images_prod()

    print("tag play and latest 8 hours")
    # create_tag_play()
    create_latest_8hours_en()
    create_latest_8hours_de()
    # create_latest_8hours_hin()
    # create_latest_8hours_tel()
    # create_latest_8hours_tam()
