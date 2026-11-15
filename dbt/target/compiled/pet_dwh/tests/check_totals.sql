-- Ноль строк означает успех. Пустой источник тоже ошибка.
with s as (
    select count(*) n, sum(quantity) q, sum(revenue) r
    from "warehouse"."stg"."stg_sales"
), f as (
    select count(*) n, sum(quantity) q, sum(revenue) r
    from "warehouse"."dm"."fct_sales"
), b as (
    select count(*) n, sum(quantity) q, sum(revenue) r
    from "warehouse"."dm"."bi_sales"
)
select * from s, f, b
where s.n = 0 or s.n <> f.n or f.n <> b.n
   or s.q is distinct from f.q or f.q is distinct from b.q
   or s.r is distinct from f.r or f.r is distinct from b.r