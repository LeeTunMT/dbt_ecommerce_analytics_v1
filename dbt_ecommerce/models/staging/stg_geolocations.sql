with source as (
    select * from {{ source('olist_raw', 'geolocation') }}
),

grouped as (
    select
        cast(geolocation_zip_code_prefix as varchar) as zip_code_prefix,
        -- take the average lat and lng to figure out the middle point of zipcode's area
        avg(geolocation_lat) as lat,
        avg(geolocation_lng) as lng,
        
        -- because 1 zip code can be write by many city's names like": Sao Paulo, São Paulo , 
        -- we take one name as representative. in this case i used Max()
        max(trim(lower(geolocation_city))) as city,
        max(upper(geolocation_state)) as state
        
    from source
    group by 1
)

select * from grouped