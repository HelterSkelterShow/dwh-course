select distinct seller_key, seller_email, seller_country
from {{ ref('stg_sales') }}
