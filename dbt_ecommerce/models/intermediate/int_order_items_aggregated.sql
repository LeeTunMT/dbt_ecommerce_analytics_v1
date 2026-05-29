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
        sum(freight_value) as total_freight_value
    from source
    group by order_id
)
select * 
from agg_order_items