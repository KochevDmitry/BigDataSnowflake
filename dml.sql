
INSERT INTO dim_seller (first_name, last_name, email, country, postal_code)
SELECT DISTINCT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
FROM mock_data;


INSERT INTO dim_pet_types (type_name)
SELECT DISTINCT customer_pet_type
FROM mock_data;


INSERT INTO dim_pet_breed (type_id, breed_name)
SELECT pt.type_id, customer_pet_breed
FROM mock_data md
JOIN dim_pet_types pt ON pt.type_name = md.customer_pet_type
GROUP BY pt.type_id, customer_pet_breed;


INSERT INTO dim_pet (customer_id, type_id, breed_id, name)
SELECT DISTINCT md.id, pt.type_id, pb.breed_id, md.customer_pet_name
FROM mock_data md
JOIN dim_pet_types pt ON pt.type_name = md.customer_pet_type
JOIN dim_pet_breed pb ON pb.breed_name = md.customer_pet_breed;


INSERT INTO dim_customer (first_name, last_name, age, email, country, postal_code, pet_id)
SELECT DISTINCT ON (md.id) 
    md.customer_first_name, md.customer_last_name, md.customer_age,
    md.customer_email, md.customer_country, md.customer_postal_code, dp.pet_id
FROM mock_data md
JOIN dim_pet dp ON dp.name = md.customer_pet_name AND dp.customer_id = md.id;


INSERT INTO dim_supplier (name, contact, email, phone, address, city, country)
SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country
FROM mock_data;


INSERT INTO dim_category_product (category_name)
SELECT DISTINCT product_category
FROM mock_data;


INSERT INTO dim_brand_product (brand_name)
SELECT DISTINCT product_brand
FROM mock_data;


INSERT INTO dim_product (name, category_id, release_date, expiry_date, price, quantity, rating, reviews, weight, color, size, brand_id, material, description, supplier_id)
SELECT product_name, 
       (SELECT category_id FROM dim_category_product WHERE category_name = md.product_category LIMIT 1), 
       product_release_date, 
       product_expiry_date, 
       product_price, 
       product_quantity, 
       product_rating, 
       product_reviews, 
       product_weight, 
       product_color, 
       product_size, 
       (SELECT brand_id FROM dim_brand_product WHERE brand_name = md.product_brand LIMIT 1), 
       product_material, 
       product_description, 
       (SELECT supplier_id FROM dim_supplier WHERE name = md.supplier_name LIMIT 1)
FROM mock_data md;


INSERT INTO dim_store (name, location, city, state, country, phone, email)
SELECT DISTINCT store_name, store_location, store_city, store_state, store_country, store_phone, store_email
FROM mock_data;


INSERT INTO fact_sales (customer_id, product_id, seller_id, store_id, sale_date, quantity, total_price)
SELECT 
    (SELECT customer_id FROM dim_customer WHERE first_name = md.customer_first_name AND last_name = md.customer_last_name AND email = md.customer_email LIMIT 1),
    (SELECT product_id FROM dim_product WHERE name = md.product_name LIMIT 1),
    (SELECT seller_id FROM dim_seller WHERE first_name = md.seller_first_name AND last_name = md.seller_last_name AND email = md.seller_email LIMIT 1),
    (SELECT store_id FROM dim_store WHERE name = md.store_name AND city = md.store_city LIMIT 1),
    sale_date, 
    sale_quantity, 
    sale_total_price
FROM mock_data md;
