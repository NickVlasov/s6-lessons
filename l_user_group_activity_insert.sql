INSERT INTO VT260912B723BF__DWH.l_user_group_activity (hk_l_user_group_activity, hk_user_id, hk_group_id, load_dt,load_src)
SELECT distinct
hash(hu.hk_user_id, hg.hk_group_id),
hu.hk_user_id,
hg.hk_group_id,
now() as load_dt,
's3' as load_src
from VT260912B723BF__STAGING.group_log as sgl
left join VT260912B723BF__DWH.h_users as hu on sgl.user_id = hu.user_id
left join VT260912B723BF__DWH.h_groups as hg on sgl.group_id = hg.group_id
where hash(hu.hk_user_id, hg.hk_group_id) not in (select hk_l_user_group_activity from VT260912B723BF__DWH.l_user_group_activity);