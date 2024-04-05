import psycopg2
from psycopg2 import sql
import requests
import feedparser
from datetime import datetime, timezone
import re
from multiprocessing import Process, set_start_method
import multiprocessing
import psycopg2
import requests

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
        print(f"Request failed with status code {response.status_code}")
        return None

def mutation_hasura_graphql(endpoint, admin_key, mutation_query, mutation_variables):
    headers = {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': f'{admin_key}'
    }
    response = requests.post(endpoint, json={'query': mutation_query, 'variables': mutation_variables}, headers=headers)
    if response.ok:
        data = response.json()
        print(data)
        return True, data
    else:
        print(f"Mutation failed with status code {response.status_code}: {response.text}")
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

def summerizer_under_300():
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
        ids_t = tuple(ids)
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_summerized = 1
                WHERE id in {ids_t};"""
        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)"
        insert_conn_source(v1_insert_query, v1)


def set_is_in_Detail_300():
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
          where a.is_in_detail != 0
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
        ids_t = tuple(ids)
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_in_detail = 1
                WHERE id in {ids_t};"""
        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, title, detail,  final_url ) VALUES (%s, %s, %s, %s)"
        insert_conn_source(v1_insert_query, v1)


def summerizer_under_300_25():
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
        ids_t = tuple(ids)
        q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
                SET is_summerized = 1
                WHERE id in {ids_t};"""
        update_conn_source(q1)
        v1_insert_query ="INSERT INTO synopse_articles.t_v2_articles_summary (article_id, summary) VALUES (%s, %s)"
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

def set_article_to_vmBox():
    mutation_query = """
    mutation MyMutation($_in: [String!] = ["politico", "reuters", "appleinsider", "cnn"]) {
      update_synopse_articles_t_v1_rss1_articles(where: {is_summerized: {_eq: 0}, t_v1_rss1_feed_link: {outlet: {_in: $_in}}, is_in_detail: {_eq: 0}}, _set: {is_in_detail: 10}) {
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
        #print("Data inserted successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

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


async def get_detail(offset):
    print(offset)
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
              print(ids_t)
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

def extract_json(s):
    start = s.find('{')
    end = s.rfind('}') + 1  # +1 to include the '}' in the substring
    json_str = s[start:end]
    try:
        return json.loads(json_str)
    except json.JSONDecodeError:
        return None

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
        print(out3)
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


def grouping_l2(offset1):
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

async def get_detail2(offset):
    print(offset)
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
              print(ids_t)
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
    ids_t = tuple(ids)
    q1= f"""UPDATE synopse_articles.t_v1_rss1_articles
            SET is_in_detail = 1
            WHERE id in {ids_t};"""
    update_conn_source(q1)
    v1_insert_query ="INSERT INTO synopse_articles.t_v1_rss1_articles_detail (article_id, title, detail, final_url) VALUES (%s, %s, %s, %s)"
    insert_conn_source(v1_insert_query, v1)


if __name__ == "__main__":
    # extract from rss
    q1 = """select outlet from synopse_articles.t_v1_outlets;"""

    q1_out = create_conn_source(q1)
    outlets = [item[0] for item in q1_out]
    print(outlets)
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
    
    # reduce the article required for details
    set_is_in_Detail_300()
    summerizer_under_300()
    summerizer_under_300_25()
    set_article_to_no_extract()
    set_article_to_attemp1_1()
    set_article_to_attemp1_2()
    set_article_to_vmBox()
    set_article_to_vmBox1()

    # get article details
    n = 0
    args = []
    for i in range(0, 4):
        args.append(i*10 + n*40)
    print(args)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=run_parallel, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()

    # reduce the article required for summary
    set_is_in_Detail_300()
    summerizer_under_300()
    summerizer_under_300_25()
    set_article_to_no_extract()
    set_article_to_attemp1_1()
    set_article_to_attemp1_2()
    set_article_to_vmBox()
    set_article_to_vmBox1()

    
    # get article details_2nstry
    n = 0
    args = []
    for i in range(0, 4):
        args.append(i*10 + n*40)
    print(args)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=run_parallel2, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()
    
    # summerize for detail summary
    args = [0,10,20,30]
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=summerizer_anyscale, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()


    # summerize again trim dowm
    set_is_in_Detail_300()
    summerizer_under_300()
    summerizer_under_300_25()
    set_article_to_no_extract()
    set_article_to_attemp1_1()
    set_article_to_attemp1_2()
    set_article_to_vmBox()
    set_article_to_vmBox1()

    # grouping L1
    n1 =  0
    mod = 50
    n2 = 10
    offset = (mod * (n2 + 1)) * n1
    set_start_method('spawn', force=True)
    args = []
    for i in range(0 , n2):
      args.append((i * mod) + offset)
    print(args)
    processes = []
    for arg in args:
        process = multiprocessing.Process(target=grouping_l1, args=(arg,))
        processes.append(process)
        process.start()
    for process in processes:
        process.join()
    
    # grouping L2
    grouping_l2(0)