
  
    

  create  table "warehouse"."dm"."dim_product__dbt_tmp"
  
  
    as
  
  (
    select distinct product_key, product_name, category, brand
from "warehouse"."stg"."stg_sales"
  );
  