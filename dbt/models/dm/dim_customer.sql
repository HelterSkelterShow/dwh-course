select distinct customer_key, first_name, last_name, customer_country
from {{ ref('stg_sales') }}
