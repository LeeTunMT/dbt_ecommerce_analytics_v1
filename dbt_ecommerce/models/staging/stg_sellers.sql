select
    seller_id,
    cast(seller_zip_code_prefix as varchar) as zip_code_prefix
from {{ source('raw_olist', 'sellers') }}