create or replace table `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PL_2_PECASTANHO`
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
    ,deuda_m0
    ,deuda_m1
    ,deuda_m2
    ,deuda_m3
    ,deuda_m4
    ,deuda_m5
    ,deuda_m6
    ,tpv_m0
    ,tpv_m1
    ,tpv_m2
    ,tpv_m3
    ,tpv_m4
    ,tpv_m5
    ,tpv_m6
    ,rev_all_m0
    ,rev_all_m1
    ,rev_all_m2
    ,rev_all_m3
    ,rev_all_m4
    ,rev_all_m5
    ,rev_all_m6
    ,co_fondeo_tax_m0
    ,co_fondeo_tax_m1
    ,co_fondeo_tax_m2
    ,co_fondeo_tax_m3
    ,co_fondeo_tax_m4
    ,co_fondeo_tax_m5
    ,co_fondeo_tax_m6
    ,co_other_cogs_m0
    ,co_other_cogs_m1
    ,co_other_cogs_m2
    ,co_other_cogs_m3
    ,co_other_cogs_m4
    ,co_other_cogs_m5
    ,co_other_cogs_m6
    ,co_agreements_m0
    ,co_agreements_m1
    ,co_agreements_m2
    ,co_agreements_m3
    ,co_agreements_m4
    ,co_agreements_m5
    ,co_agreements_m6
    ,rev_pix_m0
    ,rev_pix_m1
    ,rev_pix_m2
    ,rev_pix_m3
    ,rev_pix_m4
    ,rev_pix_m5
    ,rev_pix_m6
    ,co_pix_m0
    ,co_pix_m1
    ,co_pix_m2
    ,co_pix_m3
    ,co_pix_m4
    ,co_pix_m5
    ,co_pix_m6
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
    ,dpd_m6)
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
  ,sum(b.meli_mais) over (partition by a.campaign_id, a.user_id order by b.mob asc) as meli_mais_acum
from `SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BACKTEST_BAU_PL_1_PECASTANHO` a,
unnest([
   struct(0 as mob, deuda_over30m0 as deuda_over30, deuda_m0 as deuda, tpv_m0 as tpv, rev_all_m0 as rev_all, co_fondeo_tax_m0 as co_fondeo_tax, co_other_cogs_m0 as co_other_cogs, co_agreements_m0 as co_agreements, rev_pix_m0 as rev_pix, co_pix_m0 as co_pix, deuda_financiada_m0 as deuda_financiada, meli_mais_m0 as meli_mais, porc_prevision_m0 as porc_prevision, dpd_m0 as dpd)
  ,struct(1 as mob, deuda_over30m1 as deuda_over30, deuda_m1 as deuda, tpv_m1 as tpv, rev_all_m1 as rev_all, co_fondeo_tax_m1 as co_fondeo_tax, co_other_cogs_m1 as co_other_cogs, co_agreements_m1 as co_agreements, rev_pix_m1 as rev_pix, co_pix_m1 as co_pix, deuda_financiada_m1 as deuda_financiada, meli_mais_m1 as meli_mais, porc_prevision_m1 as porc_prevision, dpd_m1 as dpd)
  ,struct(2 as mob, deuda_over30m2 as deuda_over30, deuda_m2 as deuda, tpv_m2 as tpv, rev_all_m2 as rev_all, co_fondeo_tax_m2 as co_fondeo_tax, co_other_cogs_m2 as co_other_cogs, co_agreements_m2 as co_agreements, rev_pix_m2 as rev_pix, co_pix_m2 as co_pix, deuda_financiada_m2 as deuda_financiada, meli_mais_m2 as meli_mais, porc_prevision_m2 as porc_prevision, dpd_m2 as dpd)
  ,struct(3 as mob, deuda_over30m3 as deuda_over30, deuda_m3 as deuda, tpv_m3 as tpv, rev_all_m3 as rev_all, co_fondeo_tax_m3 as co_fondeo_tax, co_other_cogs_m3 as co_other_cogs, co_agreements_m3 as co_agreements, rev_pix_m3 as rev_pix, co_pix_m3 as co_pix, deuda_financiada_m3 as deuda_financiada, meli_mais_m3 as meli_mais, porc_prevision_m3 as porc_prevision, dpd_m3 as dpd)
  ,struct(4 as mob, deuda_over30m4 as deuda_over30, deuda_m4 as deuda, tpv_m4 as tpv, rev_all_m4 as rev_all, co_fondeo_tax_m4 as co_fondeo_tax, co_other_cogs_m4 as co_other_cogs, co_agreements_m4 as co_agreements, rev_pix_m4 as rev_pix, co_pix_m4 as co_pix, deuda_financiada_m4 as deuda_financiada, meli_mais_m4 as meli_mais, porc_prevision_m4 as porc_prevision, dpd_m4 as dpd)
  ,struct(5 as mob, deuda_over30m5 as deuda_over30, deuda_m5 as deuda, tpv_m5 as tpv, rev_all_m5 as rev_all, co_fondeo_tax_m5 as co_fondeo_tax, co_other_cogs_m5 as co_other_cogs, co_agreements_m5 as co_agreements, rev_pix_m5 as rev_pix, co_pix_m5 as co_pix, deuda_financiada_m5 as deuda_financiada, meli_mais_m5 as meli_mais, porc_prevision_m5 as porc_prevision, dpd_m5 as dpd)
  ,struct(6 as mob, deuda_over30m6 as deuda_over30, deuda_m6 as deuda, tpv_m6 as tpv, rev_all_m6 as rev_all, co_fondeo_tax_m6 as co_fondeo_tax, co_other_cogs_m6 as co_other_cogs, co_agreements_m6 as co_agreements, rev_pix_m6 as rev_pix, co_pix_m6 as co_pix, deuda_financiada_m6 as deuda_financiada, meli_mais_m6 as meli_mais, porc_prevision_m6 as porc_prevision, dpd_m6 as dpd)
]) b
;