select
    event_id as sale_id,
    dataset_id,
    dataset_id || ':' || (payload->>'sale_customer_id') as customer_key,
    dataset_id || ':' || (payload->>'sale_product_id') as product_key,
    dataset_id || ':' || (payload->>'sale_seller_id') as seller_key,
    md5(jsonb_build_array(dataset_id, payload->>'store_name',
        payload->>'store_location', payload->>'store_city',
        payload->>'store_country')::text) as store_key,
    make_date(
        split_part(payload->>'sale_date', '/', 3)::int,
        split_part(payload->>'sale_date', '/', 1)::int,
        split_part(payload->>'sale_date', '/', 2)::int) as sale_date,
    (payload->>'sale_quantity')::integer as quantity,
    (payload->>'sale_total_price')::numeric(14,2) as revenue,
    (payload->>'product_price')::numeric(14,2) as list_price,
    nullif(trim(payload->>'customer_first_name'), '') as first_name,
    nullif(trim(payload->>'customer_last_name'), '') as last_name,
    nullif(trim(payload->>'customer_country'), '') as customer_country,
    nullif(trim(payload->>'seller_email'), '') as seller_email,
    nullif(trim(payload->>'seller_country'), '') as seller_country,
    nullif(trim(payload->>'product_name'), '') as product_name,
    nullif(trim(payload->>'product_category'), '') as category,
    nullif(trim(payload->>'product_brand'), '') as brand,
    nullif(trim(payload->>'store_name'), '') as store_name,
    nullif(trim(payload->>'store_city'), '') as store_city,
    nullif(trim(payload->>'store_country'), '') as store_country
from "warehouse"."raw"."events"
where dataset_id = 'mock2'