--- INSERT BAU ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO`

--- IMPACTO

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---60aad324-358c-4348-8f90-f9e5732a1158

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
--1614f8b2-b95b-48ed-adc0-4aa5f67a4017


--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`
(
  USER_ID,
  GENERAL_LIMIT,
  WITHDRAW_LIMIT,
  SITE_ID,
  PRIORITY,
  IS_UPSELL,
  CAMPAIGN_ID,
  AUD_INS_USER
)
select  
  cus_cust_id as USER_ID,
  CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' SITE_ID,
  0 PRIORITY,
  1 IS_UPSELL,
  '60aad324-358c-4348-8f90-f9e5732a1158' CAMPAIGN_ID,
  'gubelarmino' AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO`
where grupos like '%GI%' and upsell = 'bau'
;

-- Esta declaración agregó 158,068 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
  CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
  50 as WITHDRAW_LIMIT,
  'MLB' SITE_ID,
  0 PRIORITY,
  1 IS_UPSELL,
  '1614f8b2-b95b-48ed-adc0-4aa5f67a4017' CAMPAIGN_ID,
  CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO`
where grupos like '%GC%' and upsell = 'bau'
;

-- Esta declaración agregó 8,332 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MP ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---8bbfb589-237a-4673-9542-7c2156b46e08

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---4b959166-3856-45fc-9065-037ce15d2688


--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)

select  
cus_cust_id as USER_ID,
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'8bbfb589-237a-4673-9542-7c2156b46e08' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mp'
;

-- Esta declaración agregó 88,117 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'4b959166-3856-45fc-9065-037ce15d2688' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mp'
;

-- Esta declaración agregó 4,593 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MKPLACE ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---329a525a-280f-4fed-9b21-65916ff120ed

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'CROSS', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---09b88e14-6861-4f4a-929f-76983b027ccb

--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)
select  
cus_cust_id as USER_ID,
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'329a525a-280f-4fed-9b21-65916ff120ed' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 89,326 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'09b88e14-6861-4f4a-929f-76983b027ccb' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 4,682 filas a EOC_TC_C_UPSELL_DOWNSELL.


--- INSERT SOW AUMENTO EXPOSICION ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---bf49a164-54f5-4f76-bb4a-36ff83ac47a9

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);


--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---843a2078-9bc0-4076-93dc-591745ae153b

--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)
select  
cus_cust_id as USER_ID,
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'bf49a164-54f5-4f76-bb4a-36ff83ac47a9' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'SOW aumento exposicion'
;

-- Esta declaración agregó 63,334 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'843a2078-9bc0-4076-93dc-591745ae153b' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'SOW aumento exposicion'
;

-- Esta declaración agregó 3,377 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT SOW riesgo medio ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 

-- IMPACTO
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---f206a2e1-5c90-4579-ac00-a69d8df5b95a

--CONTROL
CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST REACH', --5 Policy
'BAU', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);


--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'guilherme.belarmino@mercadopago.com.br' AND DATE(AUD_INS_DTTM) = CURRENT_DATE;
---f11a1e59-ca96-45f5-a9a4-45a0affcc8e3

--- INSERT EN CEREBRO 
      
--insert GI 1

INSERT INTO `meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL`(
USER_ID,
GENERAL_LIMIT,
WITHDRAW_LIMIT,
SITE_ID,
PRIORITY,
IS_UPSELL,
CAMPAIGN_ID,
AUD_INS_USER)
select  
cus_cust_id as USER_ID,
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'f206a2e1-5c90-4579-ac00-a69d8df5b95a' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 4,011 filas a EOC_TC_C_UPSELL_DOWNSELL.

---insert GC

INSERT INTO meli-bi-data.SBOX_CREDITS_SB.EOC_TC_C_UPSELL_DOWNSELL(
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
CAST(limite_final AS BIGINT) as GENERAL_LIMIT,
50 as WITHDRAW_LIMIT,
'MLB' SITE_ID,
0 PRIORITY,
1 IS_UPSELL,
'f11a1e59-ca96-45f5-a9a4-45a0affcc8e3' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251106_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 216 filas a EOC_TC_C_UPSELL_DOWNSELL.