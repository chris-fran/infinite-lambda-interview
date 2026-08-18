with

source as (

    select * from {{ source('olist_raw', 'orders' ) }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        convert_timezone('America/Sao_Paulo', 'UTC', order_purchase_timestamp) as order_purchase_timestamp,
        convert_timezone('America/Sao_Paulo', 'UTC', order_approved_at) as order_approved_at,
        convert_timezone('America/Sao_Paulo', 'UTC', order_delivered_carrier_date) as order_delivered_carrier_date,
        convert_timezone('America/Sao_Paulo', 'UTC', order_delivered_customer_date) as order_delivered_customer_date,
        convert_timezone('America/Sao_Paulo', 'UTC', order_estimated_delivery_date) as order_estimated_delivery_date,
        loaded_at as order_loaded_at

    from source
)

select * from renamed
