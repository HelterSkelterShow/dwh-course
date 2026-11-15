
  
    

  create  table "warehouse"."dm"."dim_store__dbt_tmp"
  
  
    as
  
  (
    select distinct store_key, store_name, store_city, store_country
from "warehouse"."stg"."stg_sales"
  );
  