{{ 

    config(
        severity='warn'
    ) 
    
}}

select
    order_id,
    order_status,
    total_payable_amount,
    total_paid,
    abs(total_payable_amount - total_paid) as delta

from {{ ref('fct_orders') }}

where order_status not in ('unavailable', 'canceled', 'created')
  and abs(total_payable_amount - total_paid) > 0.01