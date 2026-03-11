declare f_ini date;
set f_ini = date('2023-01-01');

create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_PL_CARTERA_PECASTANHO` as
with
temp00 as ( -- entrada
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
  group by all
),
temp01 as (
  select
     pl.*
    ,pix.revs_pix as rev_pix_m0
    ,pix.custo_pix as co_pix_m0
    ,(
      pl.rev_interchange_fee
      + pl.rev_revolving
      + pl.rev_punitorio
      + pl.rev_parcelamento
      + pl.rev_withdrawal
      + pl.rev_overlimit) as rev_all_deprecated_m0
    ,(
      pl.rev_interchange_fee
      + pl.rev_revolving_fixed
      + pl.rev_punitorio_fixed
      + pl.rev_parcelamento_fixed
      + pl.rev_withdrawal_fixed
      + pl.rev_overlimit_fixed) as rev_all_m0
    ,(
      pl.sales_taxes
      + pl.funding_cost) as co_fondeo_tax_m0
    ,(
      pl.procesador_cajero
      + pl.collection_fee
      + pl.emision_envio
      + pl.visa
      + pl.bureau
      + pl.cobranzas
      + pl.sales_expenses
      + pl.marketing
      + pl.cx
      + pl.hosting
      + pl.meli_mais) as co_other_cogs_m0
    ,pl.meli_mais as meli_mais_m0
    ,agreements_cost as co_agreements_m0

    ,rev_interchange_fee as rev_interchange_fee_m0
    ,rev_revolving as rev_revolving_m0
    ,rev_punitorio as rev_punitorio_m0
    ,rev_parcelamento as rev_parcelamento_m0
    ,rev_withdrawal as rev_withdrawal_m0
    ,rev_overlimit as rev_overlimit_m0
    ,rev_revolving_fixed as rev_revolving_fixed_m0
    ,rev_punitorio_fixed as rev_punitorio_fixed_m0
    ,rev_parcelamento_fixed as rev_parcelamento_fixed_m0
    ,rev_withdrawal_fixed as rev_withdrawal_fixed_m0
    ,rev_overlimit_fixed as rev_overlimit_fixed_m0


  from temp00 pl
  left join `SBOX_CREDITS_SB.RBA_TC_MLB_PL_PIX_PECASTANHO` pix
    on pl.user_id = pix.cus_cust_id
    and pl.f_cartera = pix.f_cartera
),
temp02 as (
  select
     m0.*
    ,m1.rev_all_m0 as rev_all_m1
    ,m1.co_fondeo_tax_m0 as co_fondeo_tax_m1
    ,m1.co_other_cogs_m0 as co_other_cogs_m1
    ,m1.co_agreements_m0 as co_agreements_m1
    ,m1.meli_mais_m0 as meli_mais_m1
    ,m1.rev_pix_m0 as rev_pix_m1
    ,m1.co_pix_m0 as co_pix_m1
    ,m1.rev_interchange_fee_m0 as rev_interchange_fee_m1
    ,m1.rev_revolving_fixed_m0 as rev_revolving_fixed_m1
    ,m1.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m1
    ,m1.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m1
    ,m1.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m1
    ,m1.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m1

    ,m2.rev_all_m0 as rev_all_m2
    ,m2.co_fondeo_tax_m0 as co_fondeo_tax_m2
    ,m2.co_other_cogs_m0 as co_other_cogs_m2
    ,m2.co_agreements_m0 as co_agreements_m2
    ,m2.meli_mais_m0 as meli_mais_m2
    ,m2.rev_pix_m0 as rev_pix_m2
    ,m2.co_pix_m0 as co_pix_m2
    ,m2.rev_interchange_fee_m0 as rev_interchange_fee_m2
    ,m2.rev_revolving_fixed_m0 as rev_revolving_fixed_m2
    ,m2.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m2
    ,m2.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m2
    ,m2.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m2
    ,m2.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m2


    ,m3.rev_all_m0 as rev_all_m3
    ,m3.co_fondeo_tax_m0 as co_fondeo_tax_m3
    ,m3.co_other_cogs_m0 as co_other_cogs_m3
    ,m3.co_agreements_m0 as co_agreements_m3
    ,m3.meli_mais_m0 as meli_mais_m3
    ,m3.rev_pix_m0 as rev_pix_m3
    ,m3.co_pix_m0 as co_pix_m3
    ,m3.rev_interchange_fee_m0 as rev_interchange_fee_m3
    ,m3.rev_revolving_fixed_m0 as rev_revolving_fixed_m3
    ,m3.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m3
    ,m3.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m3
    ,m3.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m3
    ,m3.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m3

    ,m4.rev_all_m0 as rev_all_m4
    ,m4.co_fondeo_tax_m0 as co_fondeo_tax_m4
    ,m4.co_other_cogs_m0 as co_other_cogs_m4
    ,m4.co_agreements_m0 as co_agreements_m4
    ,m4.meli_mais_m0 as meli_mais_m4
    ,m4.rev_pix_m0 as rev_pix_m4
    ,m4.co_pix_m0 as co_pix_m4
    ,m4.rev_interchange_fee_m0 as rev_interchange_fee_m4
    ,m4.rev_revolving_fixed_m0 as rev_revolving_fixed_m4
    ,m4.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m4
    ,m4.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m4
    ,m4.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m4
    ,m4.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m4

    ,m5.rev_all_m0 as rev_all_m5
    ,m5.co_fondeo_tax_m0 as co_fondeo_tax_m5
    ,m5.co_other_cogs_m0 as co_other_cogs_m5
    ,m5.co_agreements_m0 as co_agreements_m5
    ,m5.meli_mais_m0 as meli_mais_m5
    ,m5.rev_pix_m0 as rev_pix_m5
    ,m5.co_pix_m0 as co_pix_m5
    ,m5.rev_interchange_fee_m0 as rev_interchange_fee_m5
    ,m5.rev_revolving_fixed_m0 as rev_revolving_fixed_m5
    ,m5.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m5
    ,m5.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m5
    ,m5.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m5
    ,m5.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m5

    ,m6.rev_all_m0 as rev_all_m6
    ,m6.co_fondeo_tax_m0 as co_fondeo_tax_m6
    ,m6.co_other_cogs_m0 as co_other_cogs_m6
    ,m6.co_agreements_m0 as co_agreements_m6
    ,m6.meli_mais_m0 as meli_mais_m6
    ,m6.rev_pix_m0 as rev_pix_m6
    ,m6.co_pix_m0 as co_pix_m6
    ,m6.rev_interchange_fee_m0 as rev_interchange_fee_m6
    ,m6.rev_revolving_fixed_m0 as rev_revolving_fixed_m6
    ,m6.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m6
    ,m6.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m6
    ,m6.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m6
    ,m6.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m6

    ,m7.rev_all_m0 as rev_all_m7
    ,m7.co_fondeo_tax_m0 as co_fondeo_tax_m7
    ,m7.co_other_cogs_m0 as co_other_cogs_m7
    ,m7.co_agreements_m0 as co_agreements_m7
    ,m7.meli_mais_m0 as meli_mais_m7
    ,m7.rev_pix_m0 as rev_pix_m7
    ,m7.co_pix_m0 as co_pix_m7
    ,m7.rev_interchange_fee_m0 as rev_interchange_fee_m7
    ,m7.rev_revolving_fixed_m0 as rev_revolving_fixed_m7
    ,m7.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m7
    ,m7.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m7
    ,m7.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m7
    ,m7.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m7

    ,m8.rev_all_m0 as rev_all_m8
    ,m8.co_fondeo_tax_m0 as co_fondeo_tax_m8
    ,m8.co_other_cogs_m0 as co_other_cogs_m8
    ,m8.co_agreements_m0 as co_agreements_m8
    ,m8.meli_mais_m0 as meli_mais_m8
    ,m8.rev_pix_m0 as rev_pix_m8
    ,m8.co_pix_m0 as co_pix_m8
    ,m8.rev_interchange_fee_m0 as rev_interchange_fee_m8
    ,m8.rev_revolving_fixed_m0 as rev_revolving_fixed_m8
    ,m8.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m8
    ,m8.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m8
    ,m8.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m8
    ,m8.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m8

    ,m9.rev_all_m0 as rev_all_m9
    ,m9.co_fondeo_tax_m0 as co_fondeo_tax_m9
    ,m9.co_other_cogs_m0 as co_other_cogs_m9
    ,m9.co_agreements_m0 as co_agreements_m9
    ,m9.meli_mais_m0 as meli_mais_m9
    ,m9.rev_pix_m0 as rev_pix_m9
    ,m9.co_pix_m0 as co_pix_m9
    ,m9.rev_interchange_fee_m0 as rev_interchange_fee_m9
    ,m9.rev_revolving_fixed_m0 as rev_revolving_fixed_m9
    ,m9.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m9
    ,m9.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m9
    ,m9.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m9
    ,m9.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m9

    ,m10.rev_all_m0 as rev_all_m10
    ,m10.co_fondeo_tax_m0 as co_fondeo_tax_m10
    ,m10.co_other_cogs_m0 as co_other_cogs_m10
    ,m10.co_agreements_m0 as co_agreements_m10
    ,m10.meli_mais_m0 as meli_mais_m10
    ,m10.rev_pix_m0 as rev_pix_m10
    ,m10.co_pix_m0 as co_pix_m10
    ,m10.rev_interchange_fee_m0 as rev_interchange_fee_m10
    ,m10.rev_revolving_fixed_m0 as rev_revolving_fixed_m10
    ,m10.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m10
    ,m10.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m10
    ,m10.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m10
    ,m10.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m10

    ,m11.rev_all_m0 as rev_all_m11
    ,m11.co_fondeo_tax_m0 as co_fondeo_tax_m11
    ,m11.co_other_cogs_m0 as co_other_cogs_m11
    ,m11.co_agreements_m0 as co_agreements_m11
    ,m11.meli_mais_m0 as meli_mais_m11
    ,m11.rev_pix_m0 as rev_pix_m11
    ,m11.co_pix_m0 as co_pix_m11
    ,m11.rev_interchange_fee_m0 as rev_interchange_fee_m11
    ,m11.rev_revolving_fixed_m0 as rev_revolving_fixed_m11
    ,m11.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m11
    ,m11.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m11
    ,m11.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m11
    ,m11.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m11

    ,m12.rev_all_m0 as rev_all_m12
    ,m12.co_fondeo_tax_m0 as co_fondeo_tax_m12
    ,m12.co_other_cogs_m0 as co_other_cogs_m12
    ,m12.co_agreements_m0 as co_agreements_m12
    ,m12.meli_mais_m0 as meli_mais_m12
    ,m12.rev_pix_m0 as rev_pix_m12
    ,m12.co_pix_m0 as co_pix_m12
    ,m12.rev_interchange_fee_m0 as rev_interchange_fee_m12
    ,m12.rev_revolving_fixed_m0 as rev_revolving_fixed_m12
    ,m12.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m12
    ,m12.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m12
    ,m12.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m12
    ,m12.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m12

    ,m_1.rev_all_m0 as rev_all_m_1
    ,m_1.co_fondeo_tax_m0 as co_fondeo_tax_m_1
    ,m_1.co_other_cogs_m0 as co_other_cogs_m_1
    ,m_1.co_agreements_m0 as co_agreements_m_1
    ,m_1.meli_mais_m0 as meli_mais_m_1
    ,m_1.rev_pix_m0 as rev_pix_m_1
    ,m_1.co_pix_m0 as co_pix_m_1
    ,m_1.rev_interchange_fee_m0 as rev_interchange_fee_m_1
    ,m_1.rev_revolving_fixed_m0 as rev_revolving_fixed_m_1
    ,m_1.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m_1
    ,m_1.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m_1
    ,m_1.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m_1
    ,m_1.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m_1

    ,m_2.rev_all_m0 as rev_all_m_2
    ,m_2.co_fondeo_tax_m0 as co_fondeo_tax_m_2
    ,m_2.co_other_cogs_m0 as co_other_cogs_m_2
    ,m_2.co_agreements_m0 as co_agreements_m_2
    ,m_2.meli_mais_m0 as meli_mais_m_2
    ,m_2.rev_pix_m0 as rev_pix_m_2
    ,m_2.co_pix_m0 as co_pix_m_2
    ,m_2.rev_interchange_fee_m0 as rev_interchange_fee_m_2
    ,m_2.rev_revolving_fixed_m0 as rev_revolving_fixed_m_2
    ,m_2.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m_2
    ,m_2.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m_2
    ,m_2.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m_2
    ,m_2.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m_2

    ,m_3.rev_all_m0 as rev_all_m_3
    ,m_3.co_fondeo_tax_m0 as co_fondeo_tax_m_3
    ,m_3.co_other_cogs_m0 as co_other_cogs_m_3
    ,m_3.co_agreements_m0 as co_agreements_m_3
    ,m_3.meli_mais_m0 as meli_mais_m_3
    ,m_3.rev_pix_m0 as rev_pix_m_3
    ,m_3.co_pix_m0 as co_pix_m_3
    ,m_3.rev_interchange_fee_m0 as rev_interchange_fee_m_3
    ,m_3.rev_revolving_fixed_m0 as rev_revolving_fixed_m_3
    ,m_3.rev_punitorio_fixed_m0 as rev_punitorio_fixed_m_3
    ,m_3.rev_parcelamento_fixed_m0 as rev_parcelamento_fixed_m_3
    ,m_3.rev_withdrawal_fixed_m0 as rev_withdrawal_fixed_m_3
    ,m_3.rev_overlimit_fixed_m0 as rev_overlimit_fixed_m_3
  from temp01 m0
  left join temp01 m1
    on m0.user_id = m1.user_id
    and m0.f_cartera = (m1.f_cartera - interval 1 month)
  left join temp01 m2
    on m0.user_id = m2.user_id
    and m0.f_cartera = (m2.f_cartera - interval 2 month)
  left join temp01 m3
    on m0.user_id = m3.user_id
    and m0.f_cartera = (m3.f_cartera - interval 3 month)
  left join temp01 m4
    on m0.user_id = m4.user_id
    and m0.f_cartera = (m4.f_cartera - interval 4 month)
  left join temp01 m5
    on m0.user_id = m5.user_id
    and m0.f_cartera = (m5.f_cartera - interval 5 month)
  left join temp01 m6
    on m0.user_id = m6.user_id
    and m0.f_cartera = (m6.f_cartera - interval 6 month)
  left join temp01 m7
    on m0.user_id = m7.user_id
    and m0.f_cartera = (m7.f_cartera - interval 7 month)
  left join temp01 m8
    on m0.user_id = m8.user_id
    and m0.f_cartera = (m8.f_cartera - interval 8 month)
  left join temp01 m9
    on m0.user_id = m9.user_id
    and m0.f_cartera = (m9.f_cartera - interval 9 month)
  left join temp01 m10
    on m0.user_id = m10.user_id
    and m0.f_cartera = (m10.f_cartera - interval 10 month)
  left join temp01 m11
    on m0.user_id = m11.user_id
    and m0.f_cartera = (m11.f_cartera - interval 11 month)
  left join temp01 m12
    on m0.user_id = m12.user_id
    and m0.f_cartera = (m12.f_cartera - interval 12 month)
  left join temp01 m_1
    on m0.user_id = m_1.user_id
    and m0.f_cartera = (m_1.f_cartera + interval 1 month)
  left join temp01 m_2
    on m0.user_id = m_2.user_id
    and m0.f_cartera = (m_2.f_cartera + interval 2 month)
  left join temp01 m_3
    on m0.user_id = m_3.user_id
    and m0.f_cartera = (m_3.f_cartera + interval 3 month)
)
select
  *
from temp02
;