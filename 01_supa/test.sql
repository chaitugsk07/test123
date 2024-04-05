select count(*) from (SELECT COUNT(b.*) as count, a.topic_name
FROM synopse_articles.t_v4_berttopics a
LEFT OUTER JOIN synopse_articles.t_v1_rss1_articles b ON b.t_temp_bert_topic = a.topic_name
GROUP BY a.topic_name
ORDER BY COUNT(b.*) DESC) where count > 0;