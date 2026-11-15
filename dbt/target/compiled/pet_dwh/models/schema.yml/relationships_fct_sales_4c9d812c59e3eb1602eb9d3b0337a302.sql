
    
    

with child as (
    select customer_key as from_field
    from "warehouse"."dm"."fct_sales"
    where customer_key is not null
),

parent as (
    select customer_key as to_field
    from "warehouse"."dm"."dim_customer"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


