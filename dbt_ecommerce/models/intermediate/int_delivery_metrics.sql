-- Đầu ra: Tính toán các khoảng thời gian (khoảng cách giữa lúc đặt hàng đến lúc giao cho đơn vị vận chuyển,
-- khoảng cách đến lúc khách nhận được). 
-- Tạo cờ hiệu (flag) is_late_delivery (Giao hàng trễ) bằng cách so sánh ngày giao thực tế với ngày dự kiến.
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
agg_metrics as (
    select
        order_id, 
        max(customer_id),
        max(order_status),
        case 
            when order_estimated_delivery_at < order_delivered_customer_at then true
            else false
        end as is_late_delivery,
        
    from source
)

