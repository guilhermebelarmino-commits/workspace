-- SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_2c0f66fe-e35d-45ce-bdc8-84f32830e86d-1`;SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_2c0f66fe-e35d-45ce-bdc8-84f32830e86d-1`;SELECT * FROM `meli-bi-data.SBOX_CREDITSSIGMA.EOC_CAMPAIGN_EXECUTION_DETAIL` WHERE EXECUTION_ID = '2c0f66fe-e35d-45ce-bdc8-84f32830e86d';
DECLARE DT_REF DATE;
SET DT_REF = '2025-10-29';


CREATE OR REPLACE TEMP TABLE SIMULACION AS
  SELECT
    POL.*except(WANDA__CURRENT_LIMIT_CCARD, WANDA__REAL_USE_LEVEL_TC_VAL, WANDA__TEORIC_RCI_VAL, general_limit),
    CAST(RK.WANDA__CURRENT_LIMIT_CCARD AS FLOAT64) as limit_amount_tc,
    CAST(RK.WANDA__REAL_USE_LEVEL_TC_VAL AS FLOAT64) as real_use_level_val_tc,
    CAST(RK.WANDA__TEORIC_RCI_VAL AS FLOAT64) as teoric_rci_val,
   
    /*se todos os killer = true, mantem no universo*/
    rk_2799 as k_status_dif_accepted,
    rk_82261 as r_active_or_block,
    rk_8639 as k_limit_menor_500,
    rk_8204 as r_mora_ever,
    rk_9719 as k_power_user,
    rk_5733 as k_portab_sueldo,
    rk_3753 as k_no_empleado,
    rk_72228 as k_max_limite_actual,
    rk_10058 as k_sin_ingresos,
    rk_2919 as k_90d_upsell,
    rk_2918 as k_90d_downsell,
  FROM `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_2c0f66fe-e35d-45ce-bdc8-84f32830e86d-1` RK
  LEFT JOIN `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_2c0f66fe-e35d-45ce-bdc8-84f32830e86d-1` POL
  USING(cus_cust_id)
;


CREATE OR REPLACE TEMP TABLE MODEL_BUREAU AS
  SELECT
    DISTINCT CUS_CUST_ID,
    INTERNAL_RATING_TAG AS crd_internal_rating
  FROM `meli-bi-data.WHOWNER.BT_VU_MODEL_RATING` MRT
  WHERE MRT.SIT_SITE_ID = 'MLB'
  AND MRT.CRD_MODEL = 'CONSUMERS_BEHAVIOR_BUREAU'
  AND MRT.VALID_TO_DT >= DT_REF
  AND MRT.VALID_FROM_DT < DT_REF
;


CREATE OR REPLACE TEMP TABLE MODEL_BHV AS
  SELECT
    DISTINCT CUS_CUST_ID,
    INTERNAL_RATING_TAG AS bhv_internal_rating
  FROM `meli-bi-data.WHOWNER.BT_VU_MODEL_RATING` MRT
  WHERE MRT.SIT_SITE_ID = 'MLB'
  AND MRT.CRD_MODEL = 'CONSUMERS_BEHAVIOR_CREDIT_CARD'
  AND MRT.VALID_TO_DT >= DT_REF
  AND MRT.VALID_FROM_DT < DT_REF
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


CREATE OR REPLACE TABLE `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_202510_GUBELARMINO` AS

SELECT 
  *except(general_limit),
  ROUND(safe_divide(general_limit,limit_amount_tc),1) as multiplicador,
  -- ROUND(general_limit, -2) as general_limit,
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
    CASE 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '65' THEN 'a. out'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '85' THEN 'b. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('a') AND RIGHT(CAST(cus_cust_id AS STRING), 2) >  '85' THEN 'c. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '65' THEN 'a. out'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '85' THEN 'b. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('b') AND RIGHT(CAST(cus_cust_id AS STRING), 2) >  '85' THEN 'c. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '65' THEN 'a. out'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '85' THEN 'b. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('c') AND RIGHT(CAST(cus_cust_id AS STRING), 2) >  '85' THEN 'c. GC'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '65' THEN 'a. out'
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 2) <= '85' THEN 'b. GI' 
      WHEN LEFT(waterfall_downsell_sin_preaviso_detalle, 1) IN ('d') AND RIGHT(CAST(cus_cust_id AS STRING), 2) >  '85' THEN 'c. GC'
      ELSE waterfall_downsell_sin_preaviso
    end as flag_controle
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
          ,IF(cast(crd_internal_rating as int64) > 8, 1, 0) AS FL_DETERIORO_BUREAU
          ,safe_divide(DEUDA_CLEAN_30D, current_presumed_income) AS ENDEUDAMIENTO_EXTERNO
          ,IF(IFNULL(DEUDA_VENCIDA_OVER30,0) > 100, 1, 0) AS FL_DEUDA_VENC_OVER30_CLEAN
          ,IF(safe_divide(DEUDA_CLEAN_30D, current_presumed_income) > 1 AND IFNULL(DEUDA_CLEAN_30D,0) > 300 AND IFNULL(current_presumed_income,0) > 100, 1, 0) AS FL_ENDEUDAMIENTO_EXTERNO_100
          ,safe_divide(DEUDA_CLEAN_30D, DEUDA_CLEAN_30D_M3) - 1 as porc_deterioro_divida_30d
        FROM SIMULACION
        LEFT JOIN MODEL_BUREAU    using(cus_cust_id)
        LEFT JOIN MODEL_BHV       using(cus_cust_id)
        LEFT JOIN RENTA_SCR       using(cus_cust_id)
      )
    )
  )
)
;


CREATE OR REPLACE TABLE `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO` AS

select 
  *
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_202510_GUBELARMINO`
where 1=1
and eliminated_by_rk = false 
and fl_bhv_ruim = true
and waterfall_downsell_sin_preaviso in ('c. elegible')
and flag_controle not in ('a. out')
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

-- gestion: dfd7d223-64d0-4ffc-92e5-b2eac2cc7574
-- control: a6aaede7-7013-42e5-90d3-21dc8ef8deb8

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
  'dfd7d223-64d0-4ffc-92e5-b2eac2cc7574' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'b. GI'

-- Esta declaración agregó 6,010 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
  'a6aaede7-7013-42e5-90d3-21dc8ef8deb8' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'a. Endeudamiento externo > 100%'
  and flag_controle = 'c. GC'

-- Esta declaración agregó 4,213 filas a EOC_TC_C_UPSELL_DOWNSELL.

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

-- gestion: 22a526ab-2bbf-4909-80a1-f103615b7046
-- control: bc6a6743-6c12-40a9-9e6c-213463a1b3d9

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
  '22a526ab-2bbf-4909-80a1-f103615b7046' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'b. GI'

-- Esta declaración agregó 5,926 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
  'bc6a6743-6c12-40a9-9e6c-213463a1b3d9' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'b. Deterioro deuda clean 30d > 25%'
  and flag_controle = 'c. GC'

-- Esta declaración agregó 4,193 filas a EOC_TC_C_UPSELL_DOWNSELL.

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

-- gestion: 15844d1f-6916-4a7b-9876-800f2c1ad577
-- control: 863a2b00-6195-46fb-bfc2-091b6d93e5f6

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
  '15844d1f-6916-4a7b-9876-800f2c1ad577' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'b. GI'

-- Esta declaración agregó 3,048 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
  '863a2b00-6195-46fb-bfc2-091b6d93e5f6' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'c. Deuda vencida 30d > 100'
  and flag_controle = 'c. GC'

-- Esta declaración agregó 2,090 filas a EOC_TC_C_UPSELL_DOWNSELL.

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

-- gestion: 2dfb09c5-43c4-4562-a3b1-c2b4328d5bd6
-- control: 6252480b-51d5-4dff-bed4-62c5285c29d6

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
  '2dfb09c5-43c4-4562-a3b1-c2b4328d5bd6' as CAMPAIGN_ID,
  false as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'b. GI'

-- Esta declaración agregó 9,525 filas a EOC_TC_C_UPSELL_DOWNSELL.


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
  '6252480b-51d5-4dff-bed4-62c5285c29d6' as CAMPAIGN_ID,
  true as CAMPAIGN_CONTROL_GROUP,
  'gubelarmino' as AUD_INS_USER
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_SIN_PREAVISO_FINAL_202510_GUBELARMINO`
where 1=1 
  and waterfall_downsell_sin_preaviso_detalle = 'd. Mas que un testeo'
  and flag_controle = 'c. GC'

-- Esta declaración agregó 6,588 filas a EOC_TC_C_UPSELL_DOWNSELL.