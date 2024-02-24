select count(a.*), a.group_ai_tags_l1 , b.topic_representation
from synopse_articles.t_v4_article_groups_l2_detail a , synopse_articles.t_v4_berttopics b
where a.group_ai_tags_l1 = b.topic_name
and b.tag_root = 'na'
group by a.group_ai_tags_l1, b.topic_representation
order by count(a.*) desc;

select count(a.*), a.group_ai_tags_l1 , b.tag_root
from synopse_articles.t_v4_article_groups_l2_detail a , synopse_articles.t_v4_berttopics b
where a.group_ai_tags_l1 = b.topic_name
group by a.group_ai_tags_l1, b.tag_root
order by count(a.*) desc;

select  a.group_ai_tags_l1 , b.tag_root, c.id
from synopse_articles.t_v4_article_groups_l2_detail a , synopse_articles.t_v4_berttopics b, synopse_articles.t_v4_tags_hierarchy c
where a.group_ai_tags_l1 = b.topic_name
and  b.tag_root = c.tag
and b.tag_root = 'Politics & Global Affairs'
and b.tag_tree= 'na'
group by a.group_ai_tags_l1 , b.tag_root, c.id;

SELECT
count(a.*),
    b.outlet
FROM synopse_articles.t_v1_rss1_articles a, synopse_articles.t_v1_rss1_feed_links b
WHERE a.rss1_feed_id = b.id AND a.is_in_detail = 0
Group BY b.outlet
order by count(a.*) desc;

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
and a.total_count >= 300;