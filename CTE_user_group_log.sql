WITH user_group_log AS (
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
    hk_group_id,
    cnt_added_users
FROM user_group_log
ORDER BY cnt_added_users
LIMIT 10;
