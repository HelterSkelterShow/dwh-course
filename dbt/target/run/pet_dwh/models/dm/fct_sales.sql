
  
    

  create  table "warehouse"."dm"."fct_sales__dbt_tmp"
  
  
    as
  
  (
    select s.sale_id, s.sale_date as date_key,
       c.customer_key, p.product_key, e.seller_key, t.store_key,
       s.quantity, s.revenue, s.list_price
from "warehouse"."stg"."stg_sales" s
join "warehouse"."dm"."dim_customer" c using (customer_key)
join "warehouse"."dm"."dim_product" p using (product_key)
join "warehouse"."dm"."dim_seller" e using (seller_key)
join "warehouse"."dm"."dim_store" t using (store_key)
join "warehouse"."dm"."dim_date" d on s.sale_date = d.date_key
  );
  