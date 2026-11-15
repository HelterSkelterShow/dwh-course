
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Для примера продажи положительные, возвратов нет.
-- ЗАМЕНИТЕ ДЛЯ СВОЕГО DATASET правила допустимых значений.
select * from "warehouse"."stg"."stg_sales"
where quantity is null or quantity >= 0
   or revenue is null or revenue < 0
   or list_price is null or list_price < 0
   or sale_date is null
   or customer_key is null or customer_key like '%:'
   or product_key is null or product_key like '%:'
   or seller_key is null or seller_key like '%:'
  
  
      
    ) dbt_internal_test