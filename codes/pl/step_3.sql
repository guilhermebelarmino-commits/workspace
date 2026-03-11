-- drop table if exists `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO`;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO`
(
   f_cartera	DATE
  ,user_id	INT64
  ,rev_pix	BIGNUMERIC
  ,co_pix	BIGNUMERIC
  ,rev_interchange_fee	NUMERIC
  ,rev_revolving	NUMERIC
  ,rev_punitorio	NUMERIC
  ,rev_parcelamento	NUMERIC
  ,rev_withdrawal	NUMERIC
  ,rev_overlimit	NUMERIC
  ,co_sales_taxes	NUMERIC
  ,co_funding_cost	NUMERIC
  ,co_procesador_cajero	NUMERIC
  ,co_collection_fee	NUMERIC
  ,co_emision_envio	FLOAT64
  ,co_visa	NUMERIC
  ,co_bureau	NUMERIC
  ,co_cobranzas	NUMERIC
  ,co_sales_expenses	BIGNUMERIC
  ,co_marketing	NUMERIC
  ,co_cx	NUMERIC
  ,co_hosting	NUMERIC
  ,co_meli_mais	FLOAT64
  ,co_agreements	NUMERIC
  ,mob	INT64
  ,rev_pix_acum	BIGNUMERIC
  ,co_pix_acum	BIGNUMERIC
  ,rev_interchange_fee_acum	NUMERIC
  ,rev_revolving_acum	NUMERIC
  ,rev_punitorio_acum	NUMERIC
  ,rev_parcelamento_acum	NUMERIC
  ,rev_withdrawal_acum	NUMERIC
  ,rev_overlimit_acum	NUMERIC
  ,co_sales_taxes_acum	NUMERIC
  ,co_funding_cost_acum	NUMERIC
  ,co_procesador_cajero_acum	NUMERIC
  ,co_collection_fee_acum	NUMERIC
  ,co_emision_envio_acum	FLOAT64
  ,co_visa_acum	NUMERIC
  ,co_bureau_acum	NUMERIC
  ,co_cobranzas_acum	NUMERIC
  ,co_sales_expenses_acum	BIGNUMERIC
  ,co_marketing_acum	NUMERIC
  ,co_cx_acum	NUMERIC
  ,co_hosting_acum	NUMERIC
  ,co_meli_mais_acum	FLOAT64
  ,co_agreements_acum	NUMERIC
)
partition by f_cartera
cluster by mob
;

insert into `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_2_PECASTANHO` (
   f_cartera
  ,user_id
  ,rev_pix
  ,co_pix
  ,rev_interchange_fee
  ,rev_revolving
  ,rev_punitorio
  ,rev_parcelamento
  ,rev_withdrawal
  ,rev_overlimit
  ,co_sales_taxes
  ,co_funding_cost
  ,co_procesador_cajero
  ,co_collection_fee
  ,co_emision_envio
  ,co_visa
  ,co_bureau
  ,co_cobranzas
  ,co_sales_expenses
  ,co_marketing
  ,co_cx
  ,co_hosting
  ,co_meli_mais
  ,co_agreements
  ,mob
  ,rev_pix_acum
  ,co_pix_acum
  ,rev_interchange_fee_acum
  ,rev_revolving_acum
  ,rev_punitorio_acum
  ,rev_parcelamento_acum
  ,rev_withdrawal_acum
  ,rev_overlimit_acum
  ,co_sales_taxes_acum
  ,co_funding_cost_acum
  ,co_procesador_cajero_acum
  ,co_collection_fee_acum
  ,co_emision_envio_acum
  ,co_visa_acum
  ,co_bureau_acum
  ,co_cobranzas_acum
  ,co_sales_expenses_acum
  ,co_marketing_acum
  ,co_cx_acum
  ,co_hosting_acum
  ,co_meli_mais_acum
  ,co_agreements_acum
)
select
  *
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO_2_TMP`
;