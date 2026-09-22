with user_group_messages as (
		SELECT lgd.hk_group_id, count(DISTINCT lum.hk_user_id) AS cnt_users_in_group_with_messages	-- считаем количество уникальных пользователей, hk_id которых есть в таблице сообщений, написанных в группах
		FROM VT260912B723BF__DWH.l_user_message lum
		JOIN VT260912B723BF__DWH.l_groups_dialogs lgd ON lum.hk_message_id = lgd.hk_message_id	-- формируем таблицу написанных в группах сообщений и их авторов
		GROUP BY lgd.hk_group_id
)

select hk_group_id,
            cnt_users_in_group_with_messages
from user_group_messages
order by cnt_users_in_group_with_messages
limit 10

;