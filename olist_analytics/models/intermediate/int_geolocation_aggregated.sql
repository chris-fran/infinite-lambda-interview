with

stg_geolocation as (

    select * from {{ ref('stg_olist_raw__geolocation') }}

),

aggregated as (

    select 
        geolocation_zip_prefix,
        avg(geolocation_latitude) as latitude_avg,
        avg(geolocation_longitude) as longitude_avg      

    from stg_geolocation

    group by 1

)

select * from aggregated
