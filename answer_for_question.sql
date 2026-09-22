WITH user_group_messages AS (
    SELECT 
        lgd.hk_group_id,
        COUNT(DISTINCT lum.hk_user_id) AS cnt_users_in_group_with_messages
    FROM VT260912B723BF__DWH.l_user_message AS lum
    JOIN VT260912B723BF__DWH.l_groups_dialogs AS lgd
        ON lum.hk_message_id = lgd.hk_message_id
    WHERE lgd.hk_group_id IN (
        SELECT hk_group_id
        FROM VT260912B723BF__DWH.h_groups
        ORDER BY registration_dt
        LIMIT 10
    )
    GROUP BY lgd.hk_group_id
),

user_group_log AS (
    SELECT 
        lug.hk_group_id,
        COUNT(DISTINCT lug.hk_user_id) AS cnt_added_users
    FROM VT260912B723BF__DWH.s_auth_history AS sah
    JOIN VT260912B723BF__DWH.l_user_group_activity AS lug
        ON sah.hk_l_user_group_activity = lug.hk_l_user_group_activity
    WHERE sah.event = 'add'
      AND lug.hk_group_id IN (
          SELECT hk_group_id
          FROM VT260912B723BF__DWH.h_groups
          ORDER BY registration_dt
          LIMIT 10
      )
    GROUP BY lug.hk_group_id
)

SELECT 
    COALESCE(ugl.hk_group_id, ugm.hk_group_id) AS hk_group_id,
    COALESCE(ugl.cnt_added_users, 0) AS cnt_added_users,
    COALESCE(ugm.cnt_users_in_group_with_messages, 0) AS cnt_users_in_group_with_messages,
    ROUND(
        CAST(COALESCE(ugm.cnt_users_in_group_with_messages, 0) AS FLOAT) /
        NULLIF(CAST(COALESCE(ugl.cnt_added_users, 0) AS FLOAT), 0),
        4
    ) AS group_conversion
FROM user_group_log AS ugl
FULL OUTER JOIN user_group_messages AS ugm
    ON ugl.hk_group_id = ugm.hk_group_id
ORDER BY group_conversion DESC;
