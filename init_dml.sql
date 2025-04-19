-- Очищаем таблицу и сбрасываем счётчик id
TRUNCATE TABLE mock_data RESTART IDENTITY;

-- Загружаем данные из всех CSV, игнорируя их id
DO $$
DECLARE
    file_index INT;
    file_path TEXT;
BEGIN
    RAISE NOTICE 'Загрузка CSV-файлов...';

    FOR file_index IN 0..9 LOOP
        file_path := '/init_data/mock_data_' || file_index || '.csv';

        IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'temp_import') THEN
            EXECUTE 'DROP TABLE temp_import';
        END IF;

        -- Временная таблица, куда грузим CSV как есть (включая id из файла)
        CREATE TEMP TABLE temp_import (
            id INT,
    customer_first_name VARCHAR(50),
    customer_last_name VARCHAR(50),
    customer_age INT,
    customer_email VARCHAR(100),
    customer_country VARCHAR(50),
    customer_postal_code VARCHAR(20),
    customer_pet_type VARCHAR(20),
    customer_pet_name VARCHAR(50),
    customer_pet_breed VARCHAR(50),
    seller_first_name VARCHAR(50),
    seller_last_name VARCHAR(50),
    seller_email VARCHAR(100),
    seller_country VARCHAR(50),
    seller_postal_code VARCHAR(20),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10, 2),
    product_quantity INT,
    sale_date DATE,
    sale_customer_id INT,
    sale_seller_id INT,
    sale_product_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL(10, 2),
    store_name VARCHAR(100),
    store_location VARCHAR(100),
    store_city VARCHAR(50),
    store_state VARCHAR(50),
    store_country VARCHAR(50),
    store_phone VARCHAR(20),
    store_email VARCHAR(100),
    pet_category VARCHAR(50),
    product_weight DECIMAL(6, 2),
    product_color VARCHAR(30),
    product_size VARCHAR(20),
    product_brand VARCHAR(50),
    product_material VARCHAR(50),
    product_description TEXT,
    product_rating DECIMAL(3, 1),
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    supplier_name VARCHAR(100),
    supplier_contact VARCHAR(100),
    supplier_email VARCHAR(100),
    supplier_phone VARCHAR(20),
    supplier_address VARCHAR(200),
    supplier_city VARCHAR(50),
    supplier_country VARCHAR(50)
        ) ON COMMIT DROP;

        -- Грузим CSV во временную таблицу
        EXECUTE format($f$
            COPY temp_import FROM '%s' DELIMITER ',' CSV HEADER;
        $f$, file_path);

        -- Переносим данные из временной таблицы в основную, без id
        INSERT INTO mock_data (
            customer_first_name, customer_last_name, customer_age, customer_email,
            customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
            customer_pet_breed, seller_first_name, seller_last_name, seller_email,
            seller_country, seller_postal_code, product_name, product_category,
            product_price, product_quantity, sale_date, sale_customer_id,
            sale_seller_id, sale_product_id, sale_quantity, sale_total_price,
            store_name, store_location, store_city, store_state, store_country,
            store_phone, store_email, pet_category, product_weight, product_color,
            product_size, product_brand, product_material, product_description,
            product_rating, product_reviews, product_release_date, product_expiry_date,
            supplier_name, supplier_contact, supplier_email, supplier_phone,
            supplier_address, supplier_city, supplier_country
        )
        SELECT 
            customer_first_name, customer_last_name, customer_age, customer_email,
            customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
            customer_pet_breed, seller_first_name, seller_last_name, seller_email,
            seller_country, seller_postal_code, product_name, product_category,
            product_price, product_quantity, sale_date, sale_customer_id,
            sale_seller_id, sale_product_id, sale_quantity, sale_total_price,
            store_name, store_location, store_city, store_state, store_country,
            store_phone, store_email, pet_category, product_weight, product_color,
            product_size, product_brand, product_material, product_description,
            product_rating, product_reviews, product_release_date, product_expiry_date,
            supplier_name, supplier_contact, supplier_email, supplier_phone,
            supplier_address, supplier_city, supplier_country
        FROM temp_import;

        RAISE NOTICE '✓ Загружен файл: %', file_path;
    END LOOP;

END $$;

-- Проверка результата
SELECT COUNT(*) AS total_rows FROM mock_data;
