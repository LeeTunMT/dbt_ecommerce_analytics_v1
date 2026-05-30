-- total_goods_value, total_freight_value
with source as (
    select *
    from {{ ref('stg_order_items') }}
),
agg_order_items as (
    select 
        order_id,
        count(*) as total_items,
        max(seller_id) as seller_id,
        max(shipping_limit_date) as shipping_limit_date
        sum(price) as total_goods_value,
        sum(freight_value) as total_freight_value,
        sum(price + freight_value) as total_order_item_value,
        max(price) as max_price,
        min(price) as min_price,
        avg(price) as avg_price
    from source
    group by order_id
)
select * 
from agg_order_items