DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_seller CASCADE;
DROP TABLE IF EXISTS dim_pet CASCADE;
DROP TABLE IF EXISTS dim_pet_breed CASCADE;
DROP TABLE IF EXISTS dim_pet_types CASCADE;
DROP TABLE IF EXISTS dim_category_product CASCADE;
DROP TABLE IF EXISTS dim_brand_product CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_supplier CASCADE;
DROP TABLE IF EXISTS dim_store CASCADE;
--Измерение: Продавцы
CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

-- Измерение: Питомцы
CREATE TABLE dim_pet_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50)
);

CREATE TABLE dim_pet_breed (
    breed_id SERIAL PRIMARY KEY,
    type_id INT,
    breed_name VARCHAR(100),
    FOREIGN KEY (type_id) REFERENCES dim_pet_types(type_id)
);

CREATE TABLE dim_pet (
    pet_id SERIAL PRIMARY KEY,
    customer_id INT,
    type_id INT,
    breed_id INT,
    name VARCHAR(50),
    FOREIGN KEY (type_id) REFERENCES dim_pet_types(type_id),
    FOREIGN KEY (breed_id) REFERENCES dim_pet_breed(breed_id) 
);

-- Измерение: Покупатели
CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INT,
    email VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    pet_id INT,
    FOREIGN KEY (pet_id) REFERENCES dim_pet(pet_id)
);

-- Измерение: Поставщики
CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    address VARCHAR(150),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Измерение: Продукты
CREATE TABLE dim_category_product (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE dim_brand_product (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(50)
);

CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category_id INT,
    release_date DATE,
    expiry_date DATE,
    price DECIMAL(10, 2),
    quantity INT,
    rating DECIMAL(4, 2),
    reviews INT,
    weight DECIMAL(10, 2),
    color VARCHAR(30),
    size VARCHAR(20),
    brand_id INT,
    material VARCHAR(30),
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES dim_supplier(supplier_id), 
    FOREIGN KEY (category_id) REFERENCES dim_category_product(category_id), 
    FOREIGN KEY (brand_id) REFERENCES dim_brand_product(brand_id)
);

--Измерение: Магазины   
CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(100),
    state  VARCHAR(100),
    country VARCHAR(100),
    phone  VARCHAR(100),
    email  VARCHAR(100)
);

-- Таблица фактов
CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    seller_id INT,
    store_id INT,
    sale_date DATE,
    quantity INT,
    total_price NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (seller_id) REFERENCES dim_seller(seller_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
);