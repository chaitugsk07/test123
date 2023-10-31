SELECT a.account, 
COALESCE(COUNT(b.*), 0) AS view_count_6m_1y, 
COALESCE(COUNT(b1.*), 0) AS view_count_1m_6m, 
COALESCE(COUNT(b2.*), 0) AS view_count_1m,
COALESCE(COUNT(b3.*), 0) AS view_count_1y

COALESCE(COUNT(c.*), 0) AS view_like_6m_1y, 
COALESCE(COUNT(c1.*), 0) AS view_like_1m_6m, 
COALESCE(COUNT(c2.*), 0) AS view_like_1m,
COALESCE(COUNT(c3.*), 0) AS view_like_1y


FROM auth.auth1_users a
LEFT JOIN realtime.t_user_article_views b ON b.account = a.account and b.updated_at >= (now() - '365 days' :: interval) and b.updated_at < (now() - '180 days' :: interval)
LEFT JOIN realtime.t_user_article_views b1 ON b1.account = a.account and b1.updated_at >= (now() - '180 days' :: interval) and b1.updated_at < (now() - '30 days' :: interval)
LEFT JOIN realtime.t_user_article_views b2 ON b2.account = a.account and b2.updated_at >= (now() - '30 days' :: interval) and b2.updated_at < (now())
LEFT JOIN realtime.t_user_article_views b3 ON b3.account = a.account and b3.updated_at >= (now() - '365 days' :: interval)

LEFT JOIN realtime.t_user_article_likes c ON c.account = a.account and c.created_at >= (now() - '365 days' :: interval) and c.created_at < (now() - '180 days' :: interval)
LEFT JOIN realtime.t_user_article_likes c1 ON c1.account = a.account and c1.created_at >= (now() - '180 days' :: interval) and c1.created_at < (now() - '30 days' :: interval)
LEFT JOIN realtime.t_user_article_likes c2 ON c2.account = a.account and c2.created_at >= (now() - '30 days' :: interval) and c2.created_at < (now())
LEFT JOIN realtime.t_user_article_likes c3 ON c3.account = a.account and c3.created_at >= (now() - '365 days' :: interval)

GROUP BY a.account;