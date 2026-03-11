##### GC / GI ####
create or replace temp table tabla_filas as
select 
  A.*except(fila, grupos),
  row_number() over (partition by rating_bhv_tc order by current_limit asc) as fila,
FROM `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_20250804_CGALUCCIO` A
WHERE cus_cust_id not in (
  select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_CARD_TO_CARD_ANALITICA_20250805_GUBELARMINO`
    union all
  select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_PISOS_MINIMOS_ANALITICA_20250805_GUBELARMINO`
    union all
  select cus_cust_id from `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_REACTIVATION_ANALITICA_20250805_GUBELARMINO` 
);


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


create or replace table `meli-bi-data.SBOX_CREDITS_SB.RBA_TC_MLB_UPSELL_BAU_VIP_20250805_GUBELARMINO` as
select * from tabla_filas_gi
