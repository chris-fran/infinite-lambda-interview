with 

source as (

    select * from {{ source('olist_raw', 'order_items') }}

),

renamed as (

    select
        order_id, 
        order_item_id,
        product_id,
        seller_id,
        convert_timezone('America/Sao_Paulo', 'UTC', shipping_limit_date) as shipping_limit_date,
        price,
        freight_value
    
    from source

)

select * from renamed