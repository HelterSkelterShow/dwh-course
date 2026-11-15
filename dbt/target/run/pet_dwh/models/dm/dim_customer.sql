
  
    

  create  table "warehouse"."dm"."dim_customer__dbt_tmp"
  
  
    as
  
  (
    select distinct customer_key, first_name, last_name, customer_country
from "warehouse"."stg"."stg_sales"
  );
  