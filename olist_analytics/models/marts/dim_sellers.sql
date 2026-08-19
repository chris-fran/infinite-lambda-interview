with

stg_olist_raw_sellers as (

    select * from {{ ref('stg_olist_raw__sellers') }}

),

int_geolocation_aggregated as (

    select * from {{ ref('int_geolocation_aggregated') }}

),

joined as (

    select
        stg_olist_raw_sellers.seller_id,
        stg_olist_raw_sellers.seller_zip_prefix,
        stg_olist_raw_sellers.seller_city,
        stg_olist_raw_sellers.seller_state,
        int_geolocation_aggregated.latitude_avg as seller_latitude,
        int_geolocation_aggregated.longitude_avg as seller_longitude

    from stg_olist_raw_sellers

    left join int_geolocation_aggregated
        on stg_olist_raw_sellers.seller_zip_prefix = int_geolocation_aggregated.geolocation_zip_prefix

)

select * from joined
