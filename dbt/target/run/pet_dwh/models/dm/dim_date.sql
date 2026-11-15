
  
    

  create  table "warehouse"."dm"."dim_date__dbt_tmp"
  
  
    as
  
  (
    select distinct
    sale_date as date_key,
    extract(year from sale_date)::int as year,
    extract(month from sale_date)::int as month,
    date_trunc('month', sale_date)::date as month_start
from "warehouse"."stg"."stg_sales"
  );
  