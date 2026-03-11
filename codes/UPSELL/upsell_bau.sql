--- TABLA TC ---

create or replace temp table tabla_tc as

select 

killers.cus_cust_id,

rk_2799 tc_aceptada, 
rk_2923 tc_full,
rk_2798 tc_activa,

case when rk_10058 is true
and rk_2791 is true
and rk_3500 is true
and rk_2511 is true
and rk_2794 is true
and rk_2795 is true
and rk_2796 is true
and rk_1970 is true
and rk_2038 is true
and rk_84322 is true
and rk_1971 is true
and rk_2797 is true
and rk_2041 is true
then true else false end as reglas_duras,

rk_5100 rating_externo_g,

rk_5099 ultimo_score_bhv, 
rk_5104 pago_total, 

case when rk_2914 is true 
--and rk_2913 is true 
and rk_2915 is true 
and rk_2916 is true 
and rk_2917 is true
and rk_2920 is true 
then true else false end as encendido_cc,

case when rk_40948 is true
and rk_40946 is true 
and rk_40945 is true 
then true else false end as convivencia_sellers,

rk_2918 ultimo_downsell,

rk_19245 pix_apuestas,
rk_81540 pix_new,
rk_84820 killer_seguros,

case when rk_68881 is true
and rk_68882 is true
and rk_70603 is true 
then true else false end as regla_descanso,

case when (balance_amt/politica_mp.wanda__current_limit_ccard) > 0.1 then true 
else false 
end as flag_uso_total_10,

case
    when politica_mp.wanda__full_tc_active_days_since_qty < 360 then
        case
            when (balance_amt / politica_mp.wanda__current_limit_ccard) > 0.1 then true
            else false
        end
    when politica_mp.wanda__full_tc_active_days_since_qty < 540 then
        case
            when (balance_amt / politica_mp.wanda__current_limit_ccard) > 0.15 then true
            else false 
        end
    when politica_mp.wanda__full_tc_active_days_since_qty > 720 then
        case
            when (balance_amt / politica_mp.wanda__current_limit_ccard) > 0.2 then true
            else false
        end
    else false
end as flag_uso_total_bau,

rk_2931 antiguedad_minima_4m,
rk_31249 killer_sellers, 

rk_84818 flag_vip_mp,
rk_70253 flag_vips_mktplace,


case when (nise = 'PLATINUM' and politica_mp.wanda__full_tc_active_days_since_qty < 360) then true else false end as platinum_12,

case when politica_mp.wanda__full_tc_active_days_since_qty < 120 then 'a.4m'
when politica_mp.wanda__full_tc_active_days_since_qty < 360 then 'b.4m-12m'
when politica_mp.wanda__full_tc_active_days_since_qty < 540 then 'c.12m-18m'
when politica_mp.wanda__full_tc_active_days_since_qty < 720 then 'd.18m-24m'
else 'e.>24m' end as antiguedad,

-- nise e income
politica_mp.nise,

case when politica_mp.nise in ('BRONZE','SILVER') then 'a.Silver/Bronze' 
    when politica_mp.nise in ('GOLD', 'PLATINUM') then 'b.Gold/Plat'
    else 'c.Sin Nise' end as nise_agrupado,

case when politica_mp.nise = 'BRONZE' then 'a.bronze'
    when politica_mp.nise = 'SILVER' then 'b.silver'
    when politica_mp.nise = 'GOLD' then 'c.gold'
    when politica_mp.nise = 'PLATINUM' then 'd.platinum' end as nise_ordenado,

assumed_income_amt,

-- datos cc --
case when tabla_cc.borrower_id is not null then true
    else false end as flag_repeat,

case
    when tabla_cc.nuevo_rating_mxp_para_pricing is not null then tabla_cc.nuevo_rating_mxp_para_pricing
    else 'Sin Rating bhv'
end as rating_bhv_cc,

politica_mp.wanda__teoric_rci_val rci_cc, 

case 
    when tabla_cc.borrower_id is not null then 
        ((estres_cc_reciente = 1 and origino_post_estress_cc in ('a.No origino post estres')) or estres_cc_reciente = 0)
    else true
end as convivencia_cc,

-- rating --
case
    when politica_mp.internal_rating_behavior_tc is not null then politica_mp.internal_rating_behavior_tc
    else 'Sin Rating bhv TC'
end as rating_bhv_tc,
politica_mp.internal_rating_upsell_tc rating_upsell_tc,

-- multiplicadores nominales --
case when 
    -- vip_mp
        rk_84818 is true then politica_mp.multip_nom_ups   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.multip_nom_ups
    else 
    -- bau
        politica_bau.multip_nom_ups 
    
    end as multiplicador_nominal,

case when 
    -- vip_mp
        rk_84818 is true then politica_mp.limite_multiplicador   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.limite_multiplicador
    else 
    -- bau
        politica_bau.limite_multiplicador 
    
    end as limite_multiplicador,


-- limites --
politica_mp.wanda__current_limit_ccard current_limit,
case when politica_mp.wanda__ccard_ovc_add_percentage > 0 then true
    else false 
end as flag_overlimit,

case when limite_consumo is null then 0 
    else limite_consumo 
end as limite_cc,

(case when limite_consumo is null then 0 
    else limite_consumo 
end + politica_mp.wanda__current_limit_ccard) limite_total,

-- pago min y uso --
case when 
    -- vip_mp
        rk_84818 is true then politica_mp.pago_min_tc_teorico   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.pago_min_tc_teorico
    else 
    -- bau
        politica_bau.pago_min_tc_teorico 
    
    end as pago_min_tc_teorico,

case when 
    -- vip_mp
        rk_84818 is true then politica_mp.pago_min_tc_ups   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.pago_min_tc_ups
    else 
    -- bau
        politica_bau.pago_min_tc_ups 
    
    end as pago_min_tc,

case when 
    -- vip_mp
        rk_84818 is true then politica_mp.nivel_uso_tc_teorico   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.nivel_uso_tc_teorico
    else 
    -- bau
        politica_bau.nivel_uso_tc_teorico 
    
    end as nivel_uso_tc_teorico,

case when 
    -- vip_mp
        rk_84818 is true then politica_mp.nivel_uso_tc_ups   
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.nivel_uso_tc_ups
    else 
    -- bau
        politica_bau.nivel_uso_tc_ups 
    
    end as nivel_uso_tc,

balance_amt/politica_mp.wanda__current_limit_ccard uso_total,


-- rci --
politica_mp.rci_conjunta rci_conjunta_pre,
(politica_mp.rci_conjunta - politica_mp.wanda__teoric_rci_val) rci_tc_pre_eoc,
rci_tc_pre_vu,

-- rating
case when 
    -- vip_mp
        rk_84818 is true then politica_mp.cluster > 0
    when 
    -- vips_mktplace
        rk_70253 is true then politica_mktplace.cluster > 0
    -- bau
    else 
        politica_bau.cluster > 0  
    
    end as rating,


from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_cdd08c99-de09-4766-8033-c2d584ff67eb-1` killers

left join `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_cf1f770b-11fb-46e8-b64a-da87b79a27b8-1` politica_mp on killers.cus_cust_id = politica_mp.cus_cust_id

left join (select cus_cust_id, multip_nom_ups,limite_multiplicador,`CLUSTER`, pago_min_tc_teorico, nivel_uso_tc_teorico, pago_min_tc_ups, nivel_uso_tc_ups from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_aad44b5c-6e3f-48ce-b7f6-c59a804e3fd8-1`) politica_mktplace on killers.cus_cust_id = politica_mktplace.cus_cust_id

left join (select cus_cust_id, multip_nom_ups,limite_multiplicador,`CLUSTER`, pago_min_tc_teorico, nivel_uso_tc_teorico, pago_min_tc_ups, nivel_uso_tc_ups, rci_conjunta, wanda__teoric_rci_val from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_cdd08c99-de09-4766-8033-c2d584ff67eb-1`) politica_bau on killers.cus_cust_id = politica_bau.cus_cust_id


left join 
    (select 
    borrower_id, 
    case when first_crd_ever_dt is not null then true 
    else false end as repeat_cc,
    estres_cc_reciente,
    nuevo_rating_mxp_para_pricing,
    origino_post_estress_cc
    from `meli-bi-data.SBOX_CREDITS_SB.users_posibles_base_consumers_upsell_conjunto` )tabla_cc on killers.cus_cust_id = tabla_cc.borrower_id

left join 
  (select 
  cus_cust_id,
  assumed_income_amt, 
  nise_tag
  from `meli-bi-data.WHOWNER.BT_VU_ASSUMED_INCOME` 
  where 1 = 1
  and valid_to_dt = '2099-12-31'
  and sit_site_id = 'MLB') income on income.cus_cust_id = killers.cus_cust_id

left join 
    (select  
    rci.cus_cust_id,
    sum(ifnull(rci.teoric_rci_val,0)) as rci_tc_pre_vu,
    from `meli-bi-data.WHOWNER.BT_VU_RCI` rci
    where rci.valid_to_dt = '2099-12-31' and rci.current_flag = true
    and crd_prod_def_type_sk in (3) 
    group by 1) rci_tc_tabla on killers.cus_cust_id = rci_tc_tabla.cus_cust_id

left join 
    (select 
    cus_cust_id, 
    balance_amt
    from `meli-bi-data.WHOWNER.BT_VU_CREDIT`
    where valid_to_dt >= '2099-12-31'
    and crd_prod_def_type_sk = 3
    and sit_site_id = 'MLB'
    and crd_credit_status in ('ACTIVE', 'OVERDUE')) credits on killers.cus_cust_id = credits.cus_cust_id

left join
  (select  
  rci.cus_cust_id,
  sum(ifnull(rci.crd_current_limit,0)) as limite_consumo,
  sum(ifnull(rci.teoric_rci_val,0)) as rci_cc
  from `meli-bi-data.WHOWNER.BT_VU_RCI` rci
  where rci.valid_to_dt = '2099-12-31' and rci.current_flag = true
  and crd_prod_def_type_sk in (1,2,10) 
  group by 1) rci_cc_tabla on killers.cus_cust_id = rci_cc_tabla.cus_cust_id 
;





--- TABLA PRIORIZACION ---

create or replace temp table priorizacion as

select a.*,

conv.CC conv_cc,
conv.TC conv_tc,

priorizacion.priorizacion,
priorizacion.priorizacion_detalle,

priorizacion.porc_CC porc_cc,
priorizacion.porc_TC porc_tc,

tope.nivel_riesgo nivel_riesgo_conjunto,
tope.rci_tope tope_conjunto,

--- si el usuario es act, el tope de cc es 0 y el tope de tc es el max rci conjunta
case when flag_repeat = true then tope.rci_tope * priorizacion.porc_CC
    else 0
    end as tope_cc,

case when flag_repeat = true then tope.rci_tope * priorizacion.porc_TC
    else tope.rci_tope
    end as tope_tc,

multi_max multiplicador_nominal_conjunto,
limite_total * multi_max limite_nominal_conjunto,
((limite_total * multi_max) - limite_total) aumento_nominal_conjunto,


--- aumento nominal tc: si el usuario es repeat: aumento nominal conjunto * porc tc repeat // si el usuario es act: aumento nominal conjunto
case when flag_repeat = true then ((limite_total * multi_max) - limite_total) * priorizacion.porc_TC
    else ((limite_total * multi_max) - limite_total)
    end as aumento_nominal_tc,

from tabla_tc a

--tabla que define cual es la priorizacion del usuario en base a las 5 variables

left join `SBOX_CREDITS_SB.RBA_MLB_TC_CC_CONVIVENCIA` conv on conv.cus_cust_id = a.cus_cust_id

--tabla con los topes conjuntos por politica

left join `meli-bi-data.SBOX_CREDITS_SB.BA_CC_MLB_PARAMETRIA_TOPES_CONJUNTOS_20250430_AGONZALEZ` tope
    on tope.rating_bhv_cc = a.rating_bhv_cc
    and tope.rating_bhv_tc = a.rating_bhv_tc
    and tope.cluster= (case when flag_vip_mp is true or flag_vips_mktplace is true then "VIP" else "BAU" end)

--si son repeat esta le miro esta parametrica de % 

left join `meli-bi-data.SBOX_CREDITS_SB.BA_CC_MLB_PARAMETRIA_PRIORIZACION_20250430_AGONZALEZ` priorizacion
    on priorizacion.nise_agrupado = a.nise_agrupado
    and priorizacion.CC = conv.CC 
    and priorizacion.TC = conv.TC     
;






## funnel primera parte ##

select count (cus_cust_id), count (distinct cus_cust_id), flag_repeat
from priorizacion 
where 1=1

-- killers que aplican a las 3 políticas
and tc_aceptada is true
and tc_full is true 
and tc_activa is true

and antiguedad_minima_4m is true
and reglas_duras is true
and ultimo_score_bhv is true
and pago_total is true

and convivencia_cc is true
and encendido_cc is true

and convivencia_sellers is true
and ultimo_downsell is true

and pix_apuestas is true
and pix_new is true
and killer_seguros is true 

and regla_descanso is true

--and flag_vips_mktplace is false
--and flag_vip_mp is false

and rating is true 

;





--- TABLA TOPES CONJUNTOS ---

create or replace temp table topes as

select

a.*,

-- killer rci conj > tope

case when rci_conjunta_pre >= tope_conjunto then true else false end as flag_tope_conj_rci,

-- calculo los % de distribucion en base al disponible de RCI (parto del otro producto y despues killeo los que se pasan por el mio)

greatest (tope_cc, rci_cc)/tope_conjunto porc_cc_disponible, 

(1- (greatest (tope_cc, rci_cc)/tope_conjunto)) porc_tc_disponible,

-- calculo los nuevos topes de RCI en base al disponible

tope_conjunto * (greatest (tope_cc, rci_cc)/tope_conjunto) tope_cc_disponible,

tope_conjunto * ((1- (greatest (tope_cc, rci_cc)/tope_conjunto))) tope_tc_disponible,

-- killer rci tc > tope_tc_disponible

case when rci_tc_pre_eoc >= (tope_conjunto * ((1- (greatest (tope_cc, rci_cc)/tope_conjunto)))) then true else false end as flag_tope_tc_rci,

(current_limit + aumento_nominal_tc) limite_nominal_tc,

case when 
    -- vip
        flag_vip_mp is true or flag_vips_mktplace is true then 
            case when nise_ordenado in ('a.bronze') and rating_bhv_tc in ('A', 'B') then 20000
            when nise_ordenado in ('a.bronze') and rating_bhv_tc in ('C', 'D', 'E', 'F') then 15000
            when nise_ordenado in ('b.silver') and rating_bhv_tc in ('A', 'B') then 25000
            when nise_ordenado in ('b.silver') and rating_bhv_tc in ('C', 'D', 'E') then 20000
            when nise_ordenado in ('c.gold') and rating_bhv_tc in ('A', 'B') then 30000
            when nise_ordenado in ('c.gold') and rating_bhv_tc in ('C', 'D', 'E', 'F')then 25000
            when nise_ordenado in ('d.platinum') and rating_bhv_tc in ('A', 'B')then 35000
            when nise_ordenado in ('d.platinum') and rating_bhv_tc in ('C', 'D', 'E', 'F')then 30000
            else null end
    else 
    -- bau
        case when nise_ordenado in ('a.bronze') and rating_bhv_tc in ('A', 'B') then 20000
            when nise_ordenado in ('a.bronze') and rating_bhv_tc in ('C', 'D', 'E') then 15000
            when nise_ordenado in ('b.silver') and rating_bhv_tc in ('A', 'B') then 25000
            when nise_ordenado in ('b.silver') and rating_bhv_tc in ('C', 'D', 'E') then 20000
            when nise_ordenado in ('c.gold') and rating_bhv_tc in ('A', 'B') then 27000
            when nise_ordenado in ('c.gold') and rating_bhv_tc in ('C', 'D', 'E')then 25000
            when nise_ordenado in ('d.platinum') and rating_bhv_tc in ('A', 'B')then 30000
            when nise_ordenado in ('d.platinum') and rating_bhv_tc in ('C', 'D', 'E')then 27000
            else null end

    end as limite_nominal_tc_interno,

-- limite rci: tope_tc_disponible * income / uso * pago_min = limite 

(((tope_conjunto * ((1- (greatest (tope_cc, rci_cc)/tope_conjunto)))) * assumed_income_amt) / (nivel_uso_tc * pago_min_tc)) limite_rci


from priorizacion a

where 1=1

-- killers que aplican a las 3 políticas
and tc_aceptada is true
and tc_full is true 
and tc_activa is true
and antiguedad_minima_4m is true
and reglas_duras is true
and ultimo_score_bhv is true
and pago_total is true

and convivencia_cc is true
and encendido_cc is true
and convivencia_sellers is true
and ultimo_downsell is true

and pix_apuestas is true
and pix_new is true
and killer_seguros is true 

and regla_descanso is true

and rating is true
;




## funnel segunda parte ##
select count (cus_cust_id)
from topes a
where 1=1
and flag_vip_mp is false
and flag_vips_mktplace is false
and flag_uso_total_bau is true
--and flag_uso_total_10 is true
and flag_tope_conj_rci is false
and flag_tope_tc_rci is false
;



--- TABLA LIMITES ---

create or replace temp table limite as

select

a.*,

case when round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2)  > limite_nominal_tc_interno then limite_nominal_tc_interno
   else round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2) end as limite_final,

case when round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2) > limite_nominal_tc then 'limite_nominal_tc'
    else
        case when round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2) = round (limite_multiplicador, -2) then 'limite_multiplicador'
            when round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2) = round (limite_rci,-2) then 'limite_rci'
            when round (least (limite_multiplicador, limite_rci, limite_nominal_tc), -2) = round (limite_nominal_tc,-2) then 'limite_nominal_tc'
            else 'otro_caso' 
            end
    end as origen_limite_final

from topes a
where 1=1
and flag_tope_conj_rci is false
and flag_tope_tc_rci is false;




--- TABLA BASES ---

create or replace temp table bases as

select

a.*,

case when ((limite_final - current_limit) >= 100 or limite_final >= current_limit * 0.1) then false else true end as flag_upsell_insuficiente, 

((limite_final * nivel_uso_tc * pago_min_tc) / assumed_income_amt) rci_tc_post,

(rci_cc + ((limite_final * nivel_uso_tc * pago_min_tc) / assumed_income_amt)) rci_conjunta_post

from (
--vips mp
    (select *,
    'vips mp' as upsell
    from limite
    where 1=1
    and flag_vip_mp is true 
    and killer_sellers is true
    and flag_uso_total_10 is true)
    union all
--vips mktplace
    (select *,
    'vips mktplace' as upsell
    from limite
    where 1=1
    and flag_vips_mktplace is true
    and flag_vip_mp is false
    and flag_uso_total_10 is true)
    union all
--bau
    (select *,
    'bau' as upsell
    from limite
    where 1=1
    and flag_vips_mktplace is false 
    and flag_vip_mp is false
    and platinum_12 is false 
    and killer_sellers is true
    and flag_uso_total_bau is true
    ) 
) a
where limite_final > current_limit

