with

int_customers_deduped as (

    select * from {{ ref('int_customers_deduped') }}

),

int_geolocation_aggregated as (

    select * from {{ ref('int_geolocation_aggregated') }}

),

joined as (

    select
        int_customers_deduped.customer_unique_id_hash,
        int_customers_deduped.customer_zip_prefix,
        int_customers_deduped.customer_city,
        int_customers_deduped.customer_state,
        int_geolocation_aggregated.latitude_avg as customer_latitude,
        int_geolocation_aggregated.longitude_avg as customer_longitude,
        int_customers_deduped.customer_first_name,
        int_customers_deduped.customer_last_name,
        int_customers_deduped.customer_email,
        int_customers_deduped.customer_last_active_on

    from int_customers_deduped

    left join int_geolocation_aggregated
        on int_customers_deduped.customer_zip_prefix = int_geolocation_aggregated.geolocation_zip_prefix

)

select * from joined
