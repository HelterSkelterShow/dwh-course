
  
    

  create  table "warehouse"."dm"."dim_seller__dbt_tmp"
  
  
    as
  
  (
    select distinct seller_key, seller_email, seller_country
from "warehouse"."stg"."stg_sales"
  );
  