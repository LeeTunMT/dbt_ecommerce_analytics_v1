-- 1 row is 1 order_id
-- count the total_payment_value, amount of unique payment methods,  ... 
with source as (
    select 
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    from {{ ref('stg_order_payments') }}

),
agg_order_payments as (
    select 
        order_id,
        max(payment_type) as most_payment_type,
        count(distinct payment_type) as total_payment_types,
        max(payment_installments) as max_installments,
        
        -- weighted average installments
        sum(payment_installments * payment_value)
            / nullif(sum(payment_value), 0)
            as weighted_avg_installments,
        sum(payment_value) as total_payment_value,
        count(*) as total_payment_segments
    from source
    group by order_id
)
select *
from agg_order_payments

-- most_payment_type is the payment method appear most 
-- total_payment_types is the total of payment methods
-- max_installments is the installment with the highest value among all installments
-- weighted_avg_installments is Weighted average number of installments, using payment_value as the weight.
-- Higher-value payments contribute more to the final average.

-- total_payment_value is total value of payment methods
-- total_payment_segments is total number of payment records/segments for each group