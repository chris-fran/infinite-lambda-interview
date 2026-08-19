{{

    config(
        materialized='incremental',
        unique_key=['order_id', 'order_item_id'],
        incremental_strategy='merge'
    )

}}

with

stg_olist_raw_order_items as (

    select * from {{ ref('stg_olist_raw__order_items') }}

),

stg_olist_raw_orders as (

    select * from {{ ref('stg_olist_raw__orders') }}

),

joined as (

    select
        stg_olist_raw_order_items.order_id,
        stg_olist_raw_order_items.order_item_id,
        stg_olist_raw_order_items.product_id,
        stg_olist_raw_order_items.seller_id,
        stg_olist_raw_order_items.shipping_limit_date,
        stg_olist_raw_order_items.price,
        stg_olist_raw_order_items.freight_value,
        stg_olist_raw_orders.order_purchase_timestamp

    from stg_olist_raw_order_items

    inner join stg_olist_raw_orders
        on stg_olist_raw_order_items.order_id = stg_olist_raw_orders.order_id

    {% if is_incremental() %}

    where
        stg_olist_raw_orders.order_purchase_timestamp > (
            select dateadd('day', -3, max(fct_order_items_existing.order_purchase_timestamp))
            from {{ this }} as fct_order_items_existing
        )

    {% endif %}

)

select * from joined
