with

stg_order_items as (

    select * from {{ ref('stg_olist_raw__order_items') }}

),

aggregated as (

    select 
        product_id,
        count(product_id) as units_sold,
        round(sum(price), 2) as product_revenue,
        round(avg(price), 2) as price_sold_avg,
        'BRL' as currency
    
    from stg_order_items

    group by 1

)

select * from aggregated
