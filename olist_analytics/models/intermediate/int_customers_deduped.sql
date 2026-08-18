with 

stg_customers as (

    select * from {{ ref('stg_olist_raw__customers') }}

),

stg_orders as (

    select * from {{ ref('stg_olist_raw__orders') }}

),

joined as (

    select
        stg_customers.customer_unique_id,
        stg_customers.customer_zip_prefix,
        stg_customers.customer_city, 
        stg_customers.customer_state,
        stg_customers.customer_first_name,
        stg_customers.customer_last_name,
        stg_customers.customer_email,
        stg_orders.order_purchase_timestamp

    from stg_customers

    left join stg_orders 
        on stg_orders.customer_id=stg_customers.customer_id

),

deduped_by_most_recent_purchase as (

    select
        customer_unique_id,
        customer_zip_prefix,
        customer_city, 
        customer_state,
        customer_first_name,
        customer_last_name,
        customer_email,
        DATE(order_purchase_timestamp) as customer_last_active_on

    from joined

    qualify row_number() over (
            partition by customer_unique_id
            order by order_purchase_timestamp desc 
    ) = 1
)

select * from deduped_by_most_recent_purchase
