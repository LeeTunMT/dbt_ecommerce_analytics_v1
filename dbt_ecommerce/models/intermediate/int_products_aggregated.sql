-- this model aim to agg the revenue of each product
with source as (
    select 
        product_id,
        price,
        freight_value
    from {{ ref('stg_order_items')}})
),
agg_products as (
    select
        product_id,
        sum(price) as total_goods_revenue
        sum(freight_value) as total_freight_revenue
    from source
    group by product_id
),
select * 
from agg_products