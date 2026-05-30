with source as (
    select * 
    from {{ ref('stg_order_reviews') }}
),
metrics_agg as (
    select
        order_id,

        avg(review_score) as avg_review_score,
        count(*) as review_count,

        max(case
            when review_comment_message is not null then 1
            else 0
        end) as has_review_comment,

        min(review_creation_at) as first_review_created_at,
        max(review_answer_at) as last_review_answered_at

    from source
    group by order_id
),
select *
from metrics_agg
