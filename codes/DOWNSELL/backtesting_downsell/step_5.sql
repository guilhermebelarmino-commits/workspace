create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_2_PECASTANHO`
as
select
   a.* except(
     deuda_over30m0
    ,deuda_over30m1
    ,deuda_over30m2
    ,deuda_over30m3
    ,deuda_over30m4
    ,deuda_over30m5
    ,deuda_over30m6
    ,deuda_over30m7
    ,deuda_over30m8
    ,deuda_over30m9
    ,deuda_over30m10
    ,deuda_over30m11
    ,deuda_over30m12
    ,deuda_over30m_1
    ,deuda_over30m_2
    ,deuda_over30m_3
    ,deuda_m0
    ,deuda_m1
    ,deuda_m2
    ,deuda_m3
    ,deuda_m4
    ,deuda_m5
    ,deuda_m6
    ,deuda_m7
    ,deuda_m8
    ,deuda_m9
    ,deuda_m10
    ,deuda_m11
    ,deuda_m12
    ,deuda_m_1
    ,deuda_m_2
    ,deuda_m_3
    ,tpv_m0
    ,tpv_m1
    ,tpv_m2
    ,tpv_m3
    ,tpv_m4
    ,tpv_m5
    ,tpv_m6
    ,tpv_m7
    ,tpv_m8
    ,tpv_m9
    ,tpv_m10
    ,tpv_m11
    ,tpv_m12
    ,tpv_m_1
    ,tpv_m_2
    ,tpv_m_3
    ,rev_all_deprecated_m0
    ,rev_all_m0
    ,rev_all_m1
    ,rev_all_m2
    ,rev_all_m3
    ,rev_all_m4
    ,rev_all_m5
    ,rev_all_m6
    ,rev_all_m7
    ,rev_all_m8
    ,rev_all_m9
    ,rev_all_m10
    ,rev_all_m11
    ,rev_all_m12
    ,rev_all_m_1
    ,rev_all_m_2
    ,rev_all_m_3
    ,co_fondeo_tax_m0
    ,co_fondeo_tax_m1
    ,co_fondeo_tax_m2
    ,co_fondeo_tax_m3
    ,co_fondeo_tax_m4
    ,co_fondeo_tax_m5
    ,co_fondeo_tax_m6
    ,co_fondeo_tax_m7
    ,co_fondeo_tax_m8
    ,co_fondeo_tax_m9
    ,co_fondeo_tax_m10
    ,co_fondeo_tax_m11
    ,co_fondeo_tax_m12
    ,co_fondeo_tax_m_1
    ,co_fondeo_tax_m_2
    ,co_fondeo_tax_m_3
    ,co_other_cogs_m0
    ,co_other_cogs_m1
    ,co_other_cogs_m2
    ,co_other_cogs_m3
    ,co_other_cogs_m4
    ,co_other_cogs_m5
    ,co_other_cogs_m6
    ,co_other_cogs_m7
    ,co_other_cogs_m8
    ,co_other_cogs_m9
    ,co_other_cogs_m10
    ,co_other_cogs_m11
    ,co_other_cogs_m12
    ,co_other_cogs_m_1
    ,co_other_cogs_m_2
    ,co_other_cogs_m_3
    ,co_agreements_m0
    ,co_agreements_m1
    ,co_agreements_m2
    ,co_agreements_m3
    ,co_agreements_m4
    ,co_agreements_m5
    ,co_agreements_m6
    ,co_agreements_m7
    ,co_agreements_m8
    ,co_agreements_m9
    ,co_agreements_m10
    ,co_agreements_m11
    ,co_agreements_m12
    ,co_agreements_m_1
    ,co_agreements_m_2
    ,co_agreements_m_3
    ,rev_pix_m0
    ,rev_pix_m1
    ,rev_pix_m2
    ,rev_pix_m3
    ,rev_pix_m4
    ,rev_pix_m5
    ,rev_pix_m6
    ,rev_pix_m7
    ,rev_pix_m8
    ,rev_pix_m9
    ,rev_pix_m10
    ,rev_pix_m11
    ,rev_pix_m12
    ,rev_pix_m_1
    ,rev_pix_m_2
    ,rev_pix_m_3
    ,co_pix_m0
    ,co_pix_m1
    ,co_pix_m2
    ,co_pix_m3
    ,co_pix_m4
    ,co_pix_m5
    ,co_pix_m6
    ,co_pix_m7
    ,co_pix_m8
    ,co_pix_m9
    ,co_pix_m10
    ,co_pix_m11
    ,co_pix_m12
    ,co_pix_m_1
    ,co_pix_m_2
    ,co_pix_m_3
    ,rev_interchange_fee
    ,rev_interchange_fee_m0
    ,rev_interchange_fee_m1
    ,rev_interchange_fee_m2
    ,rev_interchange_fee_m3
    ,rev_interchange_fee_m4
    ,rev_interchange_fee_m5
    ,rev_interchange_fee_m6
    ,rev_interchange_fee_m7
    ,rev_interchange_fee_m8
    ,rev_interchange_fee_m9
    ,rev_interchange_fee_m10
    ,rev_interchange_fee_m11
    ,rev_interchange_fee_m12
    ,rev_interchange_fee_m_1
    ,rev_interchange_fee_m_2
    ,rev_interchange_fee_m_3
    ,rev_revolving
    ,rev_revolving_m0
    ,rev_revolving_fixed_m0
    ,rev_revolving_fixed_m1
    ,rev_revolving_fixed_m2
    ,rev_revolving_fixed_m3
    ,rev_revolving_fixed_m4
    ,rev_revolving_fixed_m5
    ,rev_revolving_fixed_m6
    ,rev_revolving_fixed_m7
    ,rev_revolving_fixed_m8
    ,rev_revolving_fixed_m9
    ,rev_revolving_fixed_m10
    ,rev_revolving_fixed_m11
    ,rev_revolving_fixed_m12
    ,rev_revolving_fixed_m_1
    ,rev_revolving_fixed_m_2
    ,rev_revolving_fixed_m_3
    ,rev_punitorio
    ,rev_punitorio_m0
    ,rev_punitorio_fixed_m0
    ,rev_punitorio_fixed_m1
    ,rev_punitorio_fixed_m2
    ,rev_punitorio_fixed_m3
    ,rev_punitorio_fixed_m4
    ,rev_punitorio_fixed_m5
    ,rev_punitorio_fixed_m6
    ,rev_punitorio_fixed_m7
    ,rev_punitorio_fixed_m8
    ,rev_punitorio_fixed_m9
    ,rev_punitorio_fixed_m10
    ,rev_punitorio_fixed_m11
    ,rev_punitorio_fixed_m12
    ,rev_punitorio_fixed_m_1
    ,rev_punitorio_fixed_m_2
    ,rev_punitorio_fixed_m_3
    ,rev_parcelamento_m0
    ,rev_parcelamento
    ,rev_parcelamento_fixed_m0
    ,rev_parcelamento_fixed_m1
    ,rev_parcelamento_fixed_m2
    ,rev_parcelamento_fixed_m3
    ,rev_parcelamento_fixed_m4
    ,rev_parcelamento_fixed_m5
    ,rev_parcelamento_fixed_m6
    ,rev_parcelamento_fixed_m7
    ,rev_parcelamento_fixed_m8
    ,rev_parcelamento_fixed_m9
    ,rev_parcelamento_fixed_m10
    ,rev_parcelamento_fixed_m11
    ,rev_parcelamento_fixed_m12
    ,rev_parcelamento_fixed_m_1
    ,rev_parcelamento_fixed_m_2
    ,rev_parcelamento_fixed_m_3
    ,rev_withdrawal
    ,rev_withdrawal_m0
    ,rev_withdrawal_fixed_m0
    ,rev_withdrawal_fixed_m1
    ,rev_withdrawal_fixed_m2
    ,rev_withdrawal_fixed_m3
    ,rev_withdrawal_fixed_m4
    ,rev_withdrawal_fixed_m5
    ,rev_withdrawal_fixed_m6
    ,rev_withdrawal_fixed_m7
    ,rev_withdrawal_fixed_m8
    ,rev_withdrawal_fixed_m9
    ,rev_withdrawal_fixed_m10
    ,rev_withdrawal_fixed_m11
    ,rev_withdrawal_fixed_m12
    ,rev_withdrawal_fixed_m_1
    ,rev_withdrawal_fixed_m_2
    ,rev_withdrawal_fixed_m_3
    ,rev_overlimit
    ,rev_overlimit_m0
    ,rev_overlimit_fixed_m0
    ,rev_overlimit_fixed_m1
    ,rev_overlimit_fixed_m2
    ,rev_overlimit_fixed_m3
    ,rev_overlimit_fixed_m4
    ,rev_overlimit_fixed_m5
    ,rev_overlimit_fixed_m6
    ,rev_overlimit_fixed_m7
    ,rev_overlimit_fixed_m8
    ,rev_overlimit_fixed_m9
    ,rev_overlimit_fixed_m10
    ,rev_overlimit_fixed_m11
    ,rev_overlimit_fixed_m12
    ,rev_overlimit_fixed_m_1
    ,rev_overlimit_fixed_m_2
    ,rev_overlimit_fixed_m_3
    ,deuda_financiada_m0
    ,deuda_financiada_m1
    ,deuda_financiada_m2
    ,deuda_financiada_m3
    ,deuda_financiada_m4
    ,deuda_financiada_m5
    ,deuda_financiada_m6
    ,meli_mais
    ,meli_mais_m0
    ,meli_mais_m1
    ,meli_mais_m2
    ,meli_mais_m3
    ,meli_mais_m4
    ,meli_mais_m5
    ,meli_mais_m6
    ,meli_mais_m7
    ,meli_mais_m8
    ,meli_mais_m9
    ,meli_mais_m10
    ,meli_mais_m11
    ,meli_mais_m12
    ,meli_mais_m_1
    ,meli_mais_m_2
    ,meli_mais_m_3
    ,porc_prevision_m0
    ,porc_prevision_m1
    ,porc_prevision_m2
    ,porc_prevision_m3
    ,porc_prevision_m4
    ,porc_prevision_m5
    ,porc_prevision_m6
    ,dpd_m0
    ,dpd_m1
    ,dpd_m2
    ,dpd_m3
    ,dpd_m4
    ,dpd_m5
    ,dpd_m6
    )

  ,b.mob
  ,b.deuda_over30
  ,b.deuda
  ,b.deuda_financiada
  ,b.dpd
  ,b.tpv
  ,b.rev_all
  ,b.co_fondeo_tax
  ,b.co_other_cogs
  ,b.co_agreements
  ,b.rev_pix
  ,b.co_pix
  ,b.rev_interchange_fee
  ,b.rev_revolving
  ,b.rev_punitorio
  ,b.rev_parcelamento
  ,b.rev_withdrawal
  ,b.rev_overlimit
  ,b.meli_mais
  ,b.porc_prevision
  ,safe_multiply(b.deuda, coalesce(b.porc_prevision,0)) as deuda_prevision
  ,sum(b.tpv) over (partition by a.campaign_id, a.user_id order by b.mob asc) as tpv_acum
  ,sum(b.rev_all) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_all_acum
  ,sum(b.co_fondeo_tax) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_fondeo_tax_acum
  ,sum(b.co_other_cogs) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_other_cogs_acum
  ,sum(b.co_agreements) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_agreements_acum
  ,sum(b.rev_pix) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_pix_acum
  ,sum(b.co_pix) over (partition by a.campaign_id, a.user_id order by b.mob asc) as co_pix_acum
  ,sum(b.rev_interchange_fee) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_interchange_fee_acum
  ,sum(b.rev_revolving) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_revolving_acum
  ,sum(b.rev_punitorio) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_punitorio_acum
  ,sum(b.rev_parcelamento) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_parcelamento_acum
  ,sum(b.rev_withdrawal) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_withdrawal_acum
  ,sum(b.rev_overlimit) over (partition by a.campaign_id, a.user_id order by b.mob asc) as rev_overlimit_acum
  ,sum(b.meli_mais) over (partition by a.campaign_id, a.user_id order by b.mob asc) as meli_mais_acum
  ,lag(b.deuda,1) over (partition by a.campaign_id, a.user_id order by b.mob desc) - b.deuda as var_deuda_mob
  ,lag(b.deuda_over30,1) over (partition by a.campaign_id, a.user_id order by b.mob desc) - b.deuda_over30 as var_deuda_over30_mob
from `SBOX_CREDITS_SB.RBA_TC_MLB_DOWNSELL_BACKTEST_BAU_PL_1_PECASTANHO` a,
unnest([
   struct(0 as mob,   deuda_over30m0   as deuda_over30, deuda_m0   as deuda, tpv_m0   as tpv, rev_all_m0   as rev_all, co_fondeo_tax_m0   as co_fondeo_tax, co_other_cogs_m0   as co_other_cogs, co_agreements_m0   as co_agreements, rev_pix_m0   as rev_pix, co_pix_m0   as co_pix, rev_interchange_fee_m0   as rev_interchange_fee, rev_revolving_fixed_m0   as rev_revolving, rev_punitorio_fixed_m0   as rev_punitorio, rev_parcelamento_fixed_m0   as rev_parcelamento, rev_withdrawal_fixed_m0   as rev_withdrawal, rev_overlimit_fixed_m0   as rev_overlimit, deuda_financiada_m0    as deuda_financiada, meli_mais_m0  as meli_mais, porc_prevision_m0 as porc_prevision, dpd_m0 as dpd)
  ,struct(1 as mob,   deuda_over30m1   as deuda_over30, deuda_m1   as deuda, tpv_m1   as tpv, rev_all_m1   as rev_all, co_fondeo_tax_m1   as co_fondeo_tax, co_other_cogs_m1   as co_other_cogs, co_agreements_m1   as co_agreements, rev_pix_m1   as rev_pix, co_pix_m1   as co_pix, rev_interchange_fee_m1   as rev_interchange_fee, rev_revolving_fixed_m1   as rev_revolving, rev_punitorio_fixed_m1   as rev_punitorio, rev_parcelamento_fixed_m1   as rev_parcelamento, rev_withdrawal_fixed_m1   as rev_withdrawal, rev_overlimit_fixed_m1   as rev_overlimit, deuda_financiada_m1    as deuda_financiada, meli_mais_m1  as meli_mais, porc_prevision_m1 as porc_prevision, dpd_m1 as dpd)
  ,struct(2 as mob,   deuda_over30m2   as deuda_over30, deuda_m2   as deuda, tpv_m2   as tpv, rev_all_m2   as rev_all, co_fondeo_tax_m2   as co_fondeo_tax, co_other_cogs_m2   as co_other_cogs, co_agreements_m2   as co_agreements, rev_pix_m2   as rev_pix, co_pix_m2   as co_pix, rev_interchange_fee_m2   as rev_interchange_fee, rev_revolving_fixed_m2   as rev_revolving, rev_punitorio_fixed_m2   as rev_punitorio, rev_parcelamento_fixed_m2   as rev_parcelamento, rev_withdrawal_fixed_m2   as rev_withdrawal, rev_overlimit_fixed_m2   as rev_overlimit, deuda_financiada_m2    as deuda_financiada, meli_mais_m2  as meli_mais, porc_prevision_m2 as porc_prevision, dpd_m2 as dpd)
  ,struct(3 as mob,   deuda_over30m3   as deuda_over30, deuda_m3   as deuda, tpv_m3   as tpv, rev_all_m3   as rev_all, co_fondeo_tax_m3   as co_fondeo_tax, co_other_cogs_m3   as co_other_cogs, co_agreements_m3   as co_agreements, rev_pix_m3   as rev_pix, co_pix_m3   as co_pix, rev_interchange_fee_m3   as rev_interchange_fee, rev_revolving_fixed_m3   as rev_revolving, rev_punitorio_fixed_m3   as rev_punitorio, rev_parcelamento_fixed_m3   as rev_parcelamento, rev_withdrawal_fixed_m3   as rev_withdrawal, rev_overlimit_fixed_m3   as rev_overlimit, deuda_financiada_m3    as deuda_financiada, meli_mais_m3  as meli_mais, porc_prevision_m3 as porc_prevision, dpd_m3 as dpd)
  ,struct(4 as mob,   deuda_over30m4   as deuda_over30, deuda_m4   as deuda, tpv_m4   as tpv, rev_all_m4   as rev_all, co_fondeo_tax_m4   as co_fondeo_tax, co_other_cogs_m4   as co_other_cogs, co_agreements_m4   as co_agreements, rev_pix_m4   as rev_pix, co_pix_m4   as co_pix, rev_interchange_fee_m4   as rev_interchange_fee, rev_revolving_fixed_m4   as rev_revolving, rev_punitorio_fixed_m4   as rev_punitorio, rev_parcelamento_fixed_m4   as rev_parcelamento, rev_withdrawal_fixed_m4   as rev_withdrawal, rev_overlimit_fixed_m4   as rev_overlimit, deuda_financiada_m4    as deuda_financiada, meli_mais_m4  as meli_mais, porc_prevision_m4 as porc_prevision, dpd_m4 as dpd)
  ,struct(5 as mob,   deuda_over30m5   as deuda_over30, deuda_m5   as deuda, tpv_m5   as tpv, rev_all_m5   as rev_all, co_fondeo_tax_m5   as co_fondeo_tax, co_other_cogs_m5   as co_other_cogs, co_agreements_m5   as co_agreements, rev_pix_m5   as rev_pix, co_pix_m5   as co_pix, rev_interchange_fee_m5   as rev_interchange_fee, rev_revolving_fixed_m5   as rev_revolving, rev_punitorio_fixed_m5   as rev_punitorio, rev_parcelamento_fixed_m5   as rev_parcelamento, rev_withdrawal_fixed_m5   as rev_withdrawal, rev_overlimit_fixed_m5   as rev_overlimit, deuda_financiada_m5    as deuda_financiada, meli_mais_m5  as meli_mais, porc_prevision_m5 as porc_prevision, dpd_m5 as dpd)
  ,struct(6 as mob,   deuda_over30m6   as deuda_over30, deuda_m6   as deuda, tpv_m6   as tpv, rev_all_m6   as rev_all, co_fondeo_tax_m6   as co_fondeo_tax, co_other_cogs_m6   as co_other_cogs, co_agreements_m6   as co_agreements, rev_pix_m6   as rev_pix, co_pix_m6   as co_pix, rev_interchange_fee_m6   as rev_interchange_fee, rev_revolving_fixed_m6   as rev_revolving, rev_punitorio_fixed_m6   as rev_punitorio, rev_parcelamento_fixed_m6   as rev_parcelamento, rev_withdrawal_fixed_m6   as rev_withdrawal, rev_overlimit_fixed_m6   as rev_overlimit, deuda_financiada_m6    as deuda_financiada, meli_mais_m6  as meli_mais, porc_prevision_m6 as porc_prevision, dpd_m6 as dpd)
  ,struct(7 as mob,   deuda_over30m7   as deuda_over30, deuda_m7   as deuda, tpv_m7   as tpv, rev_all_m7   as rev_all, co_fondeo_tax_m7   as co_fondeo_tax, co_other_cogs_m7   as co_other_cogs, co_agreements_m7   as co_agreements, rev_pix_m7   as rev_pix, co_pix_m7   as co_pix, rev_interchange_fee_m7   as rev_interchange_fee, rev_revolving_fixed_m7   as rev_revolving, rev_punitorio_fixed_m7   as rev_punitorio, rev_parcelamento_fixed_m7   as rev_parcelamento, rev_withdrawal_fixed_m7   as rev_withdrawal, rev_overlimit_fixed_m7   as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(8 as mob,   deuda_over30m8   as deuda_over30, deuda_m8   as deuda, tpv_m8   as tpv, rev_all_m8   as rev_all, co_fondeo_tax_m8   as co_fondeo_tax, co_other_cogs_m8   as co_other_cogs, co_agreements_m8   as co_agreements, rev_pix_m8   as rev_pix, co_pix_m8   as co_pix, rev_interchange_fee_m8   as rev_interchange_fee, rev_revolving_fixed_m8   as rev_revolving, rev_punitorio_fixed_m8   as rev_punitorio, rev_parcelamento_fixed_m8   as rev_parcelamento, rev_withdrawal_fixed_m8   as rev_withdrawal, rev_overlimit_fixed_m8   as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(9 as mob,   deuda_over30m9   as deuda_over30, deuda_m9   as deuda, tpv_m9   as tpv, rev_all_m9   as rev_all, co_fondeo_tax_m9   as co_fondeo_tax, co_other_cogs_m9   as co_other_cogs, co_agreements_m9   as co_agreements, rev_pix_m9   as rev_pix, co_pix_m9   as co_pix, rev_interchange_fee_m9   as rev_interchange_fee, rev_revolving_fixed_m9   as rev_revolving, rev_punitorio_fixed_m9   as rev_punitorio, rev_parcelamento_fixed_m9   as rev_parcelamento, rev_withdrawal_fixed_m9   as rev_withdrawal, rev_overlimit_fixed_m9   as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(10 as mob,  deuda_over30m10  as deuda_over30, deuda_m10  as deuda, tpv_m10  as tpv, rev_all_m10  as rev_all, co_fondeo_tax_m10  as co_fondeo_tax, co_other_cogs_m10  as co_other_cogs, co_agreements_m10  as co_agreements, rev_pix_m10  as rev_pix, co_pix_m10  as co_pix, rev_interchange_fee_m10  as rev_interchange_fee, rev_revolving_fixed_m10  as rev_revolving, rev_punitorio_fixed_m10  as rev_punitorio, rev_parcelamento_fixed_m10  as rev_parcelamento, rev_withdrawal_fixed_m10  as rev_withdrawal, rev_overlimit_fixed_m10  as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(11 as mob,  deuda_over30m11  as deuda_over30, deuda_m11  as deuda, tpv_m11  as tpv, rev_all_m11  as rev_all, co_fondeo_tax_m11  as co_fondeo_tax, co_other_cogs_m11  as co_other_cogs, co_agreements_m11  as co_agreements, rev_pix_m11  as rev_pix, co_pix_m11  as co_pix, rev_interchange_fee_m11  as rev_interchange_fee, rev_revolving_fixed_m11  as rev_revolving, rev_punitorio_fixed_m11  as rev_punitorio, rev_parcelamento_fixed_m11  as rev_parcelamento, rev_withdrawal_fixed_m11  as rev_withdrawal, rev_overlimit_fixed_m11  as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(12 as mob,  deuda_over30m12  as deuda_over30, deuda_m12  as deuda, tpv_m12  as tpv, rev_all_m12  as rev_all, co_fondeo_tax_m12  as co_fondeo_tax, co_other_cogs_m12  as co_other_cogs, co_agreements_m12  as co_agreements, rev_pix_m12  as rev_pix, co_pix_m12  as co_pix, rev_interchange_fee_m12  as rev_interchange_fee, rev_revolving_fixed_m12  as rev_revolving, rev_punitorio_fixed_m12  as rev_punitorio, rev_parcelamento_fixed_m12  as rev_parcelamento, rev_withdrawal_fixed_m12  as rev_withdrawal, rev_overlimit_fixed_m12  as rev_overlimit, null                   as deuda_financiada, null          as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(-1 as mob,  deuda_over30m_1  as deuda_over30, deuda_m_1  as deuda, tpv_m_1  as tpv, rev_all_m_1  as rev_all, co_fondeo_tax_m_1  as co_fondeo_tax, co_other_cogs_m_1  as co_other_cogs, co_agreements_m_1  as co_agreements, rev_pix_m_1  as rev_pix, co_pix_m_1  as co_pix, rev_interchange_fee_m_1  as rev_interchange_fee, rev_revolving_fixed_m_1  as rev_revolving, rev_punitorio_fixed_m_1  as rev_punitorio, rev_parcelamento_fixed_m_1  as rev_parcelamento, rev_withdrawal_fixed_m_1  as rev_withdrawal, rev_overlimit_fixed_m_1  as rev_overlimit, null                   as deuda_financiada, meli_mais_m_1 as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(-2 as mob,  deuda_over30m_2  as deuda_over30, deuda_m_2  as deuda, tpv_m_2  as tpv, rev_all_m_2  as rev_all, co_fondeo_tax_m_2  as co_fondeo_tax, co_other_cogs_m_2  as co_other_cogs, co_agreements_m_2  as co_agreements, rev_pix_m_2  as rev_pix, co_pix_m_2  as co_pix, rev_interchange_fee_m_2  as rev_interchange_fee, rev_revolving_fixed_m_2  as rev_revolving, rev_punitorio_fixed_m_2  as rev_punitorio, rev_parcelamento_fixed_m_2  as rev_parcelamento, rev_withdrawal_fixed_m_2  as rev_withdrawal, rev_overlimit_fixed_m_2  as rev_overlimit, null                   as deuda_financiada, meli_mais_m_2 as meli_mais, null              as porc_prevision, null   as dpd)
  ,struct(-3 as mob,  deuda_over30m_3  as deuda_over30, deuda_m_3  as deuda, tpv_m_3  as tpv, rev_all_m_3  as rev_all, co_fondeo_tax_m_3  as co_fondeo_tax, co_other_cogs_m_3  as co_other_cogs, co_agreements_m_3  as co_agreements, rev_pix_m_3  as rev_pix, co_pix_m_3  as co_pix, rev_interchange_fee_m_3  as rev_interchange_fee, rev_revolving_fixed_m_3  as rev_revolving, rev_punitorio_fixed_m_3  as rev_punitorio, rev_parcelamento_fixed_m_3  as rev_parcelamento, rev_withdrawal_fixed_m_3  as rev_withdrawal, rev_overlimit_fixed_m_3  as rev_overlimit, null                   as deuda_financiada, meli_mais_m_3 as meli_mais, null              as porc_prevision, null   as dpd)
]) b
;

