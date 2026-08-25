{% macro incremental_filter(source_timestamp_column, 
                             this_column='order_purchase_timestamp',
                             lookback_days=var('lookback_days', 3)) %}

{{ source_timestamp_column }} > ( 
    select dateadd('day', -{{ lookback_days }}, max(existing.{{ this_column }}))
    from {{ this }} as existing
) 

{% endmacro %}