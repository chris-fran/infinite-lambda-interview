with

stg_olist_raw_products as (

    select * from {{ ref('stg_olist_raw__products') }}

),

int_product_sales_aggregated as (

    select * from {{ ref('int_product_sales_aggregated') }}

),

seed_product_category_name_translaction as (

    select * from {{ ref('product_category_name_translation') }}

),

joined as (

    select
        stg_olist_raw_products.product_id,
        coalesce(seed_product_category_name_translaction.product_category_name_english, 'n/a') as product_category_name,
        int_product_sales_aggregated.units_sold,
        int_product_sales_aggregated.product_revenue as product_revenue_total,
        stg_olist_raw_products.product_weight_lb,
        stg_olist_raw_products.product_length_in,
        stg_olist_raw_products.product_height_in,
        stg_olist_raw_products.product_width_in

    from stg_olist_raw_products

    left join int_product_sales_aggregated
        on stg_olist_raw_products.product_id = int_product_sales_aggregated.product_id

    left join seed_product_category_name_translaction
        on stg_olist_raw_products.product_category_name = seed_product_category_name_translaction.product_category_name

)

select * from joined
