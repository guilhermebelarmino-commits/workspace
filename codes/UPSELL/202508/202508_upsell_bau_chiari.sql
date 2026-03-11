--- TABLA TC ---
create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_FUNNEL_CGALUCCIO` as
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

case when politica_mp.wanda__full_tc_active_days_since_qty < 120 then   'a.4m'
when politica_mp.wanda__full_tc_active_days_since_qty < 360 then        'b.4m-12m'
when politica_mp.wanda__full_tc_active_days_since_qty < 540 then        'c.12m-18m'
when politica_mp.wanda__full_tc_active_days_since_qty < 720 then        'd.18m-24m'
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


from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_9292285b-5f64-4ecc-aeb6-6ad75a931a67-1` killers

left join `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_9292285b-5f64-4ecc-aeb6-6ad75a931a67-1` politica_mp on killers.cus_cust_id = politica_mp.cus_cust_id

left join (select cus_cust_id, multip_nom_ups,limite_multiplicador,`CLUSTER`, pago_min_tc_teorico, nivel_uso_tc_teorico, pago_min_tc_ups, nivel_uso_tc_ups from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_53a042f5-8426-4147-9a9e-dff0bd616571-1`) politica_mktplace on killers.cus_cust_id = politica_mktplace.cus_cust_id

left join (select cus_cust_id, multip_nom_ups,limite_multiplicador,`CLUSTER`, pago_min_tc_teorico, nivel_uso_tc_teorico, pago_min_tc_ups, nivel_uso_tc_ups, rci_conjunta, wanda__teoric_rci_val from `meli-bi-data.SBOX_CREDITSSIGMA.CAMP_EOC_RK_POLICY_d6c81059-f815-4810-a182-7ae2b3adb95c-1`) politica_bau on killers.cus_cust_id = politica_bau.cus_cust_id

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

select count (cus_cust_id), count (distinct cus_cust_id), 
--case when uso_total > 0.6 then '>0.6' else '<0.6' end as uso_total,
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

and flag_vips_mktplace is false
and flag_vip_mp is false

and rating is true 
group by 3
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
            when nise_ordenado      in ('a.bronze') and rating_bhv_tc in ('C', 'D', 'E', 'F') then 15000
            when nise_ordenado      in ('b.silver') and rating_bhv_tc in ('A', 'B') then 25000
            when nise_ordenado      in ('b.silver') and rating_bhv_tc in ('C', 'D', 'E') then 20000
            when nise_ordenado      in ('c.gold') and rating_bhv_tc in ('A', 'B') then 30000
            when nise_ordenado      in ('c.gold') and rating_bhv_tc in ('C', 'D', 'E', 'F')then 25000
            when nise_ordenado      in ('d.platinum') and rating_bhv_tc in ('A', 'B')then 35000
            when nise_ordenado      in ('d.platinum') and rating_bhv_tc in ('C', 'D', 'E', 'F')then 30000
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
select count (cus_cust_id), 
case when uso_total > 0.6 then '>0.6' else '<0.6' end as uso_total,
from topes a
where 1=1
and flag_vip_mp is false
and flag_vips_mktplace is false
and flag_uso_total_bau is true
and flag_uso_total_10 is true
and flag_tope_conj_rci is false
and flag_tope_tc_rci is false
and killer_sellers is true
and platinum_12 is false 
group by 2
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
where limite_final > current_limit ;


create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` as
select * from bases


##### GC / GI ####
create or replace temp table tabla_filas as
select A.*,
row_number() over (partition by rating_bhv_tc order by current_limit asc) as fila,
FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` A;


create or replace temp table tabla_filas_gi as
select a.*,
        case when upsell = 'bau' then
            case when rating_bhv_tc in ('A') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('A') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('B') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('B') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('C') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('C') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('D') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('D') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('E') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('E') and mod(fila,20)<>0 then 'GI' 
            else 'nada'
            end 
        when upsell = 'vips mktplace' then
            case when rating_bhv_tc in ('A') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('A') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('B') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('B') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('C') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('C') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('D') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('D') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('E') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('E') and mod(fila,20)<>0 then 'GI' 
            else 'nada'
            end 
        when upsell = 'vips mp' then
            case when rating_bhv_tc in ('A') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('A') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('B') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('B') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('C') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('C') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('D') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('D') and mod(fila,20)<>0 then 'GI'
            when rating_bhv_tc in ('E') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('E') and mod(fila,20)<>0 then 'GI' 
            when rating_bhv_tc in ('F') and mod(fila,20)=0 then 'GC'
            when rating_bhv_tc in ('F') and mod(fila,20)<>0 then 'GI' 
            else 'nada'
            end 
        else 'nada'
        end as grupos
      from tabla_filas a;


create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` as
select * from tabla_filas_gi




###### INSERT #######

#### insert 1

--`meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CONJ_20250507_CGALUCCIO`

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'CAMBIO TOPE RCI', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---68271a7e-3741-4b73-945c-6aa0f94dd79e


CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'BAU', --5 Policy
'BAU', --6 Policy Category
'BAU', --7 Policy_subcategory
'CAMBIO TOPE RCI', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---7885b738-9448-46d7-a44b-beb5f232bc76



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
'68271a7e-3741-4b73-945c-6aa0f94dd79e' CAMPAIGN_ID,
'chgaluccio' AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GI%' and upsell = 'bau'
;



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
'7885b738-9448-46d7-a44b-beb5f232bc76' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'chgaluccio' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GC%' and upsell = 'bau'
;




---INSERT EN TABLA CARTERA
--GC

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

--
Select
'7885b738-9448-46d7-a44b-beb5f232bc76' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'CONTROL_1' as CAMPAIGN_GROUP,
NULL as  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID,
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT,
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC,
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(current_limit AS BIGINT) PREV_AMOUNT
FROM (
select * FROM  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GC%' and upsell = 'bau') A
;


--GI

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

-----
Select
'68271a7e-3741-4b73-945c-6aa0f94dd79e' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'IMPACTO_1' as CAMPAIGN_GROUP,
null  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID, 
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT, 
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC, --
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(A.current_limit AS BIGINT)  PREV_AMOUNT --

FROM (
select * from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GI%' and upsell = 'bau') A
;




###### INSERT #######

#### insert 1

--`meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CONJ_20250507_CGALUCCIO`

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'OTROS', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---b5b8fb3b-6da4-4a25-930d-28304e7a1aac


CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'OTROS', --6 Policy Category
'VIPs ML', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---2a77c0a1-a656-4eef-a1e8-cbcecca71450


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
'b5b8fb3b-6da4-4a25-930d-28304e7a1aac' CAMPAIGN_ID,
'chgaluccio' AUD_INS_USER
from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GI%' and upsell = 'vips mktplace'
;



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
'2a77c0a1-a656-4eef-a1e8-cbcecca71450' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'chgaluccio' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GC%' and upsell = 'vips mktplace'
;




---INSERT EN TABLA CARTERA
--GC

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

--
Select
'2a77c0a1-a656-4eef-a1e8-cbcecca71450' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'CONTROL_1' as CAMPAIGN_GROUP,
NULL as  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID,
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT,
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC,
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(current_limit AS BIGINT) PREV_AMOUNT
FROM (
select * FROM  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GC%' and upsell = 'vips mktplace') A
;


--GI

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

-----
Select
'b5b8fb3b-6da4-4a25-930d-28304e7a1aac' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'IMPACTO_1' as CAMPAIGN_GROUP,
null  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID, 
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT, 
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC, --
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(A.current_limit AS BIGINT)  PREV_AMOUNT --

FROM (
select * from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GI%' and upsell = 'vips mktplace') A
;





###### INSERT #######

#### insert 1

--`meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CONJ_20250507_CGALUCCIO`

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'OTROS', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'GESTION', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'GESTION' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---5e68cb40-914c-426a-b53d-d51e3001a2fb

CALL`meli-bi-data.SBOX_CREDITS_SB.SP_INSERT_CAMPAIGN_INDEX` (
'MLB', --1 Sit_site_id
'IND', --2 Negocio
'TC FULL', --3 Product_desc
'UPSELL', -- 4 Campaign_type
'TEST EXPOSICION', --5 Policy
'OTROS', --6 Policy Category
'VIPs MP', --7 Policy_subcategory
'N/A', --8 Policy_description
'CONTROL', --9 Campaign_group
'ESTRATEGIA CONJUNTA' --10 Campaign_group_desc
);

--CHECK
select * from `meli-bi-data.SBOX_CREDITS_SB.CRD_VU_CAMPAIGN_INDEX` where sit_site_id = 'MLB'and CAMPAIGN_GROUP = 'CONTROL' AND AUD_INS_USER = 'chiara.cgaluccio@mercadolibre.com'
---43e4d02c-2697-4e6c-9ed2-8a1f2753951e


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
'5e68cb40-914c-426a-b53d-d51e3001a2fb' CAMPAIGN_ID,
'chgaluccio' AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GI%' and upsell = 'vips mp'
;



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
'43e4d02c-2697-4e6c-9ed2-8a1f2753951e' CAMPAIGN_ID,
CASE WHEN grupos = 'GC' THEN TRUE ELSE FALSE END AS CAMPAIGN_CONTROL_GROUP,
 'chgaluccio' AS AUD_INS_USER
from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO`
where grupos like '%GC%' and upsell = 'vips mp'
;




---INSERT EN TABLA CARTERA
--GC

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

--
Select
'43e4d02c-2697-4e6c-9ed2-8a1f2753951e' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'CONTROL_1' as CAMPAIGN_GROUP,
NULL as  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID,
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT,
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC,
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(current_limit AS BIGINT) PREV_AMOUNT
FROM (
select * FROM  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GC%' and upsell = 'vips mp') A
;


--GI

INSERT INTO `SBOX_CREDITS_SB.RBA_TC_CAMPAIGN_CARTERA`  
(
CAMPAIGN_ID,
SIT_SITE_ID,
PRODUCT,
PRODUCT_ID,
ACTIONABLE_NAME,
CAMPAIGN_GROUP,
PROP_ID,
CUS_CUST_ID,
ACTIONABLE_DTTM,
AMOUNT,
RATING,
RATING_CH_TC,
RATING_CH_TC_SCR,
MODELO_CH_CC,
RATING_CH_CC,
MODELO_BHV_CC,
RATING_BHV_CC,
RATING_ADP_CC,
PORC_USO_CC,
LINEA_CC,
PLAZO_CC,
PORC_USO_TC,
LIMITE_TC,
PORC_PAGO_MIN,
MONTO_DISPO_CC,
PRESUMED_INCOME,
FLAG_MERCHANT,
RCI_CONCEPTUAL,
RCI_REAL,
SEGMENT_SELLER,
LYL_LEVEL_NUMER,
NUMERO_ENCENDIDO,
FLAG_MP,
FLAG_SCR,
LIMITE_TC_INFERIDO,
FLAG_IN_WHOW,
AUD_INS_DTTM,
RATING_BHV_TC,
RATING_UPSELL_TC,
PORC_USO_TC_REAL,
PORC_PAGO_MIN_REAL,
PORC_USO_CC_REAL,
PLAZO_PROMEDIO_REAL,
PREV_AMOUNT
)

-----
Select
'5e68cb40-914c-426a-b53d-d51e3001a2fb' as CAMPAIGN_ID,
'MLB' as SIT_SITE_ID,
'TC' as PRODUCT,
1 as PRODUCT_ID,
'CCARD_UPSELL' as ACTIONABLE_NAME,
'IMPACTO_1' as CAMPAIGN_GROUP,
null  PROP_ID, 
A.CUS_CUST_ID as CUS_CUST_ID, 
datetime '2025-08-05 00:00:00.000000'as ACTIONABLE_DTTM, 
CAST(limite_final AS BIGINT) as AMOUNT, 
NULL RATING,
NULL RATING_CH_TC, --- 
NULL RATING_CH_TC_SCR, --
NULL MODELO_CH_CC, -- 
NULL RATING_CH_CC, -- 
NULL MODELO_BHV_CC, -- 
NULL RATING_BHV_CC, -- 
NULL RATING_ADP_CC, --
NULL PORC_USO_CC, --
NULL LINEA_CC, --
NULL PLAZO_CC, --? 
NULL PORC_USO_TC,
NULL LIMITE_TC,
NULL PORC_PAGO_MIN,
--CAST(A.NIVEL_USO_TC_UPS AS BIGINT) PORC_USO_TC, --
--CAST(A.LIMITE_ACTUAL AS BIGINT) LIMITE_TC, -- 
--CAST(A.PAGO_MIN_TC_UPS AS BIGINT) PORC_PAGO_MIN ,  -- 
NULL monto_dispo_cc , --
NULL PRESUMED_INCOME , --
NULL FLAG_MERCHANT, -- 
NULL RCI_CONCEPTUAL, --
NULL RCI_REAL, --
NULL SEGMENT_SELLER,
NULL LYL_LEVEL_NUMER,
NULL NUMERO_ENCENDIDO, --
NULL FLAG_MP,
NULL FLAG_SCR,
NULL LIMITE_TC_INFERIDO,
NULL FLAG_IN_WHOW, --- 
current_datetime() as AUD_INS_DTTM,
A.rating_bhv_tc AS RATING_BHV_TC, --
A.rating_upsell_tc AS RATING_UPSELL_TC, 
NULL PORC_USO_TC_REAL,
NULL PORC_PAGO_MIN_REAL,
NULL PORC_USO_CC_REAL,
NULL PLAZO_PROMEDIO_REAL,
CAST(A.current_limit AS BIGINT)  PREV_AMOUNT --

FROM (
select * from  `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` a
where grupos like '%GI%' and upsell = 'vips mp') A
;
