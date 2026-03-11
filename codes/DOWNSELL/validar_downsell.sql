select 
  if(abs(limite_pol - limite_ccard) < 1, 1, 0) valid,
  count(1)
from (
select 
  cus_cust_id, 
  CAST(ACTIONABLE_COLUMNS[0].VALUE AS FLOAT64) AS limite_pol,
  limite_ccard,
  date(ccard_limit_update_dttm) ccard_limit_update_dttm
from `meli-bi-data.SBOX_CREDITSSIGMA.EOC_CAMPAIGN_EXECUTION_DETAIL`
left join 
(
  select
      cus_cust_id
      ,ccard_limit_update_dttm
      ,ccard_limit_general as limite_ccard
    from `WHOWNER.BT_CCARD_LIMIT_HIST` lmt
    qualify row_number() over (partition by cus_cust_id order by ccard_limit_update_dttm desc) = 1
)
using(cus_cust_id)
where execution_id = 'efeaabfd-9ac1-4399-8268-15ee81641130' and CAMPAIGN_CONTROL_GROUP = false
and date(ccard_limit_update_dttm) >= '2025-03-13'
)
group by 1