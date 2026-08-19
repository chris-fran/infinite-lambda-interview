{{

    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'    
    )

}}

with

stg_olist_raw_orders as (

    select * from {{ ref('stg_olist_raw__orders') }}

),

stg_olist_raw_customers as (

    select * from {{ ref('stg_olist_raw__customers') }}

),

stg_olist_raw_order_reviews as (

    select * from {{ ref('stg_olist_raw__order_reviews') }}

),

int_order_items_aggregated as (

    select * from {{ ref('int_order_items_aggregated') }}

),

int_order_payments_summed as (

    select * from {{ ref('int_order_payments_summed') }}

),

joined as (

    select
        stg_olist_raw_orders.order_id,
        stg_olist_raw_customers.customer_unique_id_hash,
        stg_olist_raw_orders.order_status,
        int_order_items_aggregated.price_sum,
        int_order_items_aggregated.freight_value_sum,
        int_order_items_aggregated.total_payable_amount,
        int_order_payments_summed.total_paid,
        int_order_items_aggregated.currency,
        stg_olist_raw_orders.order_purchase_timestamp,
        stg_olist_raw_orders.order_approved_at,
        stg_olist_raw_orders.order_delivered_carrier_date,
        stg_olist_raw_orders.order_delivered_customer_date,
        stg_olist_raw_orders.order_estimated_delivery_date,
        stg_olist_raw_orders.order_loaded_at,
        stg_olist_raw_order_reviews.review_score

    from stg_olist_raw_orders

    left join stg_olist_raw_customers
        on stg_olist_raw_orders.customer_id = stg_olist_raw_customers.customer_id

    left join int_order_items_aggregated
        on stg_olist_raw_orders.order_id = int_order_items_aggregated.order_id

    left join int_order_payments_summed
        on stg_olist_raw_orders.order_id = int_order_payments_summed.order_id

    left join stg_olist_raw_order_reviews
        on stg_olist_raw_orders.order_id = stg_olist_raw_order_reviews.order_id

    {% if is_incremental() %}

    where
        stg_olist_raw_orders.order_purchase_timestamp > (
            select dateadd('day', -3, max(fct_orders_existing.order_purchase_timestamp))
            from {{ this }} as fct_orders_existing
        )

    {% endif %}

)

select * from joined
