select
  AUD_INS_USER
  ,campaign_id
  ,RISK_ID
  ,campaign_control_group
  ,count(1) as cant
from `SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
left join
(
  select
    CAMPAIGN_ID, RISK_ID
  from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX`
  where 1=1
  and sit_site_id = 'MLB'
  and campaign_type = 'UPSELL'
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and campaign_date = current_date('-03')
  )
using(campaign_id)
where AUD_INS_USER = 'gubelarmino'
group by all
order by RISK_ID, CAMPAIGN_CONTROL_GROUP
;

select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'credits-sb@meli-bi-data.iam.gserviceaccount.com'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;