
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select list_price
from "warehouse"."dm"."fct_sales"
where list_price is null



  
  
      
    ) dbt_internal_test