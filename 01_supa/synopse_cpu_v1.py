%%file articles_main.py

import psycopg2
from psycopg2 import sql
import requests
import feedparser
from datetime import datetime, timezone
import re
from multiprocessing import Process, set_start_method
import multiprocessing
import urllib3
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
from playwright.async_api import async_playwright
import asyncio
import nest_asyncio
from bs4 import BeautifulSoup
import psycopg2
import time  # Import the time module
import gc

nest_asyncio.apply()

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


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
            host="ep-purple-boat-77462220.ap-southeast-1.aws.neon.tech",
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
        # print("Data inserted successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

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

# get data from rss  
def update_articles(outlet):
    print(outlet)
    articles_from_rss = """
    SELECT
        rss1_link,
        rss1_link_name,
        outlet,
        id
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
            v1.append(tuple(v2))

        v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles (rss1_feed_id, post_link, title, summary, author, image_link, post_published) VALUES (%s, %s, %s, %s, %s, %s, %s) ON CONFLICT (post_link) DO NOTHING;"

        insert_conn_source(v1_insert_query, v1)

#reduce articles for details
def set_is_in_Detail_300():
    print("set_is_in_Detail_300")
    i11 = - 1
    while True:
        i11 = i11 + 1
        articles_details = """
          SELECT
            a.id,
            a.title,
            a.summary,
            a.post_link
          FROM
            synopse_articles.v_v6_article_word_count a
          where a.is_in_detail != 1
          and a.total_count > 300
          ORDER BY id DESC
          LIMIT 200 OFFSET """ + str(i11*200) + """;
          """
        articles_details_output = create_conn_source(articles_details)
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
            v1.append(tuple(v2))
            ids.append(articles_details_output[i][0])
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
        v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, title, detail,  final_url ) VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING;"
        insert_conn_source(v1_insert_query, v1)

def summerizer_under_300():
    print("summerizer_under_300")
    i11 = - 1
    while True:
        i11 = i11 + 1
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
          and a.total_count < 300
          and a.detail_count > 25
          ORDER BY id DESC
          LIMIT 200 OFFSET """ + str(i11*200) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        v1 = []
        ids = []
        for i in range(len(articles_details_output)):
            v2 = []
            v2.append(articles_details_output[i][0])
            v2.append(articles_details_output[i][1] + " " + articles_details_output[i][2] + " " + articles_details_output[i][3])
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
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)  ON CONFLICT DO NOTHING;"
        insert_conn_source(v1_insert_query, v1)

def summerizer_under_300_25():
    print("summerizer_under_300_25")
    i11 = - 1
    while True:
        i11 = i11 + 1
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
          and a.total_count < 300
          and a.detail_count <= 25
          ORDER BY id DESC
          LIMIT 200 OFFSET """ + str(i11*200) + """;
          """

        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        v1 = []
        ids = []
        for i in range(len(articles_details_output)):
            v2 = []
            v2.append(articles_details_output[i][0])
            v2.append(articles_details_output[i][1] + " " + articles_details_output[i][2])
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
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)  ON CONFLICT DO NOTHING;"
        insert_conn_source(v1_insert_query, v1)

def set_article_to_no_extract():
    mutation_query = """
    mutation MyMutation($_in: [String!] = ["cnn", "politico", "wsj", "appleinsider", "aljazeera"]) {
      update_synopse_articles_t_v1_rss1_articles_many(updates: {where: {is_in_detail: {_eq: 0}, t_v1_rss1_feed_link: {outlet: {_in: $_in}}}, _set: {is_in_detail: 10}}) {
        affected_rows
      }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def set_article_to_attemp1_1():
    mutation_query = """
    mutation MyMutation {
      update_synopse_articles_t_v1_rss1_articles_many(updates: {where: {is_in_detail: {_eq: 2}, attempt: {_eq: 0}}, _set: {attempt: 1, is_in_detail: 0}}) {
        affected_rows
      }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def set_article_to_attemp1_2():
    mutation_query = """
    mutation MyMutation {
      update_synopse_articles_t_v1_rss1_articles_many(updates: {where: {is_in_detail: {_eq: 2}, attempt: {_eq: 1}}, _set: {attempt: 2, is_in_detail: 1}}) {
        affected_rows
      }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def set_article_to_vmBox():
    mutation_query = """
    mutation MyMutation($_in: [String!] = ["politico","wsj","reuters","appleinsider","cnn"]) {
      update_synopse_articles_t_v1_rss1_articles(where: {is_summerized: {_eq: 0}, is_in_detail: {_eq: 0}, t_v1_rss1_feed_link: {outlet: {_in: $_in}}}, _set: {is_in_detail: 10}) {
        affected_rows
      }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def set_article_to_vmBox1():
    mutation_query = """
    mutation MyMutation($_in: [String!] = ["wsj"]) {
      update_synopse_articles_t_v1_rss1_articles(where: {is_summerized: {_eq: 0}, t_v1_rss1_feed_link: {outlet: {_in: $_in}}, is_in_detail: {_eq: 0}}, _set: {is_in_detail: 1}) {
        affected_rows
      }
    }
    """
    mutation_variables = {
        }
    out1 = mutation_hasura_graphql(endpoint = endpoint, admin_key = admin_key, mutation_query = mutation_query, mutation_variables = mutation_variables)

def reduce_articles():
    set_is_in_Detail_300()
    summerizer_under_300()
    summerizer_under_300_25()
    set_article_to_no_extract()
    set_article_to_attemp1_1()
    set_article_to_attemp1_2()
    set_article_to_vmBox()
    set_article_to_vmBox1()
    
#get article details
async def get_detail(offset):
    # print(offset)
    n = 1
    i = offset * n
    detail_l1 = """
    SELECT
        a.id,
        a.post_link,
        b.outlet
    FROM synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v1_rss1_feed_links b
    WHERE a.rss1_feed_id = b.id AND a.is_in_detail = 0
    AND b.outlet IN ('thehindu', 'the verge', 'nbc', 'timesofindia', 'hindustantimes', 'cbsnews', 'theindianexpress', 'abcnews', 'foxnews', 'nytimes', 'newyorkpost', 'independent', 'espn', 'huffpost', 'wired', 'forbes','wion','thewire','marketwatch', 'thedailybeast', 'thewashingtonpost', 'techcrunch','vox','aljazeera')
    order by a.id
    limit """ + str(n) + """ OFFSET """ + str(i) + """;
    """
    #print(detail)
    while True:
      detail_input = create_conn_source(detail_l1)
      if len(detail_input) == 0:
          break
      id_11 = detail_input[0][0]
      url = detail_input[0][1]
      outlet = detail_input[0][2]
      v1 = []
      v2 = []
      v1.append(id_11)
      try:
        async with async_playwright() as p:
          browser = await p.chromium.launch(headless=True)
          context = await browser.new_context()
          page = await context.new_page()
          try:
              await page.goto(url, timeout=60000)
              await page.wait_for_load_state('domcontentloaded', timeout=60000)
          except:
              try:
                  await page.wait_for_load_state('load', timeout=60000)
              except:
                  print("Network error, retrying...")
                  await asyncio.sleep(2)
          page_content = await page.content()
          soup = BeautifulSoup(page_content, 'html.parser')
          final_url = page.url
          title = ""
          detail = ""
          image_urls = []
          if (outlet == 'thehindu'):
              div = soup.find('div', attrs={'data-url': final_url})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['h3'])]
                for b in body:
                    detail = detail + " " + b
              div = soup.find('div', attrs={'class': "picture verticle"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'itemprop': "articleBody"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                ol_tags = div.find_all('ol', recursive=False)  # recursive=False to get direct children
                for ol in ol_tags:
                    li_tags = ol.find_all('li')
                    for li in li_tags:
                        detail = detail + " " + li.text
          elif (outlet == 'timesofindia'):
            div = soup.find('div', attrs={'class': "okf2Z"})
            if div:
              texts = [element.text for element in div.find_all(['h1'])]
              title = ' '.join(texts)
              source_media = div.find('img')
              if source_media:
                  image_urls.append(source_media.get('src'))
            div = soup.find('div', attrs={'data-articlebody': "1"})
            if div:
              inner_div = div.find('div', attrs={'class': "_s30J clearfix"})
              if inner_div:
                  # Get direct child nodes of the inner_div
                  child_nodes = list(inner_div.children)
                  # Filter out non-text nodes and join remaining text nodes
                  detail =  detail + " " + ''.join([str(node) for node in child_nodes if node.name is None])
          elif (outlet == 'the verge'):
              div = soup.find('article', attrs={'id': "content"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.select('.duet--article--article-body-component > p')]
                for b in body:
                    detail = detail + " " + b
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'nytimes'):
              div = soup.find('article', attrs={'id': "story"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.select("[class$='StoryBodyCompanionColumn'] p")]
                for b in body:
                    detail = detail + " " + b
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'hindustantimes'):
              div = soup.find('div', attrs={'class': "detailPage"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['p', 'h2', 'h3'])]
                detail = detail + " " + ' '.join(body)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'nbc'):
              div = soup.find('header', attrs={'id': "main-article-header"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "RenderKeyPoints-list"})
              if div:
                texts = [element.text for element in div.find_all(['li', 'p'])]
                detail = detail + " " + ' '.join(texts)
              div = soup.find('div', attrs={'data-module': "ArticleBody"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
                  h2_elements = div.find_all('h2')
                  for h2 in h2_elements:
                      detail = detail + " " + h2.text
                  body = [element.text for element in div.select("[class$='group'] p")]
                  for b in body:
                      detail = detail + " " + b
          elif (outlet == 'theindianexpress'):
              div = soup.find('div', attrs={'class': "heading-part"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                texts = [element.text for element in div.find_all(['h2'])]
                detail = detail + ' ' +' '.join(texts)
              div = soup.find('div', attrs={'class': "story_details"})
              if div:
                body = [element.text for element in div.find_all(['p'])]
                detail = ' '.join(body)
              div = soup.find('span', attrs={'class': "custom-caption"})
              if div:
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'cbsnews'):
              div = soup.find('div', attrs={'id': "article-header"})
              if div:
                texts = [element.text for element in div.find_all(['h1' , 'h2'])]
                title = ' '.join(texts)
              div = soup.find('section', attrs={'class': "content__body"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                ol_tags = div.find_all('ol', recursive=False)  # recursive=False to get direct children
                for ol in ol_tags:
                    li_tags = ol.find_all('li')
                    for li in li_tags:
                        detail = detail + " " + li.text
                text = [element.text for element in div.find_all(['h1' , 'h2', 'h3', 'h4','h5'])]
                detail = detail + " " + ' '.join(text)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'foxnews'):
              div = soup.find('div', attrs={'class': "article-meta article-meta-upper"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                texts = [element.text for element in div.find_all(['h2'])]
                detail = detail + ' '.join(texts)
              div = soup.find('div', attrs={'class': "article-body"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))

          elif (outlet == 'abcnews'):
              div = soup.find('div', attrs={'data-testid': "prism-GridColumn"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['h2', 'h3', 'p'])]
                detail = detail + " " + ' '.join(body)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'independent'):
              div = soup.find('header', attrs={'id': "articleHeader"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'id': "main"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet == 'newyorkpost'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "single__content entry-content m-bottom"})
              if div:
                  text1 = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'], recursive=False)]
                  detail = detail + " " + ' '.join(text1)
              div = soup.find('figure', attrs={'class': "featured-image__figure"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "nyp-slideshow-modal-image__wrapper"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet == 'thewashingtonpost'):
              div = soup.find('h1', attrs={'id': "main-content"})
              if div:
                  texts = [element.text for element in div.find_all('span', attrs={'data-qa': "headline-text"})]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'data-qa': "lede-art"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      urls = source_media.get('srcset').split(',')
                      last_url = urls[-1].split(' ')[0]
                      image_urls.append(last_url)
              div = soup.find('div', attrs={'class': "grid-body"})
              if div:
                  body = [element.text for element in div.select("[data-qa$='article-body'] p")]
                  for b in body:
                      detail = detail + " " + b
          elif (outlet =='huffpost'):
              div = soup.find('div', attrs={'id': "entry-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('section', attrs={'class': "entry__content-list js-entry-content js-cet-subunit"})
              if div:
                  body = [element.text for element in div.select("[class$='primary-cli cli cli-text'] p")]
                  for b in body:
                      detail = detail + " " + b
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet =='espn'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "article-body"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('source')
                  if source_media:
                      urls = source_media.get('srcset')
                      if urls:
                          url_list = urls.split(',')
                          last_url = url_list[-1].strip().split(' ')[0]
                          image_urls.append(last_url)
          elif (outlet =='wired'):
              div = soup.find('div', attrs={'data-testid': "ContentHeaderContainer"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "body__inner-container"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet =='politico'):
              div = soup.find('figure', attrs={'class': "card-lead"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "post-card"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
                  p_tags = div.find_all('p')
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='wion'):
              div = soup.find('div', attrs={'class': "article-heading"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
              main_div = soup.find('div', attrs={'class': "article-main-data"})
              if main_div:
                  inner_divs = main_div.find_all('div', attrs={'class': None})
                  for div in inner_divs:
                      p_tags = div.find_all('p')
                      for p in p_tags:
                          detail = detail + " " + p.text
          elif (outlet =='thewire'):
              div = soup.find('div', attrs={'class': "postComplete__post-header-wrapper"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "postComplete__post-image-wrapper"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "grey-text"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      span_tags = p.find_all('span')
                      for span in span_tags:
                          detail = detail + " " + span.text
          elif (outlet =='marketwatch'):
              div = soup.find('div', attrs={'aria-label': "article header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "article__figure"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'itemprop': "articleBody"})
              if main_div:
                  p_tags = main_div.find_all('p')
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='aljazeera'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('figure', attrs={'class': "article-featured-image"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append("https://www.aljazeera.com/" +source_media.get('src'))
              main_div = soup.find('div', attrs={'aria-atomic': "true"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='techcrunch'):
              div = soup.find('div', attrs={'class': "article__title-wrapper"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
                  texts_1 = [element.text for element in div.find_all(['h2', 'h3', 'p'])]
                  detail = detail + " " + ' '.join(texts_1)
              div = soup.find('div', attrs={'class': "article__content-outer"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "article-content"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='vox'):
              div = soup.find('div', attrs={'class': "c-entry-hero c-entry-hero--default"})
              if div:
                  texts = [element.text for element in div.find_all(['h1'])]
                  title = ' '.join(texts)
              div = soup.find('span', attrs={'class': "e-image__inner"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "c-entry-content"})
              if main_div:
                  p_tags = main_div.find_all(['p','h3'], recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='forbes'):
              div = soup.find('div', attrs={'class': "article-headline-container"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "image-embed__placeholder"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "article-body fs-article fs-responsive-text current-article"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='thedailybeast'):
              div = soup.find('div', attrs={'data-testid': "StoryHeader"})
              if div:
                  texts = [element.text for element in div.find_all(['h1'])]
                  title = ' '.join(texts)
                  texts = [element.text for element in div.find_all(['h2'])]
                  detail = detail + ' ' +' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "Mobiledoc"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          if len(detail) < 10:
              await page.close()
              q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_in_detail = 10
                WHERE id = {id_11};"""
              update_conn_source(q2)
          else:
              v1.append(final_url)
              v1.append(title)
              v1.append(detail)
              v1.append(image_urls)
              v2.append(tuple(v1))

              ids_t = tuple(v2)
            #   print(ids_t)
              q1 = "INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, final_url, title, detail, image_link) VALUES (%s, %s, %s, %s, %s)"
              inser_conn_source(q1, ids_t)
              q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_in_detail = 1
                WHERE id = {id_11};"""
              update_conn_source(q2)
              await page.close()
      except:
          q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_in_detail = 9
            WHERE id = {id_11};"""
          update_conn_source(q2)

def run_parallel(offset):
    asyncio.run(get_detail(offset))

#get article details _retry
async def get_detail2(offset):
    # print(offset)
    n = 1
    i = offset * n
    detail_l1 = """
    SELECT
        a.id,
        a.post_link,
        b.outlet
    FROM synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v1_rss1_feed_links b
    WHERE a.rss1_feed_id = b.id AND a.is_in_detail = 9
    AND b.outlet IN ('thehindu', 'the verge', 'nbc', 'timesofindia', 'hindustantimes', 'cbsnews', 'theindianexpress', 'abcnews', 'foxnews', 'nytimes', 'newyorkpost', 'independent', 'espn', 'huffpost', 'wired', 'forbes','wion','thewire','marketwatch', 'thedailybeast', 'thewashingtonpost', 'techcrunch','vox','aljazeera')
    order by a.id
    limit """ + str(n) + """ OFFSET """ + str(i) + """;
    """
    #print(detail)
    while True:
      detail_input = create_conn_source(detail_l1)
      if len(detail_input) == 0:
          break
      id_11 = detail_input[0][0]
      url = detail_input[0][1]
      outlet = detail_input[0][2]
      v1 = []
      v2 = []
      v1.append(id_11)
      try:
        async with async_playwright() as p:
          browser = await p.chromium.launch(headless=True)
          context = await browser.new_context()
          page = await context.new_page()
          try:
              await page.goto(url, timeout=60000)
              await page.wait_for_load_state('domcontentloaded', timeout=60000)
          except:
              try:
                  await page.wait_for_load_state('load', timeout=60000)
              except:
                  print("Network error, retrying...")
                  await asyncio.sleep(2)
          page_content = await page.content()
          soup = BeautifulSoup(page_content, 'html.parser')
          final_url = page.url
          title = ""
          detail = ""
          image_urls = []
          if (outlet == 'thehindu'):
              div = soup.find('div', attrs={'data-url': final_url})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['h3'])]
                for b in body:
                    detail = detail + " " + b
              div = soup.find('div', attrs={'class': "picture verticle"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'itemprop': "articleBody"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                ol_tags = div.find_all('ol', recursive=False)  # recursive=False to get direct children
                for ol in ol_tags:
                    li_tags = ol.find_all('li')
                    for li in li_tags:
                        detail = detail + " " + li.text
          elif (outlet == 'timesofindia'):
            div = soup.find('div', attrs={'class': "okf2Z"})
            if div:
              texts = [element.text for element in div.find_all(['h1'])]
              title = ' '.join(texts)
              source_media = div.find('img')
              if source_media:
                  image_urls.append(source_media.get('src'))
            div = soup.find('div', attrs={'data-articlebody': "1"})
            if div:
              inner_div = div.find('div', attrs={'class': "_s30J clearfix"})
              if inner_div:
                  # Get direct child nodes of the inner_div
                  child_nodes = list(inner_div.children)
                  # Filter out non-text nodes and join remaining text nodes
                  detail =  detail + " " + ''.join([str(node) for node in child_nodes if node.name is None])
          elif (outlet == 'the verge'):
              div = soup.find('article', attrs={'id': "content"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.select('.duet--article--article-body-component > p')]
                for b in body:
                    detail = detail + " " + b
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'nytimes'):
              div = soup.find('article', attrs={'id': "story"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.select("[class$='StoryBodyCompanionColumn'] p")]
                for b in body:
                    detail = detail + " " + b
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'hindustantimes'):
              div = soup.find('div', attrs={'class': "detailPage"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['p', 'h2', 'h3'])]
                detail = detail + " " + ' '.join(body)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'nbc'):
              div = soup.find('header', attrs={'id': "main-article-header"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "RenderKeyPoints-list"})
              if div:
                texts = [element.text for element in div.find_all(['li', 'p'])]
                detail = detail + " " + ' '.join(texts)
              div = soup.find('div', attrs={'data-module': "ArticleBody"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
                  h2_elements = div.find_all('h2')
                  for h2 in h2_elements:
                      detail = detail + " " + h2.text
                  body = [element.text for element in div.select("[class$='group'] p")]
                  for b in body:
                      detail = detail + " " + b
          elif (outlet == 'theindianexpress'):
              div = soup.find('div', attrs={'class': "heading-part"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                texts = [element.text for element in div.find_all(['h2'])]
                detail = detail + ' ' +' '.join(texts)
              div = soup.find('div', attrs={'class': "story_details"})
              if div:
                body = [element.text for element in div.find_all(['p'])]
                detail = ' '.join(body)
              div = soup.find('span', attrs={'class': "custom-caption"})
              if div:
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'cbsnews'):
              div = soup.find('div', attrs={'id': "article-header"})
              if div:
                texts = [element.text for element in div.find_all(['h1' , 'h2'])]
                title = ' '.join(texts)
              div = soup.find('section', attrs={'class': "content__body"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                ol_tags = div.find_all('ol', recursive=False)  # recursive=False to get direct children
                for ol in ol_tags:
                    li_tags = ol.find_all('li')
                    for li in li_tags:
                        detail = detail + " " + li.text
                text = [element.text for element in div.find_all(['h1' , 'h2', 'h3', 'h4','h5'])]
                detail = detail + " " + ' '.join(text)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'foxnews'):
              div = soup.find('div', attrs={'class': "article-meta article-meta-upper"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                texts = [element.text for element in div.find_all(['h2'])]
                detail = detail + ' '.join(texts)
              div = soup.find('div', attrs={'class': "article-body"})
              if div:
                p_tags = div.find_all('p', recursive=False)  # recursive=False to get direct children
                for p in p_tags:
                    detail = detail + " " + p.text
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))

          elif (outlet == 'abcnews'):
              div = soup.find('div', attrs={'data-testid': "prism-GridColumn"})
              if div:
                texts = [element.text for element in div.find_all(['h1'])]
                title = ' '.join(texts)
                body = [element.text for element in div.find_all(['h2', 'h3', 'p'])]
                detail = detail + " " + ' '.join(body)
                source_media = div.find('img')
                if source_media:
                    image_urls.append(source_media.get('src'))
          elif (outlet == 'independent'):
              div = soup.find('header', attrs={'id': "articleHeader"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'id': "main"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet == 'newyorkpost'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "single__content entry-content m-bottom"})
              if div:
                  text1 = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'], recursive=False)]
                  detail = detail + " " + ' '.join(text1)
              div = soup.find('figure', attrs={'class': "featured-image__figure"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "nyp-slideshow-modal-image__wrapper"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet == 'thewashingtonpost'):
              div = soup.find('h1', attrs={'id': "main-content"})
              if div:
                  texts = [element.text for element in div.find_all('span', attrs={'data-qa': "headline-text"})]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'data-qa': "lede-art"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      urls = source_media.get('srcset').split(',')
                      last_url = urls[-1].split(' ')[0]
                      image_urls.append(last_url)
              div = soup.find('div', attrs={'class': "grid-body"})
              if div:
                  body = [element.text for element in div.select("[data-qa$='article-body'] p")]
                  for b in body:
                      detail = detail + " " + b
          elif (outlet =='huffpost'):
              div = soup.find('div', attrs={'id': "entry-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('section', attrs={'class': "entry__content-list js-entry-content js-cet-subunit"})
              if div:
                  body = [element.text for element in div.select("[class$='primary-cli cli cli-text'] p")]
                  for b in body:
                      detail = detail + " " + b
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet =='espn'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "article-body"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('source')
                  if source_media:
                      urls = source_media.get('srcset')
                      if urls:
                          url_list = urls.split(',')
                          last_url = url_list[-1].strip().split(' ')[0]
                          image_urls.append(last_url)
          elif (outlet =='wired'):
              div = soup.find('div', attrs={'data-testid': "ContentHeaderContainer"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "body__inner-container"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
          elif (outlet =='politico'):
              div = soup.find('figure', attrs={'class': "card-lead"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "post-card"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
                  p_tags = div.find_all('p')
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='wion'):
              div = soup.find('div', attrs={'class': "article-heading"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
              main_div = soup.find('div', attrs={'class': "article-main-data"})
              if main_div:
                  inner_divs = main_div.find_all('div', attrs={'class': None})
                  for div in inner_divs:
                      p_tags = div.find_all('p')
                      for p in p_tags:
                          detail = detail + " " + p.text
          elif (outlet =='thewire'):
              div = soup.find('div', attrs={'class': "postComplete__post-header-wrapper"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "postComplete__post-image-wrapper"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "grey-text"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      span_tags = p.find_all('span')
                      for span in span_tags:
                          detail = detail + " " + span.text
          elif (outlet =='marketwatch'):
              div = soup.find('div', attrs={'aria-label': "article header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "article__figure"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'itemprop': "articleBody"})
              if main_div:
                  p_tags = main_div.find_all('p')
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='aljazeera'):
              div = soup.find('header', attrs={'class': "article-header"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
              div = soup.find('figure', attrs={'class': "article-featured-image"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append("https://www.aljazeera.com/" +source_media.get('src'))
              main_div = soup.find('div', attrs={'aria-atomic': "true"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='techcrunch'):
              div = soup.find('div', attrs={'class': "article__title-wrapper"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3', 'p'])]
                  title = ' '.join(texts)
                  texts_1 = [element.text for element in div.find_all(['h2', 'h3', 'p'])]
                  detail = detail + " " + ' '.join(texts_1)
              div = soup.find('div', attrs={'class': "article__content-outer"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "article-content"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='vox'):
              div = soup.find('div', attrs={'class': "c-entry-hero c-entry-hero--default"})
              if div:
                  texts = [element.text for element in div.find_all(['h1'])]
                  title = ' '.join(texts)
              div = soup.find('span', attrs={'class': "e-image__inner"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "c-entry-content"})
              if main_div:
                  p_tags = main_div.find_all(['p','h3'], recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='forbes'):
              div = soup.find('div', attrs={'class': "article-headline-container"})
              if div:
                  texts = [element.text for element in div.find_all(['h1', 'h2', 'h3'])]
                  title = ' '.join(texts)
              div = soup.find('div', attrs={'class': "image-embed__placeholder"})
              if div:
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              div = soup.find('div', attrs={'class': "article-body fs-article fs-responsive-text current-article"})
              if div:
                  p_tags = div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          elif (outlet =='thedailybeast'):
              div = soup.find('div', attrs={'data-testid': "StoryHeader"})
              if div:
                  texts = [element.text for element in div.find_all(['h1'])]
                  title = ' '.join(texts)
                  texts = [element.text for element in div.find_all(['h2'])]
                  detail = detail + ' ' +' '.join(texts)
                  source_media = div.find('img')
                  if source_media:
                      image_urls.append(source_media.get('src'))
              main_div = soup.find('div', attrs={'class': "Mobiledoc"})
              if main_div:
                  p_tags = main_div.find_all('p', recursive=False)
                  for p in p_tags:
                      detail = detail + " " + p.text
          if len(detail) < 10:
              await page.close()
              q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_in_detail = 10
                WHERE id = {id_11};"""
              update_conn_source(q2)
          else:
              v1.append(final_url)
              v1.append(title)
              v1.append(detail)
              v1.append(image_urls)
              v2.append(tuple(v1))

              ids_t = tuple(v2)
            #   print(ids_t)
              q1 = "INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, final_url, title, detail, image_link) VALUES (%s, %s, %s, %s, %s)"
              inser_conn_source(q1, ids_t)
              q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_in_detail = 1
                WHERE id = {id_11};"""
              update_conn_source(q2)
              await page.close()
      except:
          q2 = f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_in_detail = 10
            WHERE id = {id_11};"""
          update_conn_source(q2)

def run_parallel2(offset):
    asyncio.run(get_detail2(offset))
        
#set all is in detail:
def set_all_in_detail():
  query = """select a.id, a.title, a.summary, a.post_link
    from synopse_articles.t_v1_rss1_articles a
    where a.is_in_detail != 1
    limit 100
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
        v1.append(tuple(v2))
        ids.append(articles_details_output[i][0])
            
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
    v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, title, detail, final_url) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v1)

# summerize
def summerizer_anyscale(offset):
    esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
    client = openai.OpenAI(
        base_url = "https://api.endpoints.anyscale.com/v1",
        api_key = esecret_ANYSCALE_API_KEY
    )
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
          LIMIT 1 OFFSET """ + str(offset) + """;
          """
        articles_details_output = create_conn_source(articles_details)
        if len(articles_details_output) == 0:
            break
        v1 = []
        ids = []
        system_prompt = """you are summerizer. The main body of the article, provide a balanced and objective summary of the articles limited to a about maximum 100 words
        Please provide a concise summary of the article based on the information provided in the title, summary, and description. The summary should be approximately 350 words in length.
        Make sure you to only return the summary and say nothing else.
            """
        title = articles_details_output[0][1]
        summary = articles_details_output[0][2]
        description = articles_details_output[0][3]
        user_prompt = title + "  " + summary + "  " + description
        if (len(user_prompt) > 3000):
          user_prompt = user_prompt[:3000]
        chat_completion = client.chat.completions.create(
          model="mistralai/Mistral-7B-Instruct-v0.1",
          messages=[{"role": "system", "content": system_prompt},
                      {"role": "user", "content": user_prompt}],
          max_tokens = 200,
          temperature = 0.3,
          top_p = 0.9,
          seed =  10
        )
        out3 = chat_completion.choices[0].message.content
        # print(out3)
        v1 = []
        v2 = []
        v2.append(articles_details_output[0][0])
        v2.append(out3)
        v1.append(tuple(v2))
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_summerized = 1
                WHERE id = """ + str(articles_details_output[0][0]) +""";"""
        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)"
        insert_conn_source(v1_insert_query, v1)

#set all in summerize:
def set_all_summerize():
  query = """select a.id, a.summary
    from synopse_articles.t_v1_rss1_articles a
    where a.is_summerized != 1
    limit 100
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
    v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s) ON CONFLICT DO NOTHING;"
    insert_conn_source(v1_insert_query, v1)

#ner Tagging
def ner_tagging(offset1):
  # spacy.require_gpu()
  nlp = spacy.load("en_core_web_trf")
  nlp.use_multiprocessing = True
  # nlp.use_gpu = True
  query = """
  query MyQuery($limit: Int!, $offset: Int!) {
    synopse_articles_t_v1_rss1_articles(where: {is_summerized: {_eq: 1}, is_ner_tagged: {_eq: 0}}, limit: $limit, offset: $offset, order_by: {created_at: desc}) {
      title
      summary
      id
      t_v2_articles_summary {
        summary
        person_tags
        location_tags
        keywords_tags
        org_tags
      }
      t_v1_rss1_articles_detail {
        detail
      }
    }
  }
  """
  offset = offset1
  mutataion_query = """
  mutation MyMutation($updates: [synopse_articles_t_v2_articles_summary_updates!] = {where: {}}, $updates1: [synopse_articles_t_v1_rss1_articles_updates!] = {where: {}}) {
    update_synopse_articles_t_v2_articles_summary_many(updates: $updates) {
      affected_rows
    }
    update_synopse_articles_t_v1_rss1_articles_many(updates: $updates1) {
      affected_rows
    }
  }
  """
  while True:
      variables = {
          "limit": 1,
          "offset": offset
      }
      synopse_articles_t_v2_articles_summary_updates_loc = []
      synopse_articles_t_v1_rss1_articles_updates_loc = []
      response_data = query_hasura_graphql(endpoint=endpoint, admin_key=admin_key, query=query, variables=variables)
      if len(response_data['data']['synopse_articles_t_v1_rss1_articles']) == 0:
          break
      for response in response_data['data']['synopse_articles_t_v1_rss1_articles']:
          try:
            title = str(response['title'])
          except:
            title = ""
          try:
            summary = str(response['summary'])
          except:
            summary = ""
          try:
              summary2 = str(response['t_v2_articles_summary']['summary'])
          except:
              summary2 = ""
          try:
              description = str(response['t_v1_rss1_articles_detail']['detail'] )
          except:
              description = ""
          text = title + " " + summary + " " + summary2 + " " + description
          doc = nlp(text)
          kw_model = KeyBERT()
          num_words = len(text.split())
          top_keywords = int(num_words/50)
          if top_keywords < 15:
              top_keywords = 15
          elif top_keywords > 30:
              top_keywords = 30
          try:
            if response['t_v2_articles_summary']['person_tags'] is not None:
              person = response['t_v2_articles_summary']['person_tags']
            else:
              person = []
          except:
              person = []
          try:
            if response['t_v2_articles_summary']['location_tags'] is not None:
              loc = response['t_v2_articles_summary']['location_tags']
            else:
              loc = []
          except:
              loc = []
          try:
            if response['t_v2_articles_summary']['keywords_tags'] is not None:
              keys = response['t_v2_articles_summary']['keywords_tags']
            else:
              keys = []
          except:
              keys = []
          try:
            if response['t_v2_articles_summary']['org_tags'] is not None:
              orgs = response['t_v2_articles_summary']['org_tags']
            else:
              orgs = []
          except:
              orgs = []
          keywords = kw_model.extract_keywords(text, top_n=int(top_keywords))
          keys_bert = [keyword[0] for keyword in keywords]
          try:
            for key in keys_bert:
                keys.append(key)
          except:
            print("keys")
          for ent in doc.ents:
              if ent.label_ == "GPE" or ent.label_ == "LOC" or ent.label_ == "NORP" or ent.label_ == "FAC":
                  loc.append(ent.text)
              elif ent.label_ == "PERSON":
                  person.append(ent.text)
              elif ent.label_ == "ORG ":
                  orgs.append(ent.text)
              elif ent.label_ == "EVENT" or ent.label_ == "WORK_OF_ART" or ent.label_ == "PRODUCT" or ent.label_ == "LAW":
                  keys.append(ent.text)
          loc = [item.lower() for item in loc]
          person = [item.lower() for item in person]
          key = [item.lower() for item in keys]
          org = [item.lower() for item in orgs]
          loc = list(set(loc))
          person = list(set(person))
          key = list(set(key))
          org = list(set(org))
          synopse_articles_t_v2_articles_summary_updates_loc.append({
                  "where": {"article_id" : { "_eq": response['id'] }},
                  "_set": {"location_tags": loc, "person_tags": person, "keywords_tags": key , "org_tags": org}
                  })
          synopse_articles_t_v1_rss1_articles_updates_loc.append({
                  "where": {"id" : { "_eq": response['id'] }},
                  "_set": {"is_ner_tagged": 1}
                  })
      mutation_variables = {
          "updates": synopse_articles_t_v2_articles_summary_updates_loc,
          "updates1": synopse_articles_t_v1_rss1_articles_updates_loc
      }
      out = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutataion_query, mutation_variables=mutation_variables)

#vectorize
def vectorize(offset1):
  print(offset1)
  model = SentenceTransformer('BAAI/bge-large-en-v1.5')
  graphql_query = '''
  query MyQuery($limit: Int!, $offset: Int!) {
    synopse_articles_t_v1_rss1_articles(where: {is_summerized: {_eq: 1}, is_vectorized: {_eq: 0}}, order_by: {created_at: desc}, limit: $limit, offset: $offset) {
      title
      summary
      id
      t_v2_articles_summary {
        summary
      }
    }
  }
  '''
  offset = offset1
  mutation_query = """
  mutation MyMutation($objects: [synopse_articles_t_v2_articles_vectors_insert_input!] = {}, $updates: [synopse_articles_t_v1_rss1_articles_updates!] = {where: {}}) {
    insert_synopse_articles_t_v2_articles_vectors(objects: $objects, on_conflict: {constraint: t_v2_articles_vectors_article_id_key}) {
      affected_rows
    }
    update_synopse_articles_t_v1_rss1_articles_many(updates: $updates) {
      affected_rows
    }
  }
  """
  while True:
    variables = {
    "limit": 10,
    "offset": offset
    }
    synopse_articles_t_v2_articles_vectors_insert_input_loc = []
    synopse_articles_t_v1_rss1_articles_updates_loc = []
    response_data = query_hasura_graphql(endpoint, admin_key, graphql_query, variables)
    if len(response_data['data']['synopse_articles_t_v1_rss1_articles']) == 0:
        break
    p1 = []
    article_ids = []
    for response in response_data['data']['synopse_articles_t_v1_rss1_articles']:
      article_ids.append( response['id'] )
      summary1 = ""
      try:
          summary1 = response['t_v2_articles_summary']['summary']
      except:
          summary1 = ""
      p12 = response['title'] + "\n" + response['summary'] + "\n" + summary1
      p1.append(p12)

    embeddings = model.encode(p1)
    for i in range(0,len(article_ids)):
      synopse_articles_t_v2_articles_vectors_insert_input_loc.append({
          "article_id": article_ids[i],
          "a_vector":  str(embeddings[i].tolist()),
          }
          )
      synopse_articles_t_v1_rss1_articles_updates_loc.append({
          "where": {"id" : { "_eq": article_ids[i] }},
          "_set": {"is_vectorized": 1}
          })

    mutation_variables = {
        "objects": synopse_articles_t_v2_articles_vectors_insert_input_loc,
        "updates": synopse_articles_t_v1_rss1_articles_updates_loc,
        }
    out1 = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutation_query, mutation_variables=mutation_variables)
    
# grouping L1
def grouping_l1(offset1):
    print(offset1)
    graphql_query = '''
    query MyQuery($offset: Int!, $limit: Int!) {
      synopse_articles_t_v1_rss1_articles(offset: $offset, limit: $limit, order_by: {created_at: desc}, where: {is_grouped: {_eq: 0}, is_vectorized: {_eq: 1}}) {
        id
      }
    }
    '''
    offset = offset1
    mutation_query = """
    mutation MyMutation($objects: [synopse_articles_t_v3_article_groups_l1_insert_input!] = {}, $updates: [synopse_articles_t_v1_rss1_articles_updates!] = {where: {}}) {
      insert_synopse_articles_t_v3_article_groups_l1(objects: $objects, on_conflict: {constraint: t_v3_article_groups_l1_article_id_key}) {
        affected_rows
      }
      update_synopse_articles_t_v1_rss1_articles_many(updates: $updates) {
        affected_rows
      }
    }
    """
    func_query = '''
    query MyQuery($p_article_id: bigint!) {
      synopse_articles_f_get_similar_articles_l1(args: {p_article_id: $p_article_id}) {
        article_id
      }
    }
    '''
    while True:
        variables = {
        "limit": 10,
        "offset": offset
        }
        synopse_articles_t_v3_article_groups_l1_insert_input_loc=[]
        synopse_articles_t_v1_rss1_articles_updates_loc=[]
        response_data = query_hasura_graphql(endpoint, admin_key, graphql_query, variables)
        if len(response_data['data']['synopse_articles_t_v1_rss1_articles']) == 0:
            break
        s1= []
        ids=[]
        for response in response_data['data']['synopse_articles_t_v1_rss1_articles']:
            func_variables = {
                "p_article_id": response['id']
                }
            func_response_data = query_hasura_graphql(endpoint, admin_key, func_query, func_variables)
            article_group = []
            #print(json.dumps(func_response_data, indent=4))
            if len(func_response_data['data']['synopse_articles_f_get_similar_articles_l1']) > 0:
                for func_response in func_response_data['data']['synopse_articles_f_get_similar_articles_l1']:
                    article_group.append(func_response['article_id'])

            synopse_articles_t_v3_article_groups_l1_insert_input_loc.append({
                "article_id": response['id'],
                "initial_group": article_group,
                "article_count": len(article_group)
                }
                )
            synopse_articles_t_v1_rss1_articles_updates_loc.append({
                "where": {"id" : { "_eq": response['id'] }},
                "_set": {"is_grouped": 1}
                })
        mutation_variables = {
        "objects": synopse_articles_t_v3_article_groups_l1_insert_input_loc,
        "updates": synopse_articles_t_v1_rss1_articles_updates_loc,
        }
        out1 = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutation_query, mutation_variables=mutation_variables)

# grouping L2
def grouping_l2():
    print("grouping_l2")
    graphql_query = '''
    query MyQuery($limit: Int!, $offset: Int!) {
      synopse_articles_t_v3_article_groups_l1(where: {t_v1_rss1_article: {is_grouped: {_eq: 1}}, article_count: {_gt: 1}}, order_by: {updated_at: asc}, limit: $limit, offset: $offset) {
        article_id
        initial_group
      }
    }
    '''
    query2 = '''
    query MyQuery($articleid: [bigint!] = []) {
        synopse_articles_t_v3_article_groups_l1(where: {initial_group: {_contains: $articleid}}) {
        article_id
        initial_group
        }
    }
    '''
    query5 = '''
    query MyQuery($articleid: [bigint!] = []) {
      synopse_articles_t_v3_article_groups_l2(order_by: {updated_at: desc}, where: {is_valid: {_eq: 0}, articles_group: {_contains: $articleid}}, limit: 1) {
        articles_group
        id
      }
    }
    '''
    query4 = '''
    query MyQuery($articleid: [bigint!] = []) {
      synopse_articles_t_v3_article_groups_l2(order_by: {updated_at: desc}, where: {is_valid: {_eq: 1}, articles_group: {_contains: $articleid}}, limit: 1) {
        articles_group
        id
        article_comment_id
      }
    }
    '''
    mutation_query = """
    mutation MyMutation($objects: [synopse_articles_t_v3_article_groups_l2_insert_input!] = {}, $updates: [synopse_articles_t_v1_rss1_articles_updates!] = {where: {}}, $updates1: [synopse_articles_t_v3_article_groups_l2_updates!] = {where: {}}, $articleGroupIds: [bigint!] = "") {
      insert_synopse_articles_t_v3_article_groups_l2(objects: $objects, on_conflict: {constraint: t_v3_article_groups_l2_pkey}) {
        affected_rows
      }
      update_synopse_articles_t_v1_rss1_articles_many(updates: $updates) {
        affected_rows
      }
      update_synopse_articles_t_v3_article_groups_l2_many(updates: $updates1) {
        affected_rows
      }
      delete_synopse_articles_t_v3_article_groups_l2(where: {id: {_in: $articleGroupIds}}) {
        affected_rows
      }
    }
    """
    while True:
        variables = {
        "limit": 1,
        "offset": 0
        }
        response_data = query_hasura_graphql(endpoint, admin_key, graphql_query, variables)
        synopse_articles_t_v3_article_groups_l2_insert_input_loc=[]
        synopse_articles_t_v1_rss1_articles_updates_loc=[]
        synopse_articles_t_v3_article_groups_l2_updates_loc=[]
        articleGroupIds_loc=[]
        if (len(response_data['data']['synopse_articles_t_v3_article_groups_l1']) == 0):
            break
        for response in response_data['data']['synopse_articles_t_v3_article_groups_l1']:
            variables2 = {
                "articleid": [response['article_id']]
                }
            response_data1 = query_hasura_graphql(endpoint, admin_key, query2, variables2)
            articles_ids = []

            if len(response_data1['data']['synopse_articles_t_v3_article_groups_l1']) == 0:
                break
            if len(response_data1['data']['synopse_articles_t_v3_article_groups_l1']) > 0:
                for func_response in response_data1['data']['synopse_articles_t_v3_article_groups_l1']:
                    articles_ids.append(func_response['initial_group'])
            n1 = []
            for sublist in articles_ids:
                for element in sublist:
                    n1.append(element)
            articles_ids = list(set(n1))
            articles_ids.sort(reverse=True)
            articles_valid = []

            while True:
                if len(articles_ids) > 1:
                    articles_news = []
                    for article_id in articles_ids:
                        variables3 = {
                            "articleid": [article_id]
                            }
                        response_data2 = query_hasura_graphql(endpoint, admin_key, query2, variables3)
                        if len(response_data2['data']['synopse_articles_t_v3_article_groups_l1']) > 0:
                            for func_response in response_data2['data']['synopse_articles_t_v3_article_groups_l1']:
                                articles_news.append(func_response['initial_group'])
                    n2 = []
                    for sublist in articles_news:
                        for element in sublist:
                            n2.append(element)
                    articles_news = list(set(n2))
                    articles_news.sort(reverse=True)
                    if articles_ids == articles_news:
                        break
                    else:
                        articles_ids = articles_news
            print(articles_ids)
            insert = True

            articles_ids = list(set(n2))
            articles_ids.sort(reverse=True)
            variables3 = {
                "articleid": [articles_ids[-1]]
                }
            response_data10 = query_hasura_graphql(endpoint, admin_key, query5, variables3)
            if len(response_data10['data']['synopse_articles_t_v3_article_groups_l2']) == 1:
                insert = False
                synopse_articles_t_v3_article_groups_l2_updates_loc.append({
                                "where": {"id" : { "_eq": response_data10['data']['synopse_articles_t_v3_article_groups_l2'][0]["id"] }},
                                "_set": {"articles_group": articles_ids,
                                        'articles_in_group': len(articles_ids)}
                                })
            else:
                response_data11 = query_hasura_graphql(endpoint, admin_key, query4, variables3)
                if len(response_data11['data']['synopse_articles_t_v3_article_groups_l2']) == 1:
                    insert = True
                    synopse_articles_t_v3_article_groups_l2_insert_input_loc.append({
                            "articles_group": articles_ids,
                            'articles_in_group': len(articles_ids),
                            "article_comment_id" : response_data11['data']['synopse_articles_t_v3_article_groups_l2'][0]["article_comment_id"]
                            }
                        )
                else:
                    insert = True
                    synopse_articles_t_v3_article_groups_l2_insert_input_loc.append({
                            "articles_group": articles_ids,
                            'articles_in_group': len(articles_ids),
                            "article_comment_id" : articles_ids[-1]
                            }
                        )

            for article in articles_ids:
                synopse_articles_t_v1_rss1_articles_updates_loc.append({
                    "where": {"id" : { "_eq": article }},
                    "_set": {"is_grouped": 2}
                    })
            mutation_variables = {
                "objects": synopse_articles_t_v3_article_groups_l2_insert_input_loc,
                "updates": synopse_articles_t_v1_rss1_articles_updates_loc,
                "updates1": synopse_articles_t_v3_article_groups_l2_updates_loc,
                "articleGroupIds": articleGroupIds_loc
                }
            out1 = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutation_query, mutation_variables=mutation_variables)

#get dinal article
def gen_final_article(offset):
    esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
    client = openai.OpenAI(
        base_url = "https://api.endpoints.anyscale.com/v1",
        api_key = esecret_ANYSCALE_API_KEY
    )
    while True:
        articles_details = """
          select
            a.id,
            a.articles_group
          from
            synopse_articles.t_v3_article_groups_l2 a
          where
            a.articles_in_group > 1
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
          Ensure the selected tags is amoung ["Sports & Recreation", "Technology & Business", "Culture & Entertainment", "Politics & Global Affairs", "Education & Learning", "Environment & Health"]
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
            temperature = 0.3,
            top_p = 0.9,
            seed =  10
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
          if (out3=="na"):
            if t6 > 3:
              isSummerized = 2
              v1.append(tuple(v2))
              break
          else:
            v1.append(tuple(v2))
            break
        if (isSummerized == 1):
            v1_insert_query ="INSERT INTO synopse_articles.t_v4_article_groups_l2_detail (article_group_id, title, summary, llm_keypoints, llm_keywords, llm_tags) VALUES (%s, %s, %s, %s, %s, %s)"
            insert_conn_source(v1_insert_query, v1)
        q1= f"""UPDATE synopse_articles.t_v3_article_groups_l2
                SET is_summerized = """+ str(isSummerized) + """
                WHERE id  = """+ str(articles_details_output[0][0]) + """;"""
        update_conn_source(q1)

#ai_tagging:
def ai_tagging_groups_bertwiki(offset1):
  topic_model = BERTopic.load("MaartenGr/BERTopic_Wikipedia")
  query = """
  query MyQuery($limit: Int!, $offset: Int!) {
      synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, where: {t_v3_article_groups_l2: {is_ai_tagged: {_eq: 0}, is_summerized: {_eq: 1}}, title: {_is_null: false}}, limit: $limit, offset: $offset) {
        summary_60_words
        title
        article_group_id
        llm_keypoints
        llm_keywords
        llm_tags
      }
    }
  """
  offset = offset1
  mutataion_query = """
  mutation MyMutation($updates: [synopse_articles_t_v4_article_groups_l2_detail_updates!] = {where: {}}, $updates1: [synopse_articles_t_v3_article_groups_l2_updates!] = {where: {}}) {
    update_synopse_articles_t_v4_article_groups_l2_detail_many(updates: $updates) {
      affected_rows
    }
    update_synopse_articles_t_v3_article_groups_l2_many(updates: $updates1) {
      affected_rows
    }
  }
  """
  while True:
      variables = {
          "limit": 20,
          "offset": offset
      }
      synopse_articles_t_v4_article_groups_l2_detail_updates_loc = []
      synopse_articles_t_v3_article_groups_l2_updates_loc = []
      response_data = query_hasura_graphql(endpoint=endpoint, admin_key=admin_key, query=query, variables=variables)
      if len(response_data['data']['synopse_articles_t_v4_article_groups_l2_detail']) == 0:
          break
      article_id = []
      sequence_to_classify = []
      for response in response_data['data']['synopse_articles_t_v4_article_groups_l2_detail']:
          title = response['title']
          summary_60_words = response['summary_60_words']
          llm_keypoints =  ', '.join(response['llm_keypoints'] )
          llm_keywords =  ', '.join(response['llm_keywords'] )
          llm_tags =  ', '.join(response['llm_tags'] )
          text = str(title) + " " + str(summary_60_words) + str(llm_keypoints) + str(llm_keywords) +str(llm_tags)
          topic, prob = topic_model.transform([text])
          topic_label = topic_model.topic_labels_[topic[0]]
          synopse_articles_t_v4_article_groups_l2_detail_updates_loc.append({
                  "where": {"article_group_id" : { "_eq": response['article_group_id'] }},
                  "_set": {"group_ai_tags_l1": topic_label}
                  })
          synopse_articles_t_v3_article_groups_l2_updates_loc.append({
                  "where": {"id" : { "_eq": response['article_group_id'] }},
                  "_set": {"is_ai_tagged": 1}
                  })
      mutation_variables = {
          "updates": synopse_articles_t_v4_article_groups_l2_detail_updates_loc,
          "updates1": synopse_articles_t_v3_article_groups_l2_updates_loc
      }
      out = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutataion_query, mutation_variables=mutation_variables)
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

def is_valid_image(url):
    try:
        response = requests.get(url)
        return response.status_code == 200
    except requests.exceptions.RequestException as e:
        return False
    
def remove_invalid_images():
    i = - 1
    while True:
        i = i + 1
        t_v4_tags_hierarchy = """
        SELECT
            a.image_link
        FROM 
            synopse_articles.t_v1_rss1_articles a
        WHERE 
            a.is_grouped = 2 
            and a.image_link is not null
            and a.image_link != ''
        ORDER BY 
            a.id DESC
            LIMIT 200 OFFSET """ + str(i*200) + """;
        """
        t_v4_tags_hierarchy_output = create_conn_source(t_v4_tags_hierarchy)
        if len(t_v4_tags_hierarchy_output) == 0:
            break
        for link in t_v4_tags_hierarchy_output:
            if (is_valid_image(link[0]) == False):
                q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                    SET image_link = ''
                    WHERE image_link = '{link[0]}';"""
                q2 = f"""UPDATE synopse_articles.t_v4_article_groups_l2_detail
                    SET image_urls = array_remove(image_urls, '{link[0]}')
                    WHERE '{link[0]}' = ANY(image_urls);"""
                print(str(is_valid_image(link[0])) + "   " + link[0])
                update_conn_source(q1)
                update_conn_source(q2)
                update_conn_destination(q1)
                update_conn_destination(q2)
                
def load_to_prod():
    
    print("#outlet")
    outlet1 = "SELECT id, outlet_display, logo_url FROM synopse_articles.t_v1_outlets"
    outlet1_output = create_conn_source(outlet1)
    outlet_insert_query ="INSERT INTO synopse_articles.t_v1_outlets (outlet_id, outlet_display, logo_url) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING"
    outlet_data = outlet1_output
    create_conn_destination(outlet_insert_query, outlet_data)
    
    print("#tags")
    t_v4_tags_hierarchy = """
    SELECT 
        id,
        tag,
        tag_hierachy,
        tag_description,
        is_valid
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
        is_valid
    ) VALUES (%s, %s, %s, %s, %s)  ON CONFLICT DO NOTHING;
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
            c.id as outlet_id
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
        articles_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles (article_id, title, post_link, author, image_link, post_published, outlet_id)VALUES (%s, %s, %s, %s, %s, %s, %s)"
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
            a.article_comment_id
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
        articles_l2_insert_query ="INSERT INTO synopse_articles.t_v3_article_groups_l2 (article_group_id, is_valid, articles_group, articles_in_group, article_comment_id)VALUES (%s, %s, %s, %s, %s)"
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
            b.tag_root,
            b.tag_tree,
            a.is_audio_created_valid,
            a.llm_keypoints,
            a.post_published
        FROM 
            synopse_articles.t_v4_article_groups_l2_detail a
        LEFT OUTER JOIN 
            synopse_articles.t_v4_berttopics b 
        ON 
            b.topic_name = a.group_ai_tags_l1
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
            post_published
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)  ON CONFLICT DO NOTHING;
        """
        create_conn_destination(articles_l2_details_insert_query, articles_l2_details_output)
        ids = []
        for i in range(len(articles_l2_details_output)):
            ids.append(articles_l2_details_output[i][0])
        t_ids = tuple(ids)
        update_query = "UPDATE synopse_articles.t_v4_article_groups_l2_detail SET prod = 1 WHERE article_group_id IN " + str(t_ids) + ";"
        update_conn_source(update_query)
    

if __name__ == "__main__":
    set_start_method('spawn', force=True)
    step = 6
    if (step < 1):
      print("extract data from rss feeds")
      q1 = """select outlet from synopse_articles.t_v1_outlets;"""
      q1_out = create_conn_source(q1)
      outlets = [item[0] for item in q1_out]
      argss = []
      argsss = outlets
      argss.append(argsss[:6])
      argss.append(argsss[6:12])
      argss.append(argsss[12:18])
      argss.append(argsss[18:24])
      argss.append(argsss[24:30])
      argss.append(argsss[30:])
      print(argss)
      processes = []
      for args in argss:
        for arg in args:
            process = multiprocessing.Process(target=update_articles, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
    
    if (step < 2):
      print("reduce articles step 2")
      reduce_articles()
      print("extract articles_first attemp")
      n = 0
      args = []
      for i in range(0, 4):
          args.append(i*10 + n*40)
      print(args)

      # Create a list to hold the processes
      processes = []

      # Create and start a process for each argument
      for arg in args:
          process = multiprocessing.Process(target=run_parallel, args=(arg,))
          processes.append(process)
          process.start()

      # Wait for all processes to finish
      for process in processes:
          process.join()
    
    if (step < 3):
      print("reduce articles step 3")
      reduce_articles()
      print("extract articles_second attemp")
      n = 0
      args = []
      for i in range(0, 4):
          args.append(i*10 + n*40)
      print(args)

      # Create a list to hold the processes
      processes = []

      # Create and start a process for each argument
      for arg in args:
          process = multiprocessing.Process(target=run_parallel2, args=(arg,))
          processes.append(process)
          process.start()

      # Wait for all processes to finish
      for process in processes:
          process.join()

    if (step < 4):
        print("set all detail")
        # set_all_in_detail()
        print("reduce articles step 4")
        reduce_articles()
        print("summerizer")
        args = [0,10,20,30]
        # Create a list to hold the processes
        processes = []

        # Create and start a process for each argument
        for arg in args:
            process = multiprocessing.Process(target=summerizer_anyscale, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()
        print("set all summary")
        # set_all_summerize()
        
    if (step < 5):
        print("ner tagging")
        n1 =  0
        mod = 10
        n2 = 4
        offset = (mod * (n2 + 1)) * n1
        args = []
        for i in range(0 , n2):
          args.append((i * mod) + offset)
        print(args)

        # Create a list to hold the processes
        processes = []

        # Create and start a process for each argument
        for arg in args:
            process = multiprocessing.Process(target=ner_tagging, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()

    if (step < 6):
        print("vectorizing")
        n1 =  0
        mod = 50
        n2 = 4
        offset = (mod * (n2 + 1)) * n1
        args = []
        for i in range(0 , n2):
          args.append((i * mod) + offset)
        print(args)

        # Create a list to hold the processes
        processes = []

        # Create and start a process for each argument
        for arg in args:
            process = multiprocessing.Process(target=vectorize, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()


    if (step < 7):
        print("grouping_l1")
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
            process = multiprocessing.Process(target=grouping_l1, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()
        print("grouping_l2")
        grouping_l2()

    if (step < 8):
        print("gen final article")
        args = [0,10,20,30]
        # Create a list to hold the processes
        processes = []

        # Create and start a process for each argument
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()

    if (step < 9):
        print("tagging")
        n1 =  0
        mod = 50
        n2 = 4
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
            process = multiprocessing.Process(target=ai_tagging_groups_bertwiki, args=(arg,))
            processes.append(process)
            process.start()

        # Wait for all processes to finish
        for process in processes:
            process.join()

    if (step < 10):
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
        
    if (step < 11):
        print("load to prod")
        load_to_prod()
    
    if (step < 12):
        print("remove invalid images")
        remove_invalid_images()
        
        