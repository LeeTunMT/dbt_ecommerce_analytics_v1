with orders as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_at
    from {{ ref('stg_orders') }}
),
order_paymenst_agg as (
    select
        order_id,
        most_payment_type,
        total_payment_value
        
    from {{ ref('int_order_payments_aggregated') }}
),
customer_agg as (
    select
        o.customer_id,
        count(distinct o.order_id) as total_orders,
        sum(case when o.order_status = 'delivered' then 1 else 0 end) as total_orders_delivered,
        sum(p.total_payment_value) as total_spent,
        avg(p.total_payment_value) as avg_order_value,

        max(p.most_payment_type) as most_payment_type,
        min(o.order_purchase_at) as first_order_at,
        max(o.order_purchase_at) as last_order_at,

        date_diff(max(o.order_purchase_at), min(o.order_purchase_at), day)
            as customer_lifetime_days

    from orders o
    left join order_paymenst_agg p
        on o.order_id = p.order_id
    group by o.customer_id
),

select * 
from customer_agg
