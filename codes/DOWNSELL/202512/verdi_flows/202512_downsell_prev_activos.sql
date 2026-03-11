declare table_name_dwtc_base_bau string; 
declare table_name_dwtc string;
declare table_name_dwtc_base string;
declare table_name_dwtc_impacto string;

set table_name_dwtc_base_bau = concat('meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BAU_ACTIVOS_BASE_', format_date('%Y%m%d', current_date()), '_GUBELARMINO');

set table_name_dwtc = concat('meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_ACTIVOS_HIST_', format_date('%Y%m%d', current_date()), '_GUBELARMINO');
set table_name_dwtc_base = concat('meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_ACTIVOS_BASE_', format_date('%Y%m%d', current_date()), '_GUBELARMINO');
set table_name_dwtc_impacto = concat('meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_PREVENTIVO_ACTIVOS_IMPACTABLES_', format_date('%Y%m%d', current_date()), '_GUBELARMINO');

execute immediate '''
create or replace table ''' || table_name_dwtc || '''
options (
  expiration_timestamp = timestamp_add(current_timestamp(), interval 24 hour)
)
as

  SELECT
    *
  FROM ''' || table_name_dwtc_base_bau || '''

''';

execute immediate '''
create or replace table ''' || table_name_dwtc_base || '''
as

WITH SCR AS (

  SELECT * FROM (
    SELECT
      *,
      LAG(DEUDA_CLEAN_30D, 3) OVER (PARTITION BY CUS_CUST_ID ORDER BY PERIOD_DT ASC) AS DEUDA_CLEAN_30D_M3,
      LAG(DEUDA_VENCIDA_OVER30, 3) OVER (PARTITION BY CUS_CUST_ID ORDER BY PERIOD_DT ASC) AS DEUDA_VENCIDA_OVER30_M3,
      LAG(SCR_DATA_BASE_DT, 3) OVER (PARTITION BY CUS_CUST_ID ORDER BY PERIOD_DT ASC) AS SCR_DATA_BASE_DT_M3
    FROM (
    select 
      CUS_CUST_ID,
      PERIOD_DT,
      SCR_DATA_BASE_DT,
      SCR_DUE_TC_30D_AMT AS DEUDA_CLEAN_TC_30D, --tarjeta
      SCR_DUE_MICRO_CREDIT_30D_AMT AS DEUDA_CLEAN_MICROCREDIT_30D, -- microcredito
      SCR_DUE_OVERDRAFT_30D_AMT AS DEUDA_CLEAN_OVERDRAFT_30D, -- cheque especial
      SCR_DUE_CC_PL_30D_AMT AS DEUDA_CLEAN_CC_30D, -- cp sem garantia

      -- PRODUTOS CLEAN = PRODUTOS SIN GARANTIA
      ( SCR_DUE_TC_30D_AMT + SCR_DUE_MICRO_CREDIT_30D_AMT+ SCR_DUE_OVERDRAFT_30D_AMT+ SCR_DUE_CC_PL_30D_AMT) as DEUDA_CLEAN_30D,

      SCR_DUE_TOTAL_30D_AMT,

      SCR_OVERDUE_TC_OVER30D_AMT AS DEUDA_VENCIDA_TC_OVER30, -- saldo vvencido tc
      SCR_OVERDUE_MICRO_CREDIT_OVER30D_AMT AS DEUDA_VENCIDA_MICROCREDIT_OVER30, -- microcredito
      SCR_OVERDUE_OVERDRAFT_OVER30D_AMT AS DEUDA_VENCIDA_OVERDRAFT_OVER30, -- cheque especial
      SCR_OVERDUE_CC_OVER30D_AMT AS DEUDA_VENCIDA_CC_OVER30, -- cp sem garantia

      (SCR_OVERDUE_TC_OVER30D_AMT+ SCR_OVERDUE_MICRO_CREDIT_OVER30D_AMT+ SCR_OVERDUE_OVERDRAFT_OVER30D_AMT+ SCR_OVERDUE_CC_OVER30D_AMT) as DEUDA_VENCIDA_OVER30,
      ROW_NUMBER() OVER (PARTITION BY CUS_CUST_ID ORDER BY PERIOD_DT DESC) RN,
    from `WHOWNER.BT_VU_PRESUMED_INCOME` 
    where 
      1=1
      and DATE_TRUNC(PERIOD_DT, MONTH) >= DATE_SUB(DATE_TRUNC(current_date(), MONTH), INTERVAL 3 MONTH)
      and SIT_SITE_ID = 'MLB'
      and CUS_CUST_ID in (select cus_cust_id from ''' || table_name_dwtc || ''')
      -- and CUS_CUST_ID = 62790373
    )
  )
  where rn = 1
  order by 2 desc
)

, RENTA_SCR AS (
  with renta as (
      SELECT
      cus_cust_id
      ,assumed_income_amt as current_presumed_income
      ,valid_from_dt as period_dt_renta
      ,NISE_TAG
    FROM `WHOWNER.BT_VU_ASSUMED_INCOME`
    WHERE 1=1
    and sit_site_id = 'MLB'
    and valid_from_dt < (select date_trunc(SCR_DATA_BASE_DT, month) from SCR where cus_cust_id = scr.cus_cust_id order by 1 desc limit 1)
    and valid_to_dt >= (select date_trunc(SCR_DATA_BASE_DT, month) from SCR where cus_cust_id = scr.cus_cust_id order by 1 desc limit 1)
    QUALIFY ROW_NUMBER() OVER (PARTITION BY cus_cust_id ORDER BY VALID_FROM_DT DESC) = 1
  )

  select
    *
  from SCR
  left join renta   using(cus_cust_id)
)

, CDP AS (

  select
    cus_cust_id,
    INSERT_DT as fecha_carga,
    CLOSE_DATE_DT as fecha_cierre,
    SUMMARY_PERIOD as periodo_resumen,
    DUE_BUCKET_VAL as bucket_vencimiento,
    CASE
        WHEN PAYMENT_STATUS_TAG = 'Pago Total Pago total' THEN 'A. Pago Total'
        WHEN PAYMENT_STATUS_TAG = 'Parcela Resumen Manual' OR PAYMENT_STATUS_TAG = 'Parcela Resumen ' THEN 'B. Parcelamento Manual'
        WHEN PAYMENT_STATUS_TAG = 'Parcela Automatico Automatico' THEN 'C. Parcelamento Automatico'
        WHEN PAYMENT_STATUS_TAG = 'Revolving Mayor al mínimo' THEN 'D. Revolving'
        WHEN PAYMENT_STATUS_TAG = 'Revolving Pago Mínimo' THEN 'E.Pago Minimo'
        WHEN PAYMENT_STATUS_TAG = 'Default Default' THEN 'f. Default'
        ELSE 'G. Ver'
    end as TIPO_PAGO,
    CASE
        WHEN PREV_PAYMENT_CLASS_TAG = 'Pago Total Pago total' THEN 'A. Pago Total'
        WHEN PREV_PAYMENT_CLASS_TAG = 'Parcela Resumen Manual' OR PREV_PAYMENT_CLASS_TAG = 'Parcela Resumen ' THEN 'B. Parcelamento Manual'
        WHEN PREV_PAYMENT_CLASS_TAG = 'Parcela Automatico Automatico' THEN 'C. Parcelamento Automatico'
        WHEN PREV_PAYMENT_CLASS_TAG = 'Revolving Mayor al mínimo' THEN 'D. Revolving'
        WHEN PREV_PAYMENT_CLASS_TAG = 'Revolving Pago Mínimo' THEN 'E.Pago Minimo'
        WHEN PREV_PAYMENT_CLASS_TAG = 'Default Default' THEN 'f. Default'
        ELSE 'G. Ver'
    end as TIPO_PAGO_ANTERIOR,
  sum(SUMMARY_AMT) as monto_resumen,
  sum(TOTAL_PAYMENT_ACUM_VAL) as pagos,
  safe_divide(sum(TOTAL_PAYMENT_ACUM_VAL), sum(SUMMARY_AMT)) as porc_pago,
  from `meli-bi-data.WHOWNER.BT_VU_VIS_TC_PAYMENT_CURVES_SUMMARY_2` A
  where 1=1
  and SUMMARY_PERIOD IN ('202511')
  and sit_site_id = 'MLB'
  and DAYS_VAL in (30) --Filtro para dias desarrollo
  and cus_cust_id in (select cus_cust_id from ''' || table_name_dwtc || ''')
group by all
order by 1 asc,2
)

SELECT 
  *except(general_limit),
  ROUND(safe_divide(general_limit,LIMIT_TC_AMT),1) as multiplicador,
  IF(ROUND(general_limit, -2) < 500, 500, ROUND(general_limit, -2)) as general_limit,
FROM (
  SELECT
    *,
    CASE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*LIMIT_TC_AMT
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*LIMIT_TC_AMT
      ELSE 0
    end as general_limit,

    case
      when bucket_vencimiento in (12, 15, 18, 27, 30) OR bucket_vencimiento IS NULL THEN 'a. out'
      when bucket_vencimiento in (2, 5, 9) THEN 'b. in'
    END AS FLAG_BUCKET,
    CASE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN false 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN true
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN false
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN true
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN FALSE
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN TRUE
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN FALSE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN TRUE
    end as CAMPAIGN_CONTROL_GROUP,
  FROM (
    SELECT
      *
      ,CASE
        WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 6 MONTH) OR IFNULL(SCR_DATA_BASE_DT_M3, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 7 MONTH) OR IFNULL(current_presumed_income,0) < 100 THEN 'z. sem info'
        WHEN IFNULL(current_presumed_income,0) < 100 THEN 'z. renta < 100'
        WHEN fl_limite_insuficiente is true THEN 'z. limite insuficiente'
        WHEN PERSON_CREDIT_TRANSITORY_BLOCK_CCARD_FLAG IS TRUE then 'z. overdue'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 1 OR FL_DEUDA_VENC_OVER30_CLEAN = 1 OR (flag_deterioro_deuda_30d = 'a. deteriorou 3m' AND left(fx_porc_deterioro_divida_30d,1) not in ('a')) THEN 'c. elegible'
        ELSE 'z. no elegible'
      END AS waterfall_downsell_sin_preaviso,

      CASE 
        WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 6 MONTH) OR IFNULL(SCR_DATA_BASE_DT_M3, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 7 MONTH) THEN 'z. info scr desactualizada'
        WHEN IFNULL(current_presumed_income,0) < 100 THEN 'z. renta < 100'
        WHEN fl_limite_insuficiente is true THEN 'z. limite insuficiente'
        WHEN PERSON_CREDIT_TRANSITORY_BLOCK_CCARD_FLAG IS TRUE then 'z. overdue'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 1 AND FL_DEUDA_VENC_OVER30_CLEAN = 0
              AND if(flag_deterioro_deuda_30d = 'a. deteriorou 3m' and left(fx_porc_deterioro_divida_30d,1) not in ('a'),1,0) = 0  THEN 'a. Endeudamiento externo > 100%'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 0 AND FL_DEUDA_VENC_OVER30_CLEAN = 0
              AND if(flag_deterioro_deuda_30d = 'a. deteriorou 3m' and left(fx_porc_deterioro_divida_30d,1) not in ('a'),1,0) = 1  THEN 'b. Deterioro deuda clean 30d > 25%'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 0 AND FL_DEUDA_VENC_OVER30_CLEAN = 1
              AND if(flag_deterioro_deuda_30d = 'a. deteriorou 3m' and left(fx_porc_deterioro_divida_30d,1) not in ('a'),1,0) = 0  THEN 'c. Deuda vencida 30d > 100'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 1 OR FL_DEUDA_VENC_OVER30_CLEAN = 1
              OR if(flag_deterioro_deuda_30d = 'a. deteriorou 3m' and left(fx_porc_deterioro_divida_30d,1) not in ('a'),1,0) = 1   THEN 'd. Mas que un testeo'
        ELSE 'z. nao elegivel'
      END as waterfall_downsell_sin_preaviso_detalle
    FROM
    (
      SELECT
        *
        ,CASE
            WHEN ccard_usage_pct IS NULL THEN 'z. sem info'
            WHEN ccard_usage_pct < 0.8 THEN 'a. < 80%'
            ELSE 'b. >= 80%'
          END AS fx_iu


          ,CASE
            WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 6 MONTH) then 'z. sem info atualizada scr'
            WHEN IFNULL(DEUDA_CLEAN_30D, 0) <= 300 THEN 'z. deuda clean <= 300'
            WHEN IFNULL(current_presumed_income, 0) <= 100 THEN 'z. renda <= 100'
            WHEN ENDEUDAMIENTO_EXTERNO < 0.5 THEN 'a. 0 a  50%'
            WHEN ENDEUDAMIENTO_EXTERNO < 0.75 THEN 'b. 50 a 75%'
            WHEN ENDEUDAMIENTO_EXTERNO < 1.0 THEN 'c. 75 a 100%'
            WHEN ENDEUDAMIENTO_EXTERNO < 1.5 THEN 'd. 100% a 150%'
            ELSE 'e.mayor 150%'
          END as fx_endeudamiento_externo

          ,CASE
            WHEN DEUDA_CLEAN_30D < 300 OR IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(current_date(), INTERVAL 6 MONTH) THEN 'z. sem info scr'
            WHEN DEUDA_CLEAN_30D > DEUDA_CLEAN_30D_M3 THEN 'a. deteriorou 3m'
            WHEN DEUDA_CLEAN_30D < DEUDA_CLEAN_30D_M3 THEN 'b. melhorou 3m'
            ELSE 'c. manteve 3m'
          END as flag_deterioro_deuda_30d


          ,case
              when porc_deterioro_divida_30d < 0.25 then 'a. < 25%'
              when porc_deterioro_divida_30d < 0.50 then 'b. < 50%'
              when porc_deterioro_divida_30d < 0.75 then 'c. < 75%'
              when porc_deterioro_divida_30d < 1 then 'd. < 100%'
              else 'e. >= 100%'
          end as fx_porc_deterioro_divida_30d

          ,CASE WHEN IFNULL(INTERNAL_RATING_BEHAVIOR_TC_TAG,'Z') IN ('F','H') THEN true ELSE false END AS fl_bhv_ruim

          ,CASE WHEN LIMIT_TC_AMT < 1300 THEN true ELSE false END as fl_limite_insuficiente
      FROM
      (
        SELECT
          *
          ,safe_divide(DEUDA_CLEAN_30D, current_presumed_income) AS ENDEUDAMIENTO_EXTERNO
          ,IF(IFNULL(DEUDA_VENCIDA_OVER30,0) > 100, 1, 0) AS FL_DEUDA_VENC_OVER30_CLEAN
          ,IF(safe_divide(DEUDA_CLEAN_30D, current_presumed_income) > 1 AND IFNULL(DEUDA_CLEAN_30D,0) > 300 AND IFNULL(current_presumed_income,0) > 100, 1, 0) AS FL_ENDEUDAMIENTO_EXTERNO_100
          ,safe_divide(DEUDA_CLEAN_30D, DEUDA_CLEAN_30D_M3) - 1 as porc_deterioro_divida_30d
          ,if(R_ACTIVE_OR_BLOCK_TRANSITORIO_ACCOUNT, 'blocked', 'active') as status_tc
        FROM ''' || table_name_dwtc || '''
        LEFT JOIN RENTA_SCR       using(cus_cust_id)
        LEFT JOIN CDP             using(cus_cust_id)
      )
    )
  )
)
;

'''
;

execute immediate '''
create or replace table ''' || table_name_dwtc_impacto || '''
as

select 
  *
from ''' || table_name_dwtc_base || '''
where 1=1
and fl_bhv_ruim = true
and waterfall_downsell_sin_preaviso in ('c. elegible')
-- and FLAG_BUCKET in ('b. in')
;
'''
;

execute immediate '''
select
  "PREVENTIVO" AS TIPO_DOWNSELL,
  CAMPAIGN_CONTROL_GROUP,
  -- MULTIPLICADOR_FINAL,
  COUNT(1) AS CANT,
  ROUND(SUM(GENERAL_LIMIT-LIMIT_TC_AMT),2) AS EXPOSICION_REDUZIDA,
  ROUND(AVG(GENERAL_LIMIT),2) AS LIMITE_PROMEDIO_POST,
  ROUND(AVG(GENERAL_LIMIT/LIMIT_TC_AMT),1) AS MULTIPLICADOR_PROMEDIO,
  AVG(CCARD_USAGE_PCT) AS IU_PROMEDIO,
  AVG(REAL_USE_LEVEL_TC_VAL)

from ''' || table_name_dwtc_impacto || '''
GROUP BY ALL
ORDER BY 1
;
'''
;
