select 
    customer_id, 
    customer_unique_id, 
    cast(customer_zip_code_prefix as varchar) as zip_code_prefix
from {{ source('olist_raw', 'customers') }}