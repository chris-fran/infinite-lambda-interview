with

source as (

    select * from {{ source('olist_raw', 'customers') }}

),

renamed as (

    select
        customer_id,
        sha2(customer_unique_id) as customer_unique_id_hash,
        customer_zip_code_prefix as customer_zip_prefix,
        initcap(customer_city) as customer_city,
        customer_state,
        first_name as customer_first_name,
        last_name as customer_last_name,
        email as customer_email

    from source

)

select * from renamed
