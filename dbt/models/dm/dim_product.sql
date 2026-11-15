select distinct product_key, product_name, category, brand
from {{ ref('stg_sales') }}