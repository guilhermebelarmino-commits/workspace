declare f_ini date;
declare num_mob numeric;
set f_ini = date('2023-01-01');
set num_mob = 6;

create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_MOB_PECASTANHO_TMP`
options (
  expiration_timestamp = timestamp_add(current_timestamp(), interval 24 hour)
)
as
with
fonte00 as ( -- entrada
  select
     tim_month as f_cartera
    ,cus_cust_id as user_id
    -- portfolio --
    ,sum(coalesce(saldo_total_180_avgd,0)) as cartera_promedio_180
    -- revenues --
    ,sum(coalesce(rev_interchange_fee,0)) as rev_interchange_fee
    ,sum(coalesce(rev_revolving,0)) as rev_revolving
    ,sum(coalesce(rev_punitorio,0)) as rev_punitorio
    ,sum(coalesce(rev_parcelamento,0)) as rev_parcelamento
    ,sum(coalesce(rev_withdrawal,0)) as rev_withdrawal
    ,sum(coalesce(rev_overlimit,0)) as rev_overlimit
    ,sum(coalesce(rev_revolving_fixed,0)) as rev_revolving_fixed
    ,sum(coalesce(rev_punitorio_fixed,0)) as rev_punitorio_fixed
    ,sum(coalesce(rev_parcelamento_fixed,0)) as rev_parcelamento_fixed
    ,sum(coalesce(rev_withdrawal_fixed,0)) as rev_withdrawal_fixed
    ,sum(coalesce(rev_overlimit_fixed,0)) as rev_overlimit_fixed
    -- fondeo y sales tax --
    ,sum(coalesce(cf_sales_taxes,0)) as sales_taxes
    ,sum(coalesce(cf_funding_cost,0) - coalesce(cf_costo_a_plazo,0)) as funding_cost
    -- COGS --
    ,sum(coalesce(co_conductor,0) + coalesce(co_money_out,0)) as procesador_cajero
    ,sum(coalesce(co_collection_fee,0)) as collection_fee
    ,sum(coalesce(emision_envio,0)) as emision_envio
    ,sum(coalesce(co_visa,0)) as visa
    ,sum(coalesce(co_bureau,0)) as bureau
    ,sum(coalesce(co_cobranzas,0)) as cobranzas
    ,sum(coalesce(co_chargeback,0)) as chargebacks -- obs chargeback para dez'24 >> ataque de fraudes ratiado por TPN
    ,sum(coalesce(cf_financing_psj*-1,0)) as financing_psj
    ,sum(coalesce(co_chargeback,0) + coalesce(co_sales_expenses,0)
      + coalesce(cf_financing_psj*-1,0) + coalesce(co_sales_expenses_sm,0)
      + coalesce(co_other_expenses_sm,0)) as sales_expenses
    ,sum(coalesce(co_marketing_total,0)) as marketing
    ,sum(coalesce(co_cx,0)) as cx
    ,sum(coalesce(co_hosting,0)) as hosting
    ,sum(coalesce(co_meli_mas_cost,0)) as meli_mais
    -- BD --
    ,sum(coalesce(cf_agreement_defaults,0)) agreements_cost
  from `meli-bi-data.SBOX_BICREDITS.CCARD_PL_TC_MLB`
  where 1=1
    and sit_site_id = 'MLB'
    and tim_month >= f_ini
    -- and cus_cust_id = 353789723
  group by all
),
joins00 as (
  select
     pl.f_cartera
    ,pl.user_id
    ,coalesce(pix.revs_pix,0) as rev_pix
    ,coalesce(pix.custo_pix,0) as co_pix
    ,coalesce(pl.rev_interchange_fee,0) as rev_interchange_fee
    ,coalesce(pl.rev_revolving_fixed,0) as rev_revolving
    ,coalesce(pl.rev_punitorio_fixed,0) as rev_punitorio
    ,coalesce(pl.rev_parcelamento_fixed,0) as rev_parcelamento
    ,coalesce(pl.rev_withdrawal_fixed,0) as rev_withdrawal
    ,coalesce(pl.rev_overlimit_fixed,0) as rev_overlimit
    ,coalesce(pl.sales_taxes,0) as co_sales_taxes
    ,coalesce(pl.funding_cost,0) as co_funding_cost
    ,coalesce(pl.procesador_cajero,0) as co_procesador_cajero
    ,coalesce(pl.collection_fee,0) as co_collection_fee
    ,coalesce(pl.emision_envio,0) as co_emision_envio
    ,coalesce(pl.visa,0) as co_visa
    ,coalesce(pl.bureau,0) as co_bureau
    ,coalesce(pl.cobranzas,0) as co_cobranzas
    ,coalesce(pl.sales_expenses,0) as co_sales_expenses
    ,coalesce(pl.marketing,0) as co_marketing
    ,coalesce(pl.cx,0) as co_cx
    ,coalesce(pl.hosting,0) as co_hosting
    ,coalesce(pl.meli_mais,0) as co_meli_mais
    ,coalesce(pl.agreements_cost,0) as co_agreements
  from fonte00 pl
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_PL_PIX_PECASTANHO` pix
    on pl.user_id = pix.cus_cust_id
    and pl.f_cartera = pix.f_cartera
),
joins01 as (
  select
     m0.f_cartera
    ,m0.user_id
    ,mob.* except(f_cartera, user_id)
    ,date_diff(mob.f_cartera, m0.f_cartera, month) as mob
  from joins00 m0
  left join joins00 mob
    on m0.user_id = mob.user_id
    -- and m0.f_cartera <= mob.f_cartera
    and m0.f_cartera <= DATE_ADD(mob.f_cartera, INTERVAL 3 MONTH)
    and date_diff(mob.f_cartera, m0.f_cartera, month) <= num_mob
),
saida00 as (
  select
     *
    ,sum(rev_pix) over (partition by user_id,f_cartera order by mob asc) as rev_pix_acum
    ,sum(co_pix) over (partition by user_id,f_cartera order by mob asc) as co_pix_acum
    ,sum(rev_interchange_fee) over (partition by user_id,f_cartera order by mob asc) as rev_interchange_fee_acum
    ,sum(rev_revolving) over (partition by user_id,f_cartera order by mob asc) as rev_revolving_acum
    ,sum(rev_punitorio) over (partition by user_id,f_cartera order by mob asc) as rev_punitorio_acum
    ,sum(rev_parcelamento) over (partition by user_id,f_cartera order by mob asc) as rev_parcelamento_acum
    ,sum(rev_withdrawal) over (partition by user_id,f_cartera order by mob asc) as rev_withdrawal_acum
    ,sum(rev_overlimit) over (partition by user_id,f_cartera order by mob asc) as rev_overlimit_acum
    ,sum(co_sales_taxes) over (partition by user_id,f_cartera order by mob asc) as co_sales_taxes_acum
    ,sum(co_funding_cost) over (partition by user_id,f_cartera order by mob asc) as co_funding_cost_acum
    ,sum(co_procesador_cajero) over (partition by user_id,f_cartera order by mob asc) as co_procesador_cajero_acum
    ,sum(co_collection_fee) over (partition by user_id,f_cartera order by mob asc) as co_collection_fee_acum
    ,sum(co_emision_envio) over (partition by user_id,f_cartera order by mob asc) as co_emision_envio_acum
    ,sum(co_visa) over (partition by user_id,f_cartera order by mob asc) as co_visa_acum
    ,sum(co_bureau) over (partition by user_id,f_cartera order by mob asc) as co_bureau_acum
    ,sum(co_cobranzas) over (partition by user_id,f_cartera order by mob asc) as co_cobranzas_acum
    ,sum(co_sales_expenses) over (partition by user_id,f_cartera order by mob asc) as co_sales_expenses_acum
    ,sum(co_marketing) over (partition by user_id,f_cartera order by mob asc) as co_marketing_acum
    ,sum(co_cx) over (partition by user_id,f_cartera order by mob asc) as co_cx_acum
    ,sum(co_hosting) over (partition by user_id,f_cartera order by mob asc) as co_hosting_acum
    ,sum(co_meli_mais) over (partition by user_id,f_cartera order by mob asc) as co_meli_mais_acum
    ,sum(co_agreements) over (partition by user_id,f_cartera order by mob asc) as co_agreements_acum
  from joins01
)
select
  *
from saida00
;