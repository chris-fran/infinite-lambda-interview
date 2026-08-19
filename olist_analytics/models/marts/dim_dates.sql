with

spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2016-09-01' as date)",
        end_date="cast('2018-11-01' as date)"
    ) }}

),

final as (

    select
        date_day,
        extract(year from date_day) as year_number,
        extract(quarter from date_day) as quarter_number,
        extract(month from date_day) as month_number,
        extract(dayofweekiso from date_day) - 1  as day_of_week,-- Monday first
        case extract(dayofweekiso from date_day) - 1
            when 0 then 'Monday'
            when 1 then 'Tuesday'
            when 2 then 'Wednesday'
            when 3 then 'Thursday'
            when 4 then 'Friday'
            when 5 then 'Saturday'
            when 6 then 'Sunday'
        end as day_name,
        to_char(date_day, 'MMMM') as month_name,
        to_char(date_day, 'MON') as month_name_abbreviated,
        to_char(date_day, 'DY') as day_name_abbreviated,
        extract(year from date_day) || '-Q' || extract(quarter from date_day) as year_quarter_label,
        to_char(date_day, 'YYYY-MM') as year_month_label

    from spine

)

select * from final