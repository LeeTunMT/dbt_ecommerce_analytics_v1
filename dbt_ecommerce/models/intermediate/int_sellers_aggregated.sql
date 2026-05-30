with source as (
    select
        product_id,
        order_item_id,
        order_id,
        seller_id,
        price,
        freight_value,
        shipping_limit_at
    from {{ ref('stg_order_items')}}
),
agg_sellers as (
    select 
        seller_id,
        count(order_id) as total_orders_sold,
        sum(price) as total_price_sold,
        count(order_item_id) as total_items_sold
    from source 
    group by seller_id
),
select *
from agg_sellers