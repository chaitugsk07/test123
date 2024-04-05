
# grouping L2
def grouping_l2():
  print("grouping_l2")
  l1_q = f"""SELECT
      a.article_id,
      a.initial_group,
      a.language
  FROM
      synopse_articles.t_v3_article_groups_l1 a
  WHERE
      a.is_grouped = 1 AND
      a.article_count > 1
  ORDER BY
      a.id DESC
  LIMIT 1;"""
  while True:
    l1_q_output = create_conn_source2(l1_q)
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
      q12_output = create_conn_source2(q12)
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
                          article_id,
                          is_grouped
                      FROM
                          synopse_articles.t_v2_articles_vectors
                      WHERE
                          id article_id   """ + str(tuple(unique_elements)) + """;"""
      if(len(unique_elements) == 1):
        q2123 = f"""SELECT
                          article_id,
                          is_grouped
                      FROM
                          synopse_articles.t_v2_articles_vectors
                      WHERE
                          article_id =   """ + str(unique_elements[0]) + """;"""
      q2123_output2 = create_conn_source2(q2123)
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
          q12_output2 = create_conn_source2(q12)
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
      update_query = "UPDATE synopse_articles.t_v2_articles_vectors SET is_grouped = 2 WHERE id IN " + str(t_ids) + ";"
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
      insert_conn_source2(insert_object, v3)
      t_ids = tuple(articles_ids)
      update_query = "UPDATE synopse_articles.t_v2_articles_vectors SET is_grouped = 2 WHERE article_id IN " + str(t_ids) + ";"
      update_conn_source2(update_query)