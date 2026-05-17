select
    cast(geolocation_zip_code_prefix as integer) as geolocation_zip_code_prefix,
    cast(geolocation_lat as float) as geolocation_lat,
    cast(geolocation_lng as float) as geolocation_lng,
    geolocation_city,
    geolocation_state 
from {{ source('olist_raw', 'geolocations') }}
