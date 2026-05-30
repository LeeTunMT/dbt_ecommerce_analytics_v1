-- Purpose:
-- Calculate delivery time metrics for each order.
-- Create a late delivery flag when the actual customer delivery date
-- is later than the estimated delivery date.

with source as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_at,
        order_approved_at,
        order_delivered_carrier_at,
        order_delivered_customer_at,
        order_estimated_delivery_at
    from {{ ref('stg_orders') }}
),

delivery_metrics as (
    select
        order_id,
        customer_id,
        order_status,

        timestamp_diff(order_approved_at, order_purchase_at, hour)
            as approval_time_hours,

        timestamp_diff(order_delivered_carrier_at, order_purchase_at, day)
            as purchase_to_carrier_days,

        case
            when order_status = 'delivered'
                 and order_delivered_customer_at is not null
                then timestamp_diff(order_delivered_customer_at, order_purchase_at, day)
            else null
        end as purchase_to_customer_delivery_days,

        case
            when order_status = 'delivered'
                 and order_delivered_customer_at is not null
                 and order_delivered_carrier_at is not null
                then timestamp_diff(order_delivered_customer_at, order_delivered_carrier_at, day)
            else null
        end as carrier_to_customer_delivery_days,

        case
            when order_status = 'delivered'
                 and order_delivered_customer_at is not null
                 and order_estimated_delivery_at is not null
                then timestamp_diff(order_delivered_customer_at, order_estimated_delivery_at, day)
            else null
        end as delivery_delay_days,

        case
            when order_status = 'delivered'
                 and order_delivered_customer_at is not null
                 and order_estimated_delivery_at is not null
                 and order_delivered_customer_at > order_estimated_delivery_at
                then true
            when order_status = 'delivered'
                 and order_delivered_customer_at is not null
                 and order_estimated_delivery_at is not null
                then false
            else null
        end as is_late_delivery,

        case
            when order_status = 'delivered' then true
            else false
        end as is_delivered,

        case
            when order_status = 'canceled' then true
            else false
        end as is_canceled,

        case
            when order_status = 'unavailable' then true
            else false
        end as is_unavailable,

        case
            when order_status in ('created', 'approved', 'invoiced', 'processing', 'shipped') then true
            else false 
        end as is_in_progress
        
    from source
)

select *
from delivery_metrics