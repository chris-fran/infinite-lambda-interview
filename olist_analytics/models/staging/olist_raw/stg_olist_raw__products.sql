with

source as (

    select * from {{ source('olist_raw', 'products') }}

),

renamed as (

    select
        product_id,
        product_category_name,
        product_name_lenght as product_name_length,
        product_description_lenght as product_description_length,
        product_photos_qty,
        round(product_weight_g / 453.592, 2) as product_weight_lb,
        {{ cm_to_in('product_length_cm') }} as product_length_in,
        {{ cm_to_in('product_height_cm') }} as product_height_in,
        {{ cm_to_in('product_width_cm') }} as product_width_in

    from source

)

select * from renamed
