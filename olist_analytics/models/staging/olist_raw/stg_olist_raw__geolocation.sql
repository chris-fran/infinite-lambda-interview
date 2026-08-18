with

source as (

    select * from {{ source('olist_raw', 'geolocation') }}

),

renamed as (

    select
        geolocation_zip_code_prefix as geolocation_zip_prefix,
        geolocation_lat as geolocation_latitude,
        geolocation_lng as geolocation_longitude,
        initcap(geolocation_city) as geolocation_city, 
        geolocation_state
    
    from source

)

select * from renamed