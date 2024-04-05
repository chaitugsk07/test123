WITH user_search AS (
  SELECT
    search1
  FROM
    synopse_realtime.t_temp_user_search
  WHERE
    id = 14
)
SELECT
  a.article_group_id,
  1 - (a.vector1 <=> user_search.search1) AS cosine_distance,
  c.days_since_updated,
  c.weeks_since_updated
FROM
  synopse_articles.t_v5_article_groups_vectors a
JOIN
  synopse_articles.v_articles_group_details_main c
ON
  a.article_group_id = c.article_group_id
JOIN
  user_search
ON
  TRUE
ORDER BY 
  CASE WHEN c.days_since_updated <= 7 AND (1 - (a.vector1 <=> user_search.search1)) > 0.8 THEN c.days_since_updated + 1 - (a.vector1 <=> user_search.search1)  END,
  CASE WHEN c.weeks_since_updated <= 5 AND (1 - (a.vector1 <=> user_search.search1)) > 0.8 THEN c.weeks_since_updated + 1 - (a.vector1 <=> user_search.search1) + 7 END,
  CASE WHEN c.days_since_updated <= 7 AND (1 - (a.vector1 <=> user_search.search1)) > 0.6 THEN c.days_since_updated + 1 - (a.vector1 <=> user_search.search1) + 12 END,
  CASE WHEN c.weeks_since_updated <= 5 AND (1 - (a.vector1 <=> user_search.search1)) > 0.6 THEN c.weeks_since_updated + 1 - (a.vector1 <=> user_search.search1)  + 19 END,
  CASE WHEN c.days_since_updated <= 7 AND (1 - (a.vector1 <=> user_search.search1)) > 0.5 THEN c.days_since_updated + 1 - (a.vector1 <=> user_search.search1) + 23 END,
  CASE WHEN c.weeks_since_updated <= 5 AND (1 - (a.vector1 <=> user_search.search1)) > 0.5 THEN c.weeks_since_updated + 1 - (a.vector1 <=> user_search.search1) + 30 END,
  CASE WHEN c.weeks_since_updated > 5 OR (1 - (a.vector1 <=> user_search.search1)) <= 0.5 THEN c.weeks_since_updated + 1 - (a.vector1 <=> user_search.search1) + 50 END;