with

stg_order_items as (

    select * from {{ ref('stg_olist_raw__order_items') }}

),

aggregated as (

    select
        order_id,
        sum(price) as price_sum,
        sum(freight_value) as freight_value_sum,
        sum(price + freight_value) as total_payable_amount,
        'BRL' as currency

    from stg_order_items

    group by 1

)

select * from aggregated
