-- SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_00f96a68-089a-4491-aba3-10a34ae26139-1`;SELECT POL.*, RK.eliminated_by_rk FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_00f96a68-089a-4491-aba3-10a34ae26139-1` AS POL INNER JOIN `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_00f96a68-089a-4491-aba3-10a34ae26139-1` AS RK ON POL.CUS_CUST_ID = RK.CUS_CUST_ID;SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.EOC_CAMPAIGN_EXECUTION_DETAIL` WHERE EXECUTION_ID = '00f96a68-089a-4491-aba3-10a34ae26139';
DECLARE DT_REF DATE;
SET DT_REF = '2025-12-16'; -- D-1


CREATE OR REPLACE TEMP TABLE SIMULACION AS
  SELECT
    POL.*except(WANDA__CURRENT_LIMIT_CCARD, WANDA__REAL_USE_LEVEL_TC_VAL, WANDA__TEORIC_RCI_VAL, general_limit, INTERNAL_RATING_BEHAVIOR_TC),
    RK.WANDA__CCARD_PROP_STATUS,
    RK.WANDA__FLAG_CCARD_TRANSITORY_BLOCK,
    RK.WANDA__FLAG_CUENTA,
    RK.WANDA__CCARD_BLOCK_EVER_FLAG,
    RK.WANDA__MAX_OVERDUE_DAYS_CREDITS_EVER_QTY,
    RK.WANDA__MAX_OVERDUE_DAYS_CCARD_EVER_QTY,
    RK.WANDA__LAST_TC_UPSELL_DT,
    RK.WANDA__LAST_TC_DOWNSELL_DT,
    RK.LK_VU_PROSPECT_UNIVERSE__CATEGORY_LIFECYCLE_TAG,
    RK.LK_VU_PROSPECT_UNIVERSE__EMPLOYEE_FLAG,
    RK.eliminated_by_rk,

    POL.INTERNAL_RATING_BEHAVIOR_TC as bhv_internal_rating,

    CAST(RK.WANDA__CURRENT_LIMIT_CCARD AS FLOAT64) as limit_amount_tc,
    CAST(POL.WANDA__REAL_USE_LEVEL_TC_VAL AS FLOAT64) as real_use_level_val_tc,
    CAST(POL.WANDA__TEORIC_RCI_VAL AS FLOAT64) as teoric_rci_val,
   
    /*se todos os killer = true, mantem no universo*/
    rk_2799 as k_status_dif_accepted,
    rk_82261 as r_active_or_block,
    rk_8639 as k_limit_menor_500,
    rk_8204 as r_mora_ever,
    rk_9719 as k_power_user,
    -- rk_5733 as k_portab_sueldo,
    rk_3753 as k_no_empleado,
    rk_72228 as k_max_limite_actual,
    rk_10058 as k_sin_ingresos,
    rk_2919 as k_90d_upsell,
    rk_2918 as k_90d_downsell,
  FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_00f96a68-089a-4491-aba3-10a34ae26139-1` RK
  LEFT JOIN `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_00f96a68-089a-4491-aba3-10a34ae26139-1` POL
  USING(cus_cust_id)
;

CREATE OR REPLACE TEMP TABLE SCR AS

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
      and DATE_TRUNC(PERIOD_DT, MONTH) >= DATE_SUB(DATE_TRUNC(DT_REF, MONTH), INTERVAL 3 MONTH)
      and SIT_SITE_ID = 'MLB'
      and CUS_CUST_ID in (select cus_cust_id from SIMULACION where eliminated_by_rk = false)
      -- and CUS_CUST_ID = 62790373
    )
  )
  where rn = 1
  order by 2 desc
;

CREATE OR REPLACE TEMP TABLE RENTA_SCR AS
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
;

CREATE OR REPLACE TEMP TABLE CDP AS 

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
  and cus_cust_id in (select cus_cust_id from SIMULACION where eliminated_by_rk = false)
group by all
order by 1 asc,2
;

CREATE OR REPLACE TABLE `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_202512_GUBELARMINO` AS

SELECT 
  *except(general_limit),
  ROUND(safe_divide(general_limit,limit_amount_tc),1) as multiplicador,
  IF(ROUND(general_limit, -2) < 500, 500, ROUND(general_limit, -2)) as general_limit,
FROM (
  SELECT
    *,
    CASE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) <= '4' THEN 0.4*limit_amount_tc
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND SUBSTR(CAST(cus_cust_id AS STRING), 2, 1) >  '4' THEN 0.6*limit_amount_tc
      ELSE 0
    end as general_limit,

    case
      when bucket_vencimiento in (12, 15, 18, 27, 30) OR bucket_vencimiento IS NULL THEN 'a. out'
      when bucket_vencimiento in (2, 5, 9) THEN 'b. in'
    END AS FLAG_BUCKET,
    CASE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN 'a. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN 'b. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN 'a. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN 'b. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN 'a. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN 'b. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 1) >= '3' THEN 'a. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 1) <  '3' THEN 'b. GC'
    end as flag_controle,
  FROM (
    SELECT
      *
      ,CASE
        WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 6 MONTH) OR IFNULL(SCR_DATA_BASE_DT_M3, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 7 MONTH) OR IFNULL(current_presumed_income,0) < 100 THEN 'z. sem info'
        WHEN IFNULL(current_presumed_income,0) < 100 THEN 'z. renta < 100'
        WHEN fl_limite_insuficiente is true THEN 'z. limite insuficiente'
        WHEN FL_ENDEUDAMIENTO_EXTERNO_100 = 1 OR FL_DEUDA_VENC_OVER30_CLEAN = 1 OR (flag_deterioro_deuda_30d = 'a. deteriorou 3m' AND left(fx_porc_deterioro_divida_30d,1) not in ('a')) THEN 'c. elegible'
        ELSE 'z. no elegible'
      END AS waterfall_downsell_sin_preaviso,

      CASE 
        WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 6 MONTH) OR IFNULL(SCR_DATA_BASE_DT_M3, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 7 MONTH) THEN 'z. info scr desactualizada'
        WHEN IFNULL(current_presumed_income,0) < 100 THEN 'z. renta < 100'
        WHEN fl_limite_insuficiente is true THEN 'z. limite insuficiente'
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
            WHEN real_use_level_val_tc IS NULL THEN 'z. sem info'
            WHEN real_use_level_val_tc < 0.8 THEN 'a. < 80%'
            ELSE 'b. >= 80%'
          END AS fx_iu


          ,CASE
            WHEN IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 6 MONTH) then 'z. sem info atualizada scr'
            WHEN IFNULL(DEUDA_CLEAN_30D, 0) <= 300 THEN 'z. deuda clean <= 300'
            WHEN IFNULL(current_presumed_income, 0) <= 100 THEN 'z. renda <= 100'
            WHEN ENDEUDAMIENTO_EXTERNO < 0.5 THEN 'a. 0 a  50%'
            WHEN ENDEUDAMIENTO_EXTERNO < 0.75 THEN 'b. 50 a 75%'
            WHEN ENDEUDAMIENTO_EXTERNO < 1.0 THEN 'c. 75 a 100%'
            WHEN ENDEUDAMIENTO_EXTERNO < 1.5 THEN 'd. 100% a 150%'
            ELSE 'e.mayor 150%'
          END as fx_endeudamiento_externo

          ,CASE
            WHEN DEUDA_CLEAN_30D < 300 OR IFNULL(SCR_DATA_BASE_DT, '1900-01-01') < DATE_SUB(DT_REF, INTERVAL 6 MONTH) THEN 'z. sem info scr'
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

          ,CASE WHEN IFNULL(bhv_internal_rating,'Z') IN ('F','H') THEN true ELSE false END AS fl_bhv_ruim

          ,CASE WHEN limit_amount_tc < 1300 THEN true ELSE false END as fl_limite_insuficiente
      FROM
      (
        SELECT
          *
          ,safe_divide(DEUDA_CLEAN_30D, current_presumed_income) AS ENDEUDAMIENTO_EXTERNO
          ,IF(IFNULL(DEUDA_VENCIDA_OVER30,0) > 100, 1, 0) AS FL_DEUDA_VENC_OVER30_CLEAN
          ,IF(safe_divide(DEUDA_CLEAN_30D, current_presumed_income) > 1 AND IFNULL(DEUDA_CLEAN_30D,0) > 300 AND IFNULL(current_presumed_income,0) > 100, 1, 0) AS FL_ENDEUDAMIENTO_EXTERNO_100
          ,safe_divide(DEUDA_CLEAN_30D, DEUDA_CLEAN_30D_M3) - 1 as porc_deterioro_divida_30d
          ,if(wanda__flag_ccard_transitory_block, 'blocked', 'active') as status_tc
        FROM SIMULACION
        LEFT JOIN RENTA_SCR       using(cus_cust_id)
        LEFT JOIN CDP             using(cus_cust_id)
      )
    )
  )
)
;

CREATE OR REPLACE TABLE `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO` AS

select 
  *
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_202512_GUBELARMINO`
where 1=1
and eliminated_by_rk = false 
and fl_bhv_ruim = true
and waterfall_downsell_sin_preaviso in ('c. elegible')
and FLAG_BUCKET in ('b. in')
and cus_cust_id not in (select cus_cust_id from `SBOX_CREDITS_SB.RBA_TC_MLB_202512_TESTPRESTAMISTAS_MABANUS`) -- 833
;


-- INSERT CEREBRO --

-- HIPOTESE 1
-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ENDEUDAMIENTO EXTERNO' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ENDEUDAMIENTO EXTERNO' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 1437c28f-0ba5-44a7-a605-dad5abf4b09b
-- control: f2a78e05-205f-4be3-8915-6480ae6bc51b

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '1437c28f-0ba5-44a7-a605-dad5abf4b09b' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 6,375 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  'f2a78e05-205f-4be3-8915-6480ae6bc51b' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'b. GC'
;
-- Esta declaración agregó 2,875 filas a EOC_TC_C_UPSELL_DOWNSELL.

-- HIPOTESE 2

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'DETERIORO DEUDA CLEAN' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'DETERIORO DEUDA CLEAN' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 64b0a900-18bb-45f4-94c5-f2e75adc7bba
-- control: d41e83f1-de2c-4404-ae99-bf3b2c43bdc6

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '64b0a900-18bb-45f4-94c5-f2e75adc7bba' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 9,428 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  'd41e83f1-de2c-4404-ae99-bf3b2c43bdc6' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'b. GC'
;
-- Esta declaración agregó 4,306 filas a EOC_TC_C_UPSELL_DOWNSELL.

-- HIPOTESE 3

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'DEUDA VENCIDA 30D' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'DEUDA VENCIDA 30D' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 836fa0ab-22c2-4a4e-8dfe-46357bcec56a
-- control: 176944e5-4be7-4760-934b-db6220bbe0fb

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '836fa0ab-22c2-4a4e-8dfe-46357bcec56a' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 5,047 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '176944e5-4be7-4760-934b-db6220bbe0fb' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'b. GC'
;

-- Esta declaración agregó 2,338 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- HIPOTESE 4

-- INSERT CAMPANA

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'MAS DE UNA HIPOTESIS' --10 Campaign_group_desc
);

-- CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'DOWNSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'INFO EXTERNA', --6 Policy Category
'OTROS', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'MAS DE UNA HIPOTESIS' --10 Campaign_group_desc
);

--CHECK
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` 
where 1=1
  and aud_ins_user = 'guilherme.belarmino@mercadopago.com.br'
  and sit_site_id = 'MLB'
  and campaign_type = 'DOWNSELL'
  and campaign_date = current_date()
;

-- gestion: 68615f04-6cb9-4876-97e8-adfe84762f91
-- control: 5f564d8c-6f63-4c46-94e2-f01cdb58ad4c

-- IMPACTO
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '68615f04-6cb9-4876-97e8-adfe84762f91' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'a. GI'
;
-- Esta declaración agregó 10,102 filas a EOC_TC_C_UPSELL_DOWNSELL.


-- CONTROL
INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  CAMPAIGN_CONTROL_GROUP,
  AUD_INS_USER
)
select
  cus_cust_id as USER_ID,
  CAST(general_limit AS NUMERIC) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' as SITE_ID,
  0 PRIORITY,
  0 as IS_UPSELL,
  '5f564d8c-6f63-4c46-94e2-f01cdb58ad4c' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202512_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'b. GC'

-- Esta declaración agregó 4,675 filas a EOC_TC_C_UPSELL_DOWNSELL.