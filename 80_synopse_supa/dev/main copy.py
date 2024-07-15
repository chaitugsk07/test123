from supabase import create_client, Client
import feedparser
from datetime import datetime, timezone
import re
import time
from multiprocessing import Process, set_start_method
import multiprocessing
import openai
import tiktoken
from sentence_transformers import SentenceTransformer
import json
import requests
from PIL import Image
from io import BytesIO
from dataplane import s3_upload
import boto3
from botocore.client import Config

encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
supabase: Client = create_client("http://supa-supabase-kong.supabase.svc.cluster.local:8000", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogInNlcnZpY2Vfcm9sZSIsCiAgImlzcyI6ICJzdXBhYmFzZSIsCiAgImlhdCI6IDE3MTM4MTA2MDAsCiAgImV4cCI6IDE4NzE1NzcwMDAKfQ.wdLRO9uTwoZg-tdiP_yusL7a4Vx5_kO2edcWq-PtZu0")
# supabase: Client = create_client("https://s.a.synopseai.com", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogInNlcnZpY2Vfcm9sZSIsCiAgImlzcyI6ICJzdXBhYmFzZSIsCiAgImlhdCI6IDE3MTM4MTA2MDAsCiAgImV4cCI6IDE4NzE1NzcwMDAKfQ.wdLRO9uTwoZg-tdiP_yusL7a4Vx5_kO2edcWq-PtZu0")

esecret_ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g"
client = openai.OpenAI(
    base_url = "https://api.endpoints.anyscale.com/v1",
    api_key = esecret_ANYSCALE_API_KEY
)


# openai_key = "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"
client1 = openai.OpenAI(
    api_key = openai_key
)


AccountID = "36fd753272b7c0c0c7a336fc277ebc15"
Bucket =  "synopse-play"
ClientAccessKey = "079d987e48e7681c73b67a12059b9bd4"
ClientSecret = "95d7fec11edf4d332ab1aeffba985e68c38b26aefbf0c6ac45dedab1e0da5817"
ConnectionUrl = f"https://{AccountID}.r2.cloudflarestorage.com"

S3Connect = boto3.client(
    's3',
    endpoint_url=ConnectionUrl,
    aws_access_key_id=ClientAccessKey,
    aws_secret_access_key=ClientSecret,
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)

model_de = SentenceTransformer(
    "jinaai/jina-embeddings-v2-base-de",
    trust_remote_code=True
)
model_de.max_seq_length = 1024
model_indic = SentenceTransformer('l3cube-pune/indic-sentence-similarity-sbert')

def is_valid_timezone_format(published):
    try:
        date_format = "%a, %d %b %Y %H:%M:%S %z"
        date_object = datetime.strptime(published, date_format)

        hasura_timestamp = date_object.astimezone(timezone.utc).isoformat()
        return True, hasura_timestamp
    except ValueError:
        return False, None

def check_date_format(date_string):
    try:
        datetime.strptime(date_string, '%Y-%m-%dT%H:%M:%S%z')
        return True
    except ValueError:
        return False
    

def update_articles(offset):
    try: 
        type1 = "feedparser1: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_a04_rss_feeds').select('id, rss1_link, outlet, rss1_link_name, t_a03_outlets(rss_url_verify, language)').filter('rss1_link_type', 'eq', 11).limit(10).offset(offset).order('id').execute()
        for i1 in data2.data:
            rss_url = i1['rss1_link']
            rss_id = i1['id']
            rss_outlet = i1['outlet']
            rss_link_name = i1['rss1_link_name']
            rss_verify = (i1['t_a03_outlets']['rss_url_verify'])
            language = (i1['t_a03_outlets']['language'])
            feed = feedparser.parse(rss_url)
            v1 = []
            for entry in feed.entries:
                post_link = entry.link
                if rss_verify not in post_link:
                    continue
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
                if check_date_format(published):
                    hasura_timestamp = published
                else:
                    hasura_timestamp = datetime.now().astimezone(timezone.utc).isoformat()
                dt = datetime.fromisoformat(hasura_timestamp.replace("Z", "+00:00"))
                only_datetime = dt.strftime('%Y-%m-%d %H:%M:%S')
                if "author" in entry:
                    author = entry.author
                else:
                    author = "na"
                tags = []
                tags.append(rss_outlet)
                tags.append(rss_link_name)
                if 'tags' in entry:
                    for tag in entry.tags:
                        tags.append(tag.term)
                try:
                    data, count = supabase.table('t_c01_rss_articles').insert({'post_link': post_link, 'title': title, 'summary': summary, 'author': author, 'image_link': image_url, 'post_published': only_datetime, 'language': language, 'tags': tags, 'rss_feed_id': rss_id}).execute()
                except:
                    break
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_articles")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass    
        

def update_articles_main():
    try: 
        type1 = "feedparser1 Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        data2 = supabase.table('t_a04_rss_feeds').select('id').filter('rss1_link_type', 'eq', 11).order('id').execute()
        input_value = len(data2.data)
        rounded_value = ((input_value + 11) // 10) * 10
        output_array = list(range(0, rounded_value, 10))
        output_array2 = [output_array[i:i + 10] for i in range(0, len(output_array), 10)]
        for item in output_array2:
            processes = []
            for arg in item:
                process = multiprocessing.Process(target=update_articles, args=(arg,))
                processes.append(process)
                process.start()
            for process in processes:
                process.join()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_articles_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
    
def in_detail(offset):
    try: 
        type1 = "isdetail1: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, post_link, title, summary, language').filter('is_in_detail', 'is', False ).limit(100).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for i in data2.data:
                data, count = supabase.table('t_d02_rss_articles_detail').upsert({ 'article_id': i['id'], 'title': i['title'], 'detail': i['summary'], 'final_url': i['post_link'], 'language': i['language']}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_in_detail': True}).filter('id', 'eq', i['id']).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_in_details")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
    

def in_detail_main():
    try: 
        type1 = "indetail1 Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,300,600,900,1200,1500,1800,2100]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=in_detail, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_detail_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
    
def in_summary(offset):
    try: 
        type1 = "issummary1: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, post_link, title, summary, language').filter('is_summerized', 'is', False).filter('is_in_detail', 'eq', True).limit(100).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for i in data2.data:
                summary = i['title'] + " " + i['summary']
                words = summary.split()
                first_300_words = words[:300]
                first_300_words = ' '.join(first_300_words)
                data, count = supabase.table('t_e02_articles_summary').upsert({ 'article_id': i['id'], 'summary': summary, 'language': i['language']}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_summerized': True}).filter('id', 'eq', i['id']).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_summary")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def in_summary_main():
    try: 
        type1 = "insummary1 Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,300,600,900,1200,1500,1800,2100]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=in_summary, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_summary_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass


def vectorize_en(offset):
    try: 
        type1 = "vectorize en: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, t_e02_articles_summary(summary)').filter('is_summerized', 'is', True).filter('is_vectorized', 'eq', False).filter('language', 'eq', 'EN').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                text = item['t_e02_articles_summary'][0]['summary']
                tokens = encoding.encode(text)
                first_8_tokens = tokens[:400]
                first_8_tokens_text = encoding.decode(first_8_tokens)
                embedding = client.embeddings.create(
                    model="BAAI/bge-large-en-v1.5",
                    input=first_8_tokens_text,
                )
                e1 = embedding.model_dump()['data'][0]['embedding']
                data, count = supabase.table('t_f01_articles_vector_en').upsert({ 'article_id': id, 'embedding': e1}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_vectorized': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_en")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass

    
def vectorize_en_main():
    try: 
        type1 = "invector Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90,120,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=vectorize_en, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_en_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
    
def vectorize_de():
    try: 
        type1 = "vectorize de: all"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, t_e02_articles_summary(summary)').filter('is_summerized', 'is', True).filter('is_vectorized', 'eq', False).filter('language', 'eq', 'DE').limit(10).offset(0).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                text = item['t_e02_articles_summary'][0]['summary']
                tokens = encoding.encode(text)
                first_8_tokens = tokens[:800]
                first_8_tokens_text = encoding.decode(first_8_tokens)
                e1 = model_de.encode(first_8_tokens_text)
                data, count = supabase.table('t_f01_articles_vector_de').upsert({ 'article_id': id, 'embedding': e1.tolist()}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_vectorized': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_de")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def vectorize_hi():
    try: 
        type1 = "vectorize hi: all"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, t_e02_articles_summary(summary)').filter('is_summerized', 'is', True).filter('is_vectorized', 'eq', False).filter('language', 'eq', 'HI').limit(10).offset(0).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                text = item['t_e02_articles_summary'][0]['summary']
                tokens = encoding.encode(text)
                first_8_tokens = tokens[:800]
                first_8_tokens_text = encoding.decode(first_8_tokens)
                e1 = model_indic.encode(first_8_tokens_text)
                data, count = supabase.table('t_f01_articles_vector_hi').upsert({ 'article_id': id, 'embedding': e1.tolist()}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_vectorized': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_hi")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass

           
def vectorize_te():
    try: 
        type1 = "vectorize te: all"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, t_e02_articles_summary(summary)').filter('is_summerized', 'is', True).filter('is_vectorized', 'eq', False).filter('language', 'eq', 'TE').limit(10).offset(0).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                text = item['t_e02_articles_summary'][0]['summary']
                tokens = encoding.encode(text)
                first_8_tokens = tokens[:800]
                first_8_tokens_text = encoding.decode(first_8_tokens)
                e1 = model_indic.encode(first_8_tokens_text)
                data, count = supabase.table('t_f01_articles_vector_te').upsert({ 'article_id': id, 'embedding': e1.tolist()}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_vectorized': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_te")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
           
def vectorize_ta():
    try: 
        type1 = "vectorize ta: all"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, t_e02_articles_summary(summary)').filter('is_summerized', 'is', True).filter('is_vectorized', 'eq', False).filter('language', 'eq', 'TA').limit(10).offset(0).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                text = item['t_e02_articles_summary'][0]['summary']
                tokens = encoding.encode(text)
                first_8_tokens = tokens[:800]
                first_8_tokens_text = encoding.decode(first_8_tokens)
                e1 = model_indic.encode(first_8_tokens_text)
                data, count = supabase.table('t_f01_articles_vector_ta').upsert({ 'article_id': id, 'embedding': e1.tolist()}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_vectorized': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_vectors_ta")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass


def grouping_l1_en(offset):
    try: 
        type1 = "grouping_l1_en: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id').filter('is_vectorized', 'is', True).filter('is_grouped_l1', 'eq', False).filter('language', 'eq', 'EN').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.rpc('f_get_similar_articles_l1_en', {'article_id': id}).execute()
                article_ids = []
                for item2 in data3.data:
                    article_ids.append(item2['similar_article_id'])
                data, count = supabase.table('t_g01_article_groups_l1').upsert({ 'article_id': id, 'initial_group': article_ids, 'article_count': len(article_ids), 'language' : 'EN'}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l1': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_en")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def grouping_l1_en_main():
    try: 
        type1 = "grouping_l1_en Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,50,100,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=grouping_l1_en, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_en main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def grouping_l1_de(offset):
    try: 
        type1 = "grouping_l1_de: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id').filter('is_vectorized', 'is', True).filter('is_grouped_l1', 'eq', False).filter('language', 'eq', 'DE').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.rpc('f_get_similar_articles_l1_de', {'article_id': id}).execute()
                article_ids = []
                for item2 in data3.data:
                    article_ids.append(item2['similar_article_id'])
                data, count = supabase.table('t_g01_article_groups_l1').upsert({ 'article_id': id, 'initial_group': article_ids, 'article_count': len(article_ids), 'language' : 'DE'}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l1': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_de")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def grouping_l1_de_main():
    try: 
        type1 = "grouping_l1_de Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,50,100,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=grouping_l1_de, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_de main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def grouping_l1_hi(offset):
    try: 
        type1 = "grouping_l1_hi: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id').filter('is_vectorized', 'is', True).filter('is_grouped_l1', 'eq', False).filter('language', 'eq', 'HI').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.rpc('f_get_similar_articles_l1_hi', {'article_id': id}).execute()
                article_ids = []
                for item2 in data3.data:
                    article_ids.append(item2['similar_article_id'])
                data, count = supabase.table('t_g01_article_groups_l1').upsert({ 'article_id': id, 'initial_group': article_ids, 'article_count': len(article_ids), 'language' : 'HI'}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l1': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_hi")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def grouping_l1_hi_main():
    try: 
        type1 = "grouping_l1_hi Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,50,100,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=grouping_l1_hi, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_hi main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def grouping_l1_te(offset):
    try: 
        type1 = "grouping_l1_te: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id').filter('is_vectorized', 'is', True).filter('is_grouped_l1', 'eq', False).filter('language', 'eq', 'TE').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.rpc('f_get_similar_articles_l1_te', {'article_id': id}).execute()
                article_ids = []
                for item2 in data3.data:
                    article_ids.append(item2['similar_article_id'])
                data, count = supabase.table('t_g01_article_groups_l1').upsert({ 'article_id': id, 'initial_group': article_ids, 'article_count': len(article_ids), 'language' : 'TE'}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l1': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_te")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def grouping_l1_te_main():
    try: 
        type1 = "grouping_l1_te Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,50,100,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=grouping_l1_te, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_te main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def grouping_l1_ta(offset):
    try: 
        type1 = "grouping_l1_ta: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id').filter('is_vectorized', 'is', True).filter('is_grouped_l1', 'eq', False).filter('language', 'eq', 'TA').limit(10).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.rpc('f_get_similar_articles_l1_ta', {'article_id': id}).execute()
                article_ids = []
                for item2 in data3.data:
                    article_ids.append(item2['similar_article_id'])
                data, count = supabase.table('t_g01_article_groups_l1').upsert({ 'article_id': id, 'initial_group': article_ids, 'article_count': len(article_ids), 'language' : 'TA'}).execute()
                data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l1': True}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_ta")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass

def grouping_l1_ta_main():
    try: 
        type1 = "grouping_l1_ta Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,50,100,150]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=grouping_l1_ta, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l1_ta main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass

def grouping_l2_main():
    try: 
        type1 = "grouping_l2 Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        while True:
            data2 = supabase.table('v_h01_grouping_l2').select('id, initial_group,language').limit(10).offset(0).execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                language = item['language']
                initial_group = item['initial_group']
                initial_group_l1 = []
                for i1 in initial_group:
                    data3 = supabase.rpc('f_h01_get_grouping_l2', {'p_article_id': i1}).execute()
                    for i2 in data3.data:
                        for i3 in i2['initial_group']:
                            initial_group_l1.append(i3)
                initial_group_l1 = sorted(list(set(initial_group_l1)), reverse=True)
                initial_group_l2 = []
                for i1 in initial_group_l1:
                    data3 = supabase.rpc('f_h01_get_grouping_l2', {'p_article_id': i1}).execute()
                    for i2 in data3.data:
                        for i3 in i2['initial_group']:
                            initial_group_l2.append(i3)
                initial_group_l2 = sorted(list(set(initial_group_l1)), reverse=True)
                final_group = []
                if initial_group_l2 != initial_group:
                    initial_group_l3 = []
                    for i1 in initial_group_l2:
                        data3 = supabase.rpc('f_h01_get_grouping_l2', {'p_article_id': i1}).execute()
                        for i2 in data3.data:
                            for i3 in i2['initial_group']:
                                initial_group_l3.append(i3)
                    initial_group_l3 = sorted(list(set(initial_group_l3)), reverse=True)
                    final_group = initial_group_l3
                else:
                    final_group = initial_group_l2
                final_group.append(id)
                final_group = sorted(list(set(final_group)), reverse=True)
                first_article = final_group[-1]
                data3 = supabase.rpc('f_h01_get_grouping_l2_check', {'p_article_id': first_article}).execute()
                if (len(data3.data) == 0):
                    data, count = supabase.table('t_h01_article_groups_l2').upsert({ 'articles_group': final_group, 'articles_in_group': len(final_group), 'language' : language}).execute()
                else:
                    data, count = supabase.table('t_h01_article_groups_l2').update({ 'articles_group': final_group, 'articles_in_group': len(final_group), 'language' : language}).eq('id', data3.data[0]['id']).execute()
                for i10 in final_group:
                    data, count = supabase.table('t_c01_rss_articles').update({'is_grouped_l2': True}).filter('id', 'eq', i10).execute()   
                break
        
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in grouping_l2 main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
  
def extract_json(s):
    start = s.find('{')
    end = s.rfind('}') + 1  # +1 to include the '}' in the substring
    json_str = s[start:end]
    try:
        return json.loads(json_str)
    except json.JSONDecodeError:
        return None

def gen_final_article_en(offset):
    try: 
        type1 = "gen_final_article_en: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('tag').filter('language', 'eq', 'EN').execute()
        tags = []
        for item in data2.data:
            tags.append(item['tag'])
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
                Ensure the selected tags is amoung """ + str(tags) + '"""'
        while True:
            data2 = supabase.table('v_h02_grouping_l2_summerize').select('id').filter('language', 'eq', 'EN').limit(1).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.table('t_h01_article_groups_l2').select('articles_group').filter('id', 'eq', id).execute()
                articles_group = data3.data[0]['articles_group']
                summary = ""
                i11 = 0
                for i1 in articles_group:
                    i11 = i11 + 1
                    if i11 > 10:
                        break
                    data4 = supabase.table('t_e02_articles_summary').select('summary').filter('article_id', 'eq', i1).execute()
                    summary = summary + data4.data[0]['summary']
                tokens = encoding.encode(summary)
                first_8_tokens = tokens[:7000]
                first_8_tokens = encoding.decode(first_8_tokens)
                user_prompt = "all article data: " +  first_8_tokens
                
                article_group_id = id
                title = "" 
                summary = "" 
                llm_keypoints = [] 
                llm_keywords = [] 
                llm_tags = [] 
                language = "EN"
                
                t5 = True
                t6 = 0
                out3 = False
                while t5:
                    t6 = t6 + 1
                    chat_completion = client.chat.completions.create(
                        model="mistralai/Mixtral-8x7B-Instruct-v0.1",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        max_tokens = 500,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    if title == "":
                        try:
                            title = json_obj['title']
                        except:
                            pass
                    if summary == "":
                        try:
                            summary = json_obj['body']
                        except:
                            pass
                    if llm_keypoints == []:
                        try:
                            llm_keypoints = [item['point'] for item in json_obj['keypoints']]
                        except:
                            pass
                    if llm_keywords == []:
                        try:
                            llm_keywords = json_obj['keywords']
                        except:
                            pass
                    if llm_tags == []:
                        try:
                            llm_tags = json_obj['tags']
                        except:
                            pass
                    if title != "" and summary != "" and llm_keypoints != [] and llm_keywords != [] and llm_tags != []:
                        t5 = False
                        break
                    if t6 > 3:
                        break
                data, count = supabase.table('t_h02_article_groups_l2_detail').insert({ 'article_group_id': article_group_id, 'title': title, 'summary': summary, 'llm_keypoints': llm_keypoints, 'llm_keywords': llm_keywords, 'llm_tags': llm_tags, 'language': language}).execute()
                data, count = supabase.table('t_h01_article_groups_l2').update({'is_summerized': True}).filter('id', 'eq', article_group_id).execute()
                    
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_en")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_final_article_en_main():
    try: 
        type1 = "gen_final_article_en_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article_en, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_en_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        

def gen_final_article_de(offset):
    try: 
        type1 = "gen_final_article_de: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('tag').filter('language', 'eq', 'DE').execute()
        tags = []
        for item in data2.data:
            tags.append(item['tag'])
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
          Stellen Sie sicher, dass die ausgewählten Tags passend sind. """ + str(tags) + '"""'
        while True:
            data2 = supabase.table('v_h02_grouping_l2_summerize').select('id').filter('language', 'eq', 'DE').limit(1).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.table('t_h01_article_groups_l2').select('articles_group').filter('id', 'eq', id).execute()
                articles_group = data3.data[0]['articles_group']
                summary = ""
                i11 = 0
                for i1 in articles_group:
                    i11 = i11 + 1
                    if i11 > 10:
                        break
                    data4 = supabase.table('t_e02_articles_summary').select('summary').filter('article_id', 'eq', i1).execute()
                    summary = summary + data4.data[0]['summary']
                tokens = encoding.encode(summary)
                first_8_tokens = tokens[:7000]
                first_8_tokens = encoding.decode(first_8_tokens)
                user_prompt = "all article data: " +  first_8_tokens
                
                article_group_id = id
                title = "" 
                summary = "" 
                llm_keypoints = [] 
                llm_keywords = [] 
                llm_tags = [] 
                language = "DE"
                
                t5 = True
                t6 = 0
                out3 = False
                while t5:
                    t6 = t6 + 1
                    chat_completion = client.chat.completions.create(
                        model="mistralai/Mixtral-8x7B-Instruct-v0.1",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        max_tokens = 500,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    if title == "":
                        try:
                            title = json_obj['title']
                        except:
                            pass
                    if summary == "":
                        try:
                            summary = json_obj['body']
                        except:
                            pass
                    if llm_keypoints == []:
                        try:
                            llm_keypoints = [item['point'] for item in json_obj['keypoints']]
                        except:
                            pass
                    if llm_keywords == []:
                        try:
                            llm_keywords = json_obj['keywords']
                        except:
                            pass
                    if llm_tags == []:
                        try:
                            llm_tags = json_obj['tags']
                        except:
                            pass
                    if title != "" and summary != "" and llm_keypoints != [] and llm_keywords != [] and llm_tags != []:
                        t5 = False
                        break
                    if t6 > 3:
                        break
                data, count = supabase.table('t_h02_article_groups_l2_detail').insert({ 'article_group_id': article_group_id, 'title': title, 'summary': summary, 'llm_keypoints': llm_keypoints, 'llm_keywords': llm_keywords, 'llm_tags': llm_tags, 'language': language}).execute()
                data, count = supabase.table('t_h01_article_groups_l2').update({'is_summerized': True}).filter('id', 'eq', article_group_id).execute()
                    
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_de")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_final_article_de_main():
    try: 
        type1 = "gen_final_article_de_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article_de, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_de_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        

def gen_final_article_hi(offset):
    try: 
        type1 = "gen_final_article_hi: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('tag').filter('language', 'eq', 'HI').execute()
        tags = []
        for item in data2.data:
            tags.append(item['tag'])
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
           सुनिश्चित करें कि चयनित टैग शामिल हैं """ + str(tags) + '"""'
        while True:
            data2 = supabase.table('v_h02_grouping_l2_summerize').select('id').filter('language', 'eq', 'HI').limit(1).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.table('t_h01_article_groups_l2').select('articles_group').filter('id', 'eq', id).execute()
                articles_group = data3.data[0]['articles_group']
                summary = ""
                i11 = 0
                for i1 in articles_group:
                    i11 = i11 + 1
                    if i11 > 10:
                        break
                    data4 = supabase.table('t_e02_articles_summary').select('summary').filter('article_id', 'eq', i1).execute()
                    summary = summary + data4.data[0]['summary']
                tokens = encoding.encode(summary)
                first_8_tokens = tokens[:7000]
                first_8_tokens = encoding.decode(first_8_tokens)
                user_prompt = "all article data: " +  first_8_tokens
                
                article_group_id = id
                title = "" 
                summary = "" 
                llm_keypoints = [] 
                llm_keywords = [] 
                llm_tags = [] 
                language = "HI"
                
                t5 = True
                t6 = 0
                out3 = False
                while t5:
                    t6 = t6 + 1
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    if title == "":
                        try:
                            title = json_obj['title']
                        except:
                            pass
                    if summary == "":
                        try:
                            summary = json_obj['body']
                        except:
                            pass
                    if llm_keypoints == []:
                        try:
                            llm_keypoints = [item['point'] for item in json_obj['keypoints']]
                        except:
                            pass
                    if llm_keywords == []:
                        try:
                            llm_keywords = json_obj['keywords']
                        except:
                            pass
                    if llm_tags == []:
                        try:
                            llm_tags = json_obj['tags']
                        except:
                            pass
                    if title != "" and summary != "" and llm_keypoints != [] and llm_keywords != [] and llm_tags != []:
                        t5 = False
                        break
                    if t6 > 3:
                        break
                data, count = supabase.table('t_h02_article_groups_l2_detail').insert({ 'article_group_id': article_group_id, 'title': title, 'summary': summary, 'llm_keypoints': llm_keypoints, 'llm_keywords': llm_keywords, 'llm_tags': llm_tags, 'language': language}).execute()
                data, count = supabase.table('t_h01_article_groups_l2').update({'is_summerized': True}).filter('id', 'eq', article_group_id).execute()
                    
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_hi")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_final_article_hi_main():
    try: 
        type1 = "gen_final_article_hi_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article_hi, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_hi_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        

def gen_final_article_te(offset):
    try: 
        type1 = "gen_final_article_te: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('tag').filter('language', 'eq', 'TE').execute()
        tags = []
        for item in data2.data:
            tags.append(item['tag'])
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
           ఎంచుకున్న ట్యాగ్‌లు అమోంగ్‌గా ఉన్నాయని నిర్ధారించుకోండి """ + str(tags) + '"""'
        while True:
            data2 = supabase.table('v_h02_grouping_l2_summerize').select('id').filter('language', 'eq', 'TE').limit(1).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.table('t_h01_article_groups_l2').select('articles_group').filter('id', 'eq', id).execute()
                articles_group = data3.data[0]['articles_group']
                summary = ""
                i11 = 0
                for i1 in articles_group:
                    i11 = i11 + 1
                    if i11 > 10:
                        break
                    data4 = supabase.table('t_e02_articles_summary').select('summary').filter('article_id', 'eq', i1).execute()
                    summary = summary + data4.data[0]['summary']
                tokens = encoding.encode(summary)
                first_8_tokens = tokens[:7000]
                first_8_tokens = encoding.decode(first_8_tokens)
                user_prompt = "all article data: " +  first_8_tokens
                
                article_group_id = id
                title = "" 
                summary = "" 
                llm_keypoints = [] 
                llm_keywords = [] 
                llm_tags = [] 
                language = "TE"
                
                t5 = True
                t6 = 0
                out3 = False
                while t5:
                    t6 = t6 + 1
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    if title == "":
                        try:
                            title = json_obj['title']
                        except:
                            pass
                    if summary == "":
                        try:
                            summary = json_obj['body']
                        except:
                            pass
                    if llm_keypoints == []:
                        try:
                            llm_keypoints = [item['point'] for item in json_obj['keypoints']]
                        except:
                            pass
                    if llm_keywords == []:
                        try:
                            llm_keywords = json_obj['keywords']
                        except:
                            pass
                    if llm_tags == []:
                        try:
                            llm_tags = json_obj['tags']
                        except:
                            pass
                    if title != "" and summary != "" and llm_keypoints != [] and llm_keywords != [] and llm_tags != []:
                        t5 = False
                        break
                    if t6 > 3:
                        break
                data, count = supabase.table('t_h02_article_groups_l2_detail').insert({ 'article_group_id': article_group_id, 'title': title, 'summary': summary, 'llm_keypoints': llm_keypoints, 'llm_keywords': llm_keywords, 'llm_tags': llm_tags, 'language': language}).execute()
                data, count = supabase.table('t_h01_article_groups_l2').update({'is_summerized': True}).filter('id', 'eq', article_group_id).execute()
                    
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_te")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_final_article_te_main():
    try: 
        type1 = "gen_final_article_te_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article_te, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_te_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
        
        

def gen_final_article_ta(offset):
    try: 
        type1 = "gen_final_article_ta: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('tag').filter('language', 'eq', 'TA').execute()
        tags = []
        for item in data2.data:
            tags.append(item['tag'])
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
           தேர்ந்தெடுக்கப்பட்ட குறிச்சொற்கள் ஏராளமானவை என்பதை உறுதிப்படுத்தவும் """ + str(tags) + '"""'
        while True:
            data2 = supabase.table('v_h02_grouping_l2_summerize').select('id').filter('language', 'eq', 'TA').limit(1).offset(offset).order('id').execute()
            if len(data2.data) == 0:
                break
            for item in data2.data:
                id = item['id']
                data3 = supabase.table('t_h01_article_groups_l2').select('articles_group').filter('id', 'eq', id).execute()
                articles_group = data3.data[0]['articles_group']
                summary = ""
                i11 = 0
                for i1 in articles_group:
                    i11 = i11 + 1
                    if i11 > 10:
                        break
                    data4 = supabase.table('t_e02_articles_summary').select('summary').filter('article_id', 'eq', i1).execute()
                    summary = summary + data4.data[0]['summary']
                tokens = encoding.encode(summary)
                first_8_tokens = tokens[:7000]
                first_8_tokens = encoding.decode(first_8_tokens)
                user_prompt = "all article data: " +  first_8_tokens
                
                article_group_id = id
                title = "" 
                summary = "" 
                llm_keypoints = [] 
                llm_keywords = [] 
                llm_tags = [] 
                language = "TA"
                
                t5 = True
                t6 = 0
                out3 = False
                # print(user_prompt)
                while t5:
                    t6 = t6 + 1
                    
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    if title == "":
                        try:
                            title = json_obj['title']
                        except:
                            pass
                    if summary == "":
                        try:
                            summary = json_obj['body']
                        except:
                            pass
                    if llm_keypoints == []:
                        try:
                            llm_keypoints = [item['point'] for item in json_obj['keypoints']]
                        except:
                            pass
                    if llm_keywords == []:
                        try:
                            llm_keywords = json_obj['keywords']
                        except:
                            pass
                    if llm_tags == []:
                        try:
                            llm_tags = json_obj['tags']
                        except:
                            pass
                    if title != "" and summary != "" and llm_keypoints != [] and llm_keywords != [] and llm_tags != []:
                        t5 = False
                        break
                    if t6 > 3:
                        break
                data, count = supabase.table('t_h02_article_groups_l2_detail').insert({ 'article_group_id': article_group_id, 'title': title, 'summary': summary, 'llm_keypoints': llm_keypoints, 'llm_keywords': llm_keywords, 'llm_tags': llm_tags, 'language': language}).execute()
                data, count = supabase.table('t_h01_article_groups_l2').update({'is_summerized': True}).filter('id', 'eq', article_group_id).execute()
                    
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_ta")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_final_article_ta_main():
    try: 
        type1 = "gen_final_article_ta_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_final_article_ta, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_final_article_ta_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def gen_ai_tagging_en(offset):
    try: 
        type1 = "gen_ai_tagging_en: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('id, tag').filter('language', 'eq', 'EN').execute()
        tags = []
        ids = []
        for item in data2.data:
            tags.append(item['tag'])
            ids.append(item['id'])
        while True:
            data2 = supabase.table('t_h01_article_groups_l2').select('id').filter('is_summerized', 'is', True).filter('is_ai_tagged', 'eq', False).filter('language', 'eq', 'EN').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('id, title, summary, llm_keypoints, llm_keywords, llm_tags').filter('article_group_id', 'eq', id).execute()
            llm_tags = data2.data[0]['llm_tags']
            tag_name = ""
            tag_id = 0
            for item in llm_tags:
                if item in tags:
                    tag_name = item
                    tag_id = ids[tags.index(item)]
                    break
            if tag_name == "":
                system_prompt = """
                    you are a topic classifier model.
                    Create a JSON object with the following structure:
                    {
                    "topic": "topic name"
                    }
                    
                    match the topic name to the list of topics available below, ensure the selected topics is amoung """ + str(tags) + '"""'
                summary = data2.data[0]['summary'] + " " + data2.data[0]['title'] + " " + ' '.join(data2.data[0]['llm_keypoints']) + " " + ' '.join(data2.data[0]['llm_keywords']) + " " + ' '.join(data2.data[0]['llm_tags'])
                user_prompt = "all article data: " +  summary
                t5 = True
                t6 = 0
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
                    tag_output = ""
                    try:
                        tag_output = json_obj['topic']
                    except:
                        pass
                    if tag_output != "":
                        if tag_output in tags:
                            tag_name = tag_output
                            tag_id = ids[tags.index(tag_output)]
                            t5 = False
                            break
                    if t6 > 3:
                        tag_name = "Society & Culture"
                        tag_id = 170
                        break
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'tag_id': tag_id}).filter('article_group_id', 'eq', id).execute()
            data, count = supabase.table('t_h01_article_groups_l2').update({'is_ai_tagged': True}).filter('id', 'eq', id).execute()
                
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_en")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_ai_tagging_en_main():
    try: 
        type1 = "gen_ai_tagging_en_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_ai_tagging_en, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_en_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def gen_ai_tagging_de(offset):
    try: 
        type1 = "gen_ai_tagging_de: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('id, tag').filter('language', 'eq', 'DE').execute()
        tags = []
        ids = []
        for item in data2.data:
            tags.append(item['tag'])
            ids.append(item['id'])
        while True:
            data2 = supabase.table('t_h01_article_groups_l2').select('id').filter('is_summerized', 'is', True).filter('is_ai_tagged', 'eq', False).filter('language', 'eq', 'DE').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('id, title, summary, llm_keypoints, llm_keywords, llm_tags').filter('article_group_id', 'eq', id).execute()
            llm_tags = data2.data[0]['llm_tags']
            tag_name = ""
            tag_id = 0
            for item in llm_tags:
                if item in tags:
                    tag_name = item
                    tag_id = ids[tags.index(item)]
                    break
            if tag_name == "":
                system_prompt = """
                    Sie sind ein Themenklassifikatormodell.
                        Erstellen Sie ein JSON-Objekt mit der folgenden Struktur:
                        {
                        „topic“: „Themenname“
                        }
                    Ordnen Sie den Themennamen der Liste der unten verfügbaren Themen zu und stellen Sie sicher, dass die ausgewählten Themen darin enthalten sind """ + str(tags) + '"""'
                summary = data2.data[0]['summary'] + " " + data2.data[0]['title'] + " " + ' '.join(data2.data[0]['llm_keypoints']) + " " + ' '.join(data2.data[0]['llm_keywords']) + " " + ' '.join(data2.data[0]['llm_tags'])
                user_prompt = "all article data: " +  summary
                t5 = True
                t6 = 0
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
                    tag_output = ""
                    try:
                        tag_output = json_obj['topic']
                    except:
                        pass
                    if tag_output != "":
                        if tag_output in tags:
                            tag_name = tag_output
                            tag_id = ids[tags.index(tag_output)]
                            t5 = False
                            break
                    if t6 > 3:
                        tag_name = "Gesellschaft & Kultur"
                        tag_id = 128
                        break
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'tag_id': tag_id}).filter('article_group_id', 'eq', id).execute()
            data, count = supabase.table('t_h01_article_groups_l2').update({'is_ai_tagged': True}).filter('id', 'eq', id).execute()
              
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_de")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_ai_tagging_de_main():
    try: 
        type1 = "gen_ai_tagging_de_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_ai_tagging_de, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_de_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
   
def gen_ai_tagging_hi(offset):
    try: 
        type1 = "gen_ai_tagging_hi: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('id, tag').filter('language', 'eq', 'HI').execute()
        tags = []
        ids = []
        for item in data2.data:
            tags.append(item['tag'])
            ids.append(item['id'])
        while True:
            data2 = supabase.table('t_h01_article_groups_l2').select('id').filter('is_summerized', 'is', True).filter('is_ai_tagged', 'eq', False).filter('language', 'eq', 'HI').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('id, title, summary, llm_keypoints, llm_keywords, llm_tags').filter('article_group_id', 'eq', id).execute()
            llm_tags = data2.data[0]['llm_tags']
            tag_name = ""
            tag_id = 0
            for item in llm_tags:
                if item in tags:
                    tag_name = item
                    tag_id = ids[tags.index(item)]
                    break
            if tag_name == "":
                system_prompt = """
                    आप एक विषय वर्गीकरणकर्ता मॉडल हैं।
                        निम्नलिखित संरचना के साथ एक JSON ऑब्जेक्ट बनाएं:
                        {
                        "विषय": "विषय का नाम"
                        }
                    विषय के नाम को नीचे उपलब्ध विषयों की सूची से मिलाएं, सुनिश्चित करें कि चयनित विषय उनमें से हैं """ + str(tags) + '"""'
                summary = data2.data[0]['summary'] + " " + data2.data[0]['title'] + " " + ' '.join(data2.data[0]['llm_keypoints']) + " " + ' '.join(data2.data[0]['llm_keywords']) + " " + ' '.join(data2.data[0]['llm_tags'])
                user_prompt = "all article data: " +  summary
                t5 = True
                t6 = 0
                while t5:
                    t6 = t6 + 1
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    tag_output = ""
                    try:
                        tag_output = json_obj['topic']
                    except:
                        pass
                    if tag_output != "":
                        if tag_output in tags:
                            tag_name = tag_output
                            tag_id = ids[tags.index(tag_output)]
                            t5 = False
                            break
                    if t6 > 3:
                        tag_name = "समाज और संस्कृति"
                        tag_id = 142
                        break
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'tag_id': tag_id}).filter('article_group_id', 'eq', id).execute()
            data, count = supabase.table('t_h01_article_groups_l2').update({'is_ai_tagged': True}).filter('id', 'eq', id).execute()
                
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_hi")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_ai_tagging_hi_main():
    try: 
        type1 = "gen_ai_tagging_hi_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_ai_tagging_hi, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_hi_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
             
def gen_ai_tagging_te(offset):
    try: 
        type1 = "gen_ai_tagging_te: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('id, tag').filter('language', 'eq', 'TE').execute()
        tags = []
        ids = []
        for item in data2.data:
            tags.append(item['tag'])
            ids.append(item['id'])
        while True:
            data2 = supabase.table('t_h01_article_groups_l2').select('id').filter('is_summerized', 'is', True).filter('is_ai_tagged', 'eq', False).filter('language', 'eq', 'TE').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('id, title, summary, llm_keypoints, llm_keywords, llm_tags').filter('article_group_id', 'eq', id).execute()
            llm_tags = data2.data[0]['llm_tags']
            tag_name = ""
            tag_id = 0
            for item in llm_tags:
                if item in tags:
                    tag_name = item
                    tag_id = ids[tags.index(item)]
                    break
            if tag_name == "":
                system_prompt = """
                    మీరు టాపిక్ వర్గీకరణ మోడల్.
                        కింది నిర్మాణంతో JSON వస్తువును సృష్టించండి:
                        {
                        "టాపిక్": "టాపిక్ పేరు"
                        }
                    దిగువన అందుబాటులో ఉన్న అంశాల జాబితాకు టాపిక్ పేరును సరిపోల్చండి, ఎంచుకున్న అంశాలు ఎక్కువగా ఉన్నాయని నిర్ధారించుకోండి """ + str(tags) + '"""'
                summary = data2.data[0]['summary'] + " " + data2.data[0]['title'] + " " + ' '.join(data2.data[0]['llm_keypoints']) + " " + ' '.join(data2.data[0]['llm_keywords']) + " " + ' '.join(data2.data[0]['llm_tags'])
                user_prompt = "all article data: " +  summary
                t5 = True
                t6 = 0
                while t5:
                    t6 = t6 + 1
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    tag_output = ""
                    try:
                        tag_output = json_obj['topic']
                    except:
                        pass
                    if tag_output != "":
                        if tag_output in tags:
                            tag_name = tag_output
                            tag_id = ids[tags.index(tag_output)]
                            t5 = False
                            break
                    if t6 > 3:
                        tag_name = "சமூகம் & பண்பாடு"
                        tag_id = 98
                        break
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'tag_id': tag_id}).filter('article_group_id', 'eq', id).execute()
            data, count = supabase.table('t_h01_article_groups_l2').update({'is_ai_tagged': True}).filter('id', 'eq', id).execute()
                
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_te")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_ai_tagging_te_main():
    try: 
        type1 = "gen_ai_tagging_te_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_ai_tagging_te, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_te_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
def gen_ai_tagging_ta(offset):
    try: 
        type1 = "gen_ai_tagging_ta: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        data2 = supabase.table('t_i02_tags_all_languages').select('id, tag').filter('language', 'eq', 'TA').execute()
        tags = []
        ids = []
        for item in data2.data:
            tags.append(item['tag'])
            ids.append(item['id'])
        while True:
            data2 = supabase.table('t_h01_article_groups_l2').select('id').filter('is_summerized', 'is', True).filter('is_ai_tagged', 'eq', False).filter('language', 'eq', 'TA').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('id, title, summary, llm_keypoints, llm_keywords, llm_tags').filter('article_group_id', 'eq', id).execute()
            llm_tags = data2.data[0]['llm_tags']
            tag_name = ""
            tag_id = 0
            for item in llm_tags:
                if item in tags:
                    tag_name = item
                    tag_id = ids[tags.index(item)]
                    break
            if tag_name == "":
                system_prompt = """
                    நீங்கள் ஒரு தலைப்பு வகைப்படுத்தி மாதிரி.
                        பின்வரும் கட்டமைப்புடன் JSON பொருளை உருவாக்கவும்:
                        {
                        "தலைப்பு": "தலைப்பு பெயர்"
                        }
                    கீழே உள்ள தலைப்புகளின் பட்டியலுடன் தலைப்பின் பெயரைப் பொருத்தவும், தேர்ந்தெடுக்கப்பட்ட தலைப்புகள் ஏராளமாக இருப்பதை உறுதிப்படுத்தவும் """ + str(tags) + '"""'
                summary = data2.data[0]['summary'] + " " + data2.data[0]['title'] + " " + ' '.join(data2.data[0]['llm_keypoints']) + " " + ' '.join(data2.data[0]['llm_keywords']) + " " + ' '.join(data2.data[0]['llm_tags'])
                user_prompt = "all article data: " +  summary
                t5 = True
                t6 = 0
                while t5:
                    t6 = t6 + 1
                    chat_completion = client1.chat.completions.create(
                        model="gpt-3.5-turbo",
                        messages=[{"role": "system", "content": system_prompt},
                                    {"role": "user", "content": user_prompt}],
                        # max_tokens = 2048,
                        temperature = 0.1 + (t6 * 0.1),
                        top_p = 0.9,
                    )
                    json_obj = extract_json(chat_completion.choices[0].message.content)
                    tag_output = ""
                    try:
                        tag_output = json_obj['topic']
                    except:
                        pass
                    if tag_output != "":
                        if tag_output in tags:
                            tag_name = tag_output
                            tag_id = ids[tags.index(tag_output)]
                            t5 = False
                            break
                    if t6 > 3:
                        tag_name = "సమాజం & సంస్కృతి"
                        tag_id = 139
                        break
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'tag_id': tag_id}).filter('article_group_id', 'eq', id).execute()
            data, count = supabase.table('t_h01_article_groups_l2').update({'is_ai_tagged': True}).filter('id', 'eq', id).execute()
              
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_ta")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
     
def gen_ai_tagging_ta_main():
    try: 
        type1 = "gen_ai_tagging_ta_main Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=gen_ai_tagging_ta, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in gen_ai_tagging_ta_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass

def is_image_large(image_data, max_size=200 * 1024):
    return len(image_data) > max_size

def download_image(url):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.content
        else:
            return None
    except:
        return None
    
def resize_image(image_data, max_size=100 * 1024):
    try: 
        image = Image.open(BytesIO(image_data))
        if image.mode != 'RGB':
            image = image.convert('RGB')
        quality = 90
        while len(image_data) > max_size and quality > 0:
            output_io = BytesIO()
            image.save(output_io, format='JPEG', quality=quality)
            image_data = output_io.getvalue()
            quality -= 10  # reduce quality by 10 each iteration
        return image_data
    except:
        return None

def print_image_resolution(image_data):
    image = Image.open(BytesIO(image_data))
    print(f"Image resolution: {image.size[0]} x {image.size[1]}")

def save_image(image_data, filename):
    image = Image.open(BytesIO(image_data))
    image.save(filename)

def save_image_to_cf(offset):
    try: 
        type1 = "save_image_to_cf: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, image_link').filter('image_link', 'neq', '').filter('cf_image_link', 'eq', '').limit(1).offset(offset).execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            image_link = data2.data[0]['image_link']
            image_url = "na"
            image_data = download_image(image_link)
            if image_data is not None:
                resized_image_data  = resize_image(image_data)
                if resized_image_data is not None:
                    resized_image_file = BytesIO(resized_image_data)
                    filename = str(id) + ".jpeg"
                    rs = s3_upload(
                        Bucket=Bucket, 
                        S3Client=S3Connect,
                        TargetFilePath=filename,
                        SourceFilePath=filename,
                        UploadObject=resized_image_file.getvalue(),
                        UploadMethod="Object"
                    )
            data, count = supabase.table('t_c01_rss_articles').update({'cf_image_link': filename}).filter('id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in save_image_to_cf")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
        
def save_image_to_cf_main():
    try: 
        type1 = "save_image_to_cf Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=save_image_to_cf, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in save_image_to_cf_main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass


def update_final_logos(offset):
    try: 
        type1 = "update_final_logos: " + str(offset)
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        while True:
            data2 = supabase.table('t_h02_article_groups_l2_detail').select('article_group_id, t_h01_article_groups_l2(articles_group)').is_('logo_urls','null').is_('t_h01_article_groups_l2.is_ai_tagged', 'True').limit(1).order('id').execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['article_group_id']
            articles_group = data2.data[0]['t_h01_article_groups_l2']['articles_group']
            data2 = supabase.table('t_c01_rss_articles').select('cf_image_link,t_a04_rss_feeds(t_a03_outlets(logo_url, outlet_display))').in_('id',articles_group).execute()
            outlets = []
            logoUrls = []
            imageUrls = []
            for item in data2.data:
                logoUrls.append(item['t_a04_rss_feeds']['t_a03_outlets']['logo_url'])
                outlets.append(item['t_a04_rss_feeds']['t_a03_outlets']['outlet_display'])
                if item['cf_image_link'] != "" and item['cf_image_link'] != None and item['cf_image_link'] != 'na':
                    imageUrls.append(item['cf_image_link'])
            logoUrls = list(set(logoUrls))
            outlets = list(set(outlets))
            imageUrls = list(set(imageUrls))
            data, count = supabase.table('t_h02_article_groups_l2_detail').update({'logo_urls': logoUrls, 'outlets': outlets, 'image_urls': imageUrls}).filter('article_group_id', 'eq', id).execute()
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_final_logos")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
        
def update_final_logos_main():
    try: 
        type1 = "update_final_logos Main"
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        args = [0,30,60,90]
        processes = []
        for arg in args:
            process = multiprocessing.Process(target=update_final_logos, args=(arg,))
            processes.append(process)
            process.start()
        for process in processes:
            process.join()
            
        end_date = datetime.now(timezone.utc).replace(microsecond=0)
        end_date_str = end_date.isoformat()
        data1 = {"success": True, "end_date": end_date_str}
        data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
    except Exception as e:
        try:
            print("Error in update_final_logos Main")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
            pass
        except:
            pass
        
if __name__ == "__main__": 
    while True:
        try:
            update_articles_main()
            in_detail_main()
            in_summary_main()
            vectorize_en_main()
            vectorize_de()
            vectorize_hi()
            vectorize_te()
            vectorize_ta()
            grouping_l1_en_main()
            grouping_l1_de_main()
            grouping_l1_hi_main()
            grouping_l1_te_main()
            grouping_l1_ta_main()
            grouping_l2_main()
            gen_final_article_en_main()
            gen_final_article_de_main()
            gen_final_article_hi_main()
            gen_final_article_te_main()
            gen_final_article_ta_main()
            gen_ai_tagging_en_main()
            gen_ai_tagging_de_main()
            gen_ai_tagging_hi_main()
            gen_ai_tagging_te_main()
            gen_ai_tagging_ta_main()
            save_image_to_cf_main()
            update_final_logos_main()
        except Exception as e:
            print(f"An error occurred: {e}")
        finally:
            time.sleep(60)  # wait for 60 seconds
