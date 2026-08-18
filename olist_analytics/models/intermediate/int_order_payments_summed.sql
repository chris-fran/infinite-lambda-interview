with

stg_order_payments as (

    select * from {{ ref('stg_olist_raw__order_payments') }}
),

aggregated as (

    select
        order_id,
        round(sum(payment_value), 2) as total_paid

    from stg_order_payments

    group by 1

)

select * from aggregated
