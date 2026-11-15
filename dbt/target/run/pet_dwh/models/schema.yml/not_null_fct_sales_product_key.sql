
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_key
from "warehouse"."dm"."fct_sales"
where product_key is null



  
  
      
    ) dbt_internal_test