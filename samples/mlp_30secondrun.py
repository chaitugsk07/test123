import os
import requests
import re
from datetime import datetime, timezone
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
import pyperclip
import multiprocessing
import time
import psutil
#git add . && git commit -m "initial commit" && git push origin main

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

def update_article_details1(offset):
    graphql_query = '''
    query MyQuery($limit: Int!, $offset: Int!) {
    synopse_articles_t_v1_rss1_articles(limit: $limit, offset: $offset, where: {is_in_detail: {_eq: 0}}, order_by: {post_published: desc}) {
        post_link
        is_default_image
        id
        }
    }
    '''
    offset1 = offset
    mutation_query = """
    mutation MyMutation($objects: [synopse_articles_t_v1_rss1_articles_detail_insert_input!] = {}, $updates: [synopse_articles_t_v1_rss1_articles_updates!] = {where: {}}) {
        insert_synopse_articles_t_v1_rss1_articles_detail(objects: $objects, on_conflict: {constraint: t_v1_rss1_articles_detail_article_id_key}) {
            affected_rows
        }
        update_synopse_articles_t_v1_rss1_articles_many(updates: $updates) {
            affected_rows
        }
        }

    """    
    options = webdriver.EdgeOptions()
    options.use_chromium = True
    options.add_experimental_option("prefs", {
        "profile.default_content_setting_values.notifications": 2,  # Disable notifications
        "profile.default_content_setting_values.media_stream_mic": 2,  # Disable microphone
        "profile.default_content_setting_values.media_stream_camera": 2,  # Disable camera
        "profile.default_content_setting_values.geolocation": 2,  # Disable location services
        "profile.default_content_setting_values.automatic_downloads": 2  # Disable automatic downloads
    })
    options.add_argument("--no-first-run")  # Skip the welcome page
    options.add_argument("--disable-infobars")  # Disable the info bars
    options.add_argument("--disable-extensions")  # Disable extensions
    options.add_argument("--disable-popup-blocking")  # Disable popups
    options.add_argument("--disable-features=EdgeTips") 
    options.page_load_strategy = 'eager'
    options.add_argument('--enable-immersive-reader')
    driver = webdriver.Edge(options=options)
    variables = {
    "limit": 1,
    "offset": offset1
    }
    response_data = query_hasura_graphql(endpoint, admin_key, graphql_query, variables)
    #print(variables, response_data)
    #print(response_data)
    post_links_array = []
    ids=[]
    is_default_image_array = []
    if response_data:
        post_links_array = [item["post_link"] for item in response_data["data"]["synopse_articles_t_v1_rss1_articles"]]
        is_default_image_array = [item["is_default_image"] for item in response_data["data"]["synopse_articles_t_v1_rss1_articles"]]
        ids=[item["id"] for item in response_data["data"]["synopse_articles_t_v1_rss1_articles"]]
    articles_detail = []
    articles_update = []
    for a in range(len(post_links_array)):
        main_link = post_links_array[a]
        print(main_link)
        driver.get(main_link)
        time.sleep(2)
        get_url = driver.current_url
        read_link= "read://"+get_url
        driver.get(read_link)
        time.sleep(2)
        ActionChains(driver).key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).perform()
        ActionChains(driver).key_down(Keys.CONTROL).send_keys('c').key_up(Keys.CONTROL).perform()
        text = pyperclip.paste()
        text2 = text
        text3 = text2.split('\n')
        text3 = [s.replace('\r', '') for s in text3]
        special_chars = set("!@#$%^&*()_+[]{}|;:'\",<>?")
        text4 = [s for s in text3 if len(s) > 0 and (s[0] not in special_chars or s[-1] not in special_chars)]
        my_list = text4
        if my_list[0] == "Hmmm… can't reach this page":
            articles_update.append({
                "where": {"post_link" : { "_eq": main_link }},
                "_set": {"is_in_detail": 2}
            })
        my_set = set()
        desription = []
        for item in my_list:
            if item not in my_set:
                desription.append(item)
                my_set.add(item)
        #print(desription)
        images_final = []
        articles_detail.append({
            "article_id": ids[a],
            "title": desription[0],
            "description": desription[1:],
            "image_link": images_final,
        }
        )
        if (is_default_image_array[a] == 0 and len(images_final) > 0):
            articles_update.append({
                "where": {"post_link" : { "_eq": main_link }},
                "_set": {"is_in_detail": 1 , "image_link": images_final[0], "is_default_image": 1}
            })
        else:
            articles_update.append({
                "where": {"post_link" : { "_eq": main_link }},
                "_set": {"is_in_detail": 1}
            })
        
        #print(main_link, desription[0], desription[1:], images_final)
    #print(articles_update)
    mutation_variables = {
    "objects": articles_detail,
    "updates": articles_update,
    }
    out1 = mutation_hasura_graphql(endpoint=endpoint, admin_key=admin_key, mutation_query=mutation_query, mutation_variables=mutation_variables)
    driver.quit() 

def kill_if_too_long(function, args, max_execution_time):
    # Create a process that runs the function with the given arguments
    process = multiprocessing.Process(target=function, args=args)
    process.start()

    # Wait for the specified maximum execution time
    process.join(timeout=max_execution_time)

    # If the process is still running after the maximum execution time, terminate it
    if process.is_alive():
        print("Function is running too long, terminating...")
        process.terminate()
        process.join()


def kill_process_tree(process_name):
    for proc in psutil.process_iter(['pid', 'name']):
        # Check if the process name starts with the given name string.
        if proc.info['name'].startswith(process_name):
            # Kill the process tree
            parent = psutil.Process(proc.info['pid'])
            for child in parent.children(recursive=True):
                try:
                    child.kill()
                except psutil.NoSuchProcess:
                    pass
            try:
                parent.kill()
            except psutil.NoSuchProcess:
                pass

if __name__ == "__main__":
    while True:
        try:
            kill_if_too_long(update_article_details1, (0,), 30)
            kill_process_tree('msedge')
        except Exception as e:
            print(f"An error occurred: {e}")