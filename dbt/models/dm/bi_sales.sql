{{ config(materialized='view') }}
-- Плоское представление над звездой для Superset.
select f.sale_id, d.date_key as sale_date, d.year, d.month,
       d.month_start, p.product_name, p.category, p.brand,
       c.customer_country, e.seller_country,
       s.store_name, s.store_city, s.store_country,
       f.quantity, f.revenue, f.list_price
from {{ ref('fct_sales') }} f
join {{ ref('dim_date') }} d using (date_key)
join {{ ref('dim_product') }} p using (product_key)
join {{ ref('dim_customer') }} c using (customer_key)
join {{ ref('dim_seller') }} e using (seller_key)
join {{ ref('dim_store') }} s using (store_key)
