with

source as (

    select * from {{ source('olist_raw', 'order_reviews') }}

),

renamed as (

    select
        review_id,
        order_id,
        review_score,
        coalesce(review_comment_title, 'n/a') as review_comment_title,
        coalesce(review_comment_message, 'n/a') as review_comment_message,
        convert_timezone('America/Sao_Paulo', 'UTC', review_creation_date) as review_creation_date,
        convert_timezone('America/Sao_Paulo', 'UTC', review_answer_timestamp) as review_answer_timestamp

    from source
),

deduped as (

    select *
    from renamed
    qualify row_number() over (
        partition by order_id
        order by review_answer_timestamp desc
    ) = 1

)

select * from deduped
