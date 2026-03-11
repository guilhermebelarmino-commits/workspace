select
  -- *
    CCARD_VP_PRODUCT_ID
    ,CCARD_VP_CREATE_DATETIME
    ,CCARD_VP_RATING
    ,CCARD_VP_TEMP_LIMIT_PERC -- tasa overlimit
    ,CCARD_VP_SET_IP.FIN_INTEREST[0].INTEREST AS FIN_INTEREST_INTEREST -- tasa repricing 
  from `WHOWNER.BT_CCARD_MONZA_VALUE_PROPOSAL`
  where 1=1
    and sit_site_id = 'MLB'
    and CCARD_VP_PRODUCT_NAME = 'tc-visa-gold-mlb'
    and CCARD_VP_RATING IN ('R','M','Y','X')
    qualify row_number() over (partition by CCARD_VP_RATING ORDER BY CCARD_VP_CREATE_DATETIME DESC) = 1

    
    order by 2 desc
