--- INSERT BAU ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO`

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
---5ac338e8-747a-4c92-97f8-fcb523399b7c

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
--03db0a8f-478d-498d-bd1f-a8d55bdf9a87


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
  '5ac338e8-747a-4c92-97f8-fcb523399b7c' CAMPAIGN_ID,
  'gubelarmino' AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO`
where grupos like '%GI%' and upsell = 'bau'
;

-- Esta declaración agregó 155,221 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
  '03db0a8f-478d-498d-bd1f-a8d55bdf9a87' CAMPAIGN_ID,
  CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO`
where grupos like '%GC%' and upsell = 'bau'
;

-- Esta declaración agregó 8,201 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MP ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 

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
---bae5cc4a-c6bf-49e6-bf19-6d3aa751aa6f

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
---a762d04d-bbfa-4980-88e6-54c10db327e9


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
'bae5cc4a-c6bf-49e6-bf19-6d3aa751aa6f' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mp'
;

-- Esta declaración agregó 67,034 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'a762d04d-bbfa-4980-88e6-54c10db327e9' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mp'
;

-- Esta declaración agregó 3,555 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT VIPS MKPLACE ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 

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
---1da83c48-b177-48fd-93fd-4bc4b353c1f9

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
---835c1996-68d5-4b70-b67b-9cdae62c493b

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
'1da83c48-b177-48fd-93fd-4bc4b353c1f9' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 84,883 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'835c1996-68d5-4b70-b67b-9cdae62c493b' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'vips mktplace'
;

-- Esta declaración agregó 4,477 filas a EOC_TC_C_UPSELL_DOWNSELL.


--- INSERT SOW AUMENTO EXPOSICION ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 

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
---57018d75-59d4-4452-be3f-983769e6fe51

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
---ee6eac3c-eaa9-40aa-b35c-6ee9824766f7

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
'57018d75-59d4-4452-be3f-983769e6fe51' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'SOW aumento exposicion'
;

-- Esta declaración agregó 41,942 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'ee6eac3c-eaa9-40aa-b35c-6ee9824766f7' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'SOW aumento exposicion'
;

-- Esta declaración agregó 2,146 filas a EOC_TC_C_UPSELL_DOWNSELL.

--- INSERT SOW riesgo medio ---

-- `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 

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
---0e21ade9-e7d0-4b91-bce0-e4ee11670bc3

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
---bf2fd248-5ff5-4538-8411-a98d1d4afabc

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
'0e21ade9-e7d0-4b91-bce0-e4ee11670bc3' CAMPAIGN_ID,
'gubelarmino' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GI%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 5,461 filas a EOC_TC_C_UPSELL_DOWNSELL.

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
'bf2fd248-5ff5-4538-8411-a98d1d4afabc' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'gubelarmino' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20251007_GI_GC_GUBELARMINO` 
where grupos like '%GC%' and upsell = 'SOW riesgo medio'
;

-- Esta declaración agregó 279 filas a EOC_TC_C_UPSELL_DOWNSELL.