select 
    review_id, 
    order_id, 
    cast(review_score as integer) as review_score, 
    review_comment_title, 
    review_comment_message, 
    date(review_creation_date) as review_creation_date, 
    cast(review_answer_timestamp as timestamp) as review_answer_timestamp
from {{ source('olist', 'order_reviews')}}
