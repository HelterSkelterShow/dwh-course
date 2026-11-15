select distinct store_key, store_name, store_city, store_country
from {{ ref('stg_sales') }}