with source as (
    select * from {{ source('olist_raw', 'products') }}
),

translation as (
    select * from {{ source('olist_raw', 'product_category_name_translation') }}
),

renamed as (
    select
        s.product_id,
        coalesce(t.product_category_name_english, s.product_category_name) as product_category_name,
        
        cast(s.product_name_lenght as integer) as product_name_length,
        cast(s.product_description_lenght as integer) as product_description_length,
        cast(s.product_photos_qty as integer) as product_photos_qty,
        cast(s.product_weight_g as float64) as product_weight_g,
        cast(s.product_length_cm as float64) as product_length_cm,
        cast(s.product_height_cm as float64) as product_height_cm,
        cast(s.product_width_cm as float64) as product_width_cm
    from source as s
    left join translation as t
        on s.product_category_name = t.product_category_name
)

select * from renamed