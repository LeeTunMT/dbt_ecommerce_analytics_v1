select 
    order_id, 
    cast(order_item_id as char) as order_item_id, 
    product_id, 
    seller_id, 
    cast(shipping_limit_date as timestamp) as shipping_limit_date, 
    cast(price as float) as price, 
    cast(freight_value as float) as freight_value

from {{ source('olist', 'order_items')}}