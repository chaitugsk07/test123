from supabase import create_client, Client
from datetime import datetime, timezone
import time
import openai
import tiktoken
import requests
import json
from PIL import Image
from io import BytesIO
from dataplane import s3_upload
import boto3
from botocore.client import Config
import subprocess
import random
import os
from pydub import AudioSegment

from multiprocessing import Process, set_start_method
import multiprocessing

encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
# supabase: Client = create_client("http://supa-supabase-kong.supabase.svc.cluster.local:8000", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogInNlcnZpY2Vfcm9sZSIsCiAgImlzcyI6ICJzdXBhYmFzZSIsCiAgImlhdCI6IDE3MTM4MTA2MDAsCiAgImV4cCI6IDE4NzE1NzcwMDAKfQ.wdLRO9uTwoZg-tdiP_yusL7a4Vx5_kO2edcWq-PtZu0")
supabase: Client = create_client("https://s.a.synopseai.com", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogInNlcnZpY2Vfcm9sZSIsCiAgImlzcyI6ICJzdXBhYmFzZSIsCiAgImlhdCI6IDE3MTM4MTA2MDAsCiAgImV4cCI6IDE4NzE1NzcwMDAKfQ.wdLRO9uTwoZg-tdiP_yusL7a4Vx5_kO2edcWq-PtZu0")

url = "http://synopse1indic-embed-service.looprunner.svc.cluster.local:80/v1/embeddings"
# url = "http://localhost/v1/embeddings"
headers = {
    "Authorization": "Bearer sk-aaabbbcccdddeeefffggghhhiiijjjkkk",
    "Content-Type": "application/json",
}

client1 = openai.OpenAI(
    api_key = openai_key
)


AccountID = "36fd753272b7c0c0c7a336fc277ebc15"
Bucket =  "synopse-play"
ClientAccessKey = "079d987e48e7681c73b67a12059b9bd4"
ClientSecret = "397f553b0f3dae53fe0817f3769c5823d9a0df25d29706af8d60f82e8ee88cfb"
ConnectionUrl = f"https://{AccountID}.r2.cloudflarestorage.com"

S3Connect = boto3.client(
    's3',
    endpoint_url=ConnectionUrl,
    aws_access_key_id=ClientAccessKey,
    aws_secret_access_key=ClientSecret,
    config=Config(signature_version='s3v4'),
    region_name='auto'
)

AccountIDPlay = "2a82631975ac4963077b1afc35711012"
BucketPlay =  "audio"
ClientAccessKeyPlay = "4d0e74f3322d985902146ec38757a55c"
ClientSecretPlay = "54ddb40931336a28966d940884106ccb959b825dfbdbfadc5c6bc21edf3ac3b1"
ConnectionUrlPlay = f"https://{AccountIDPlay}.r2.cloudflarestorage.com"

S3ConnectPlay = boto3.client(
    's3',
    endpoint_url=ConnectionUrlPlay,
    aws_access_key_id=ClientAccessKeyPlay,
    aws_secret_access_key=ClientSecretPlay,
    config=Config(signature_version='s3v4'),
    region_name='auto'
)


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
        type1 = "save_image_to_cf: "
        start_date = datetime.now(timezone.utc).replace(microsecond=0)
        start_date_str = start_date.isoformat()
        data1 = {"type1": type1, "start_date": start_date_str}
        data, count = supabase.table('t_w01_python_run').insert(data1).execute()
        get_id = data[1][0]['id']
        
        while True:
            data2 = supabase.table('t_c01_rss_articles').select('id, image_link').filter('image_link', 'neq', '').filter('cf_image_link', 'eq', '').is_('is_grouped_l2', 'True').limit(1).order('id', desc=False).offset(offset).execute()
            if len(data2.data) == 0:
                break
            id = data2.data[0]['id']
            image_link = data2.data[0]['image_link']
            image_url = "na"
            image_data = download_image(image_link)
            filename = "na"
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
            print(e)
            print("Error in save_image_to_cf")
            end_date = datetime.now(timezone.utc).replace(microsecond=0)
            end_date_str = end_date.isoformat()
            data1 = {"end_date": end_date_str, "error": str(e)}
            data, count = supabase.table('t_w01_python_run').update(data1).eq('id', get_id).execute()
        except:
            pass
        
if __name__ == '__main__':
    args = [0, 10, 20, 30, 40,50, 60, 70, 80, 90, 100]
    processes = []
    for i in args:
        print(i)
        p = Process(target=save_image_to_cf, args=(i,))
        processes.append(p)
        p.start()
    for p in processes:
        p.join()