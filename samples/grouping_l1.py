
import os
import requests
import feedparser
import re
import numpy
from datetime import datetime, timezone
from multiprocessing import Process, set_start_method
import multiprocessing

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


if __name__ == "__main__":
    # Define the list of arguments
    n1 =  2
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
