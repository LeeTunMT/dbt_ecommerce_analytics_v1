-- this model aim to agg the revenue of each product
with source as (
    select 
        product_id,
        order_id,
        price,
        freight_value,
        shipping_limit_at
    from {{ ref('stg_order_items')}})
),
agg_products as (
    select
        product_id,

        count(distinct order_id) as total_orders,
        count(*) as total_order_items,
        sum(price) as total_product_revenue,
        sum(freight_value) as total_freight_value,
        sum(price + freight_value) as total_gmv,
        avg(price) as avg_item_price,
        avg(freight_value) as avg_freight_value,
        max(price) as max_price,
        min(price) as min_price,
        min(shipping_limit_at) as first_shipping_limit_at,
        max(shipping_limit_at) as last_shipping_limit_at

    from source
    group by product_id
),
select * 
from agg_products