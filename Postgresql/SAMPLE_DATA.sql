-- Insert Brands
INSERT INTO BRAND (BRAND_NAME, BRAND_LOCATION, BRAND_OFFICIAL_PHONE) VALUES
    ('Sun Pharmaceuticals', 'Mumbai', '9876543210'),
    ('Cipla Limited', 'Pune', '9876543211'),
    ('Dr. Reddy''s', 'Hyderabad', '9876543212'),
    ('Lupin Limited', 'Mumbai', '9876543213'),
    ('Zydus Lifesciences', 'Ahmedabad', '9876543214');

-- Insert Medicine Shops
INSERT INTO MEDICINE_SHOP (SHOP_NAME, SHOP_ADDRESS, SHOP_PHONE_NO) VALUES
    ('HealthFirst Pharmacy', '123 Gandhi Road, Mumbai', '9876543215'),
    ('MedPlus Pharmacy', '456 Nehru Street, Delhi', '9876543216'),
    ('Wellness Forever', '789 Patel Lane, Bangalore', '9876543217'),
    ('Apollo Pharmacy', '321 Singh Avenue, Chennai', '9876543218'),
    ('MedCare Plus', '654 Kumar Colony, Pune', '9876543219');

-- Insert sample Doctor (needed for customer reference)
INSERT INTO DOCTOR_CONSULTATION (DOCTOR_NAME, DOCTOR_ADDRESS, DOCTOR_PHONE_NO, DOCTOR_QUALIFICATION, DOCTOR_SPECIALIZATION) VALUES
    ('Dr. Sharma', '123 Medical Center, Mumbai', '9876543220', 'MBBS, MD', 'General Medicine'),
    ('Dr. Patel', '456 Health Center, Delhi', '9876543221', 'MBBS, MS', 'Cardiology');

-- Insert Customers
INSERT INTO CUSTOMER (NAME, ADDRESS, PHONE_NO, PINCODE, AGE, GENDER, DOCTOR_ID) VALUES
    ('Rahul Kumar', '123 Residential Area, Mumbai', '9876543222', 400001, 35, 'MALE', (SELECT DOCTOR_ID FROM DOCTOR_CONSULTATION WHERE DOCTOR_NAME = 'Dr. Sharma')),
    ('Priya Singh', '456 Housing Colony, Delhi', '9876543223', 110001, 28, 'FEMALE', (SELECT DOCTOR_ID FROM DOCTOR_CONSULTATION WHERE DOCTOR_NAME = 'Dr. Patel')),
    ('Amit Patel', '789 Apartment Complex, Bangalore', '9876543224', 560001, 45, 'MALE', (SELECT DOCTOR_ID FROM DOCTOR_CONSULTATION WHERE DOCTOR_NAME = 'Dr. Sharma')),
    ('Sneha Reddy', '321 Residential Society, Chennai', '9876543225', 600001, 32, 'FEMALE', (SELECT DOCTOR_ID FROM DOCTOR_CONSULTATION WHERE DOCTOR_NAME = 'Dr. Patel')),
    ('Mohammad Khan', '654 Housing Society, Pune', '9876543226', 411001, 40, 'MALE', (SELECT DOCTOR_ID FROM DOCTOR_CONSULTATION WHERE DOCTOR_NAME = 'Dr. Sharma'));

-- Insert Products
INSERT INTO PRODUCT (
    PRODUCT_NAME,
    PRODUCT_TYPE,
    PRODUCT_QUANTITY,
    PRODUCT_IMG_LINK,
    PRODUCT_BASED_ON_GENDER,
    PRODUCT_AGE_GROUP,
    PRODUCT_PRICE,
    PRODUCT_COMMISSION_PERCENT,
    PRODUCT_MFG_DATE,
    PRODUCT_EXP_DATE,
    PRODUCT_SHOP_ID,
    PRODUCT_BRAND_ID
) VALUES
    (
        'Paracetamol 500mg',
        'TABLET',
        '10 tablets',
        'https://example.com/paracetamol.jpg',
        'OTHER',
        'ANY',
        45.00,
        10.00,
        '2024-01-01',
        '2026-01-01',
        (SELECT SHOP_ID FROM MEDICINE_SHOP WHERE SHOP_NAME = 'HealthFirst Pharmacy'),
        (SELECT BRAND_ID FROM BRAND WHERE BRAND_NAME = 'Sun Pharmaceuticals')
    ),
    (
        'Vitamin C 1000mg',
        'TABLET',
        '30 tablets',
        'https://example.com/vitaminc.jpg',
        'OTHER',
        'ADULT',
        299.99,
        15.00,
        '2024-01-01',
        '2025-12-31',
        (SELECT SHOP_ID FROM MEDICINE_SHOP WHERE SHOP_NAME = 'MedPlus Pharmacy'),
        (SELECT BRAND_ID FROM BRAND WHERE BRAND_NAME = 'Cipla Limited')
    ),
    (
        'Children''s Cough Syrup',
        'SYRUP',
        '100ml',
        'https://example.com/coughsyrup.jpg',
        'OTHER',
        'CHILDREN',
        125.50,
        12.50,
        '2024-01-15',
        '2025-07-15',
        (SELECT SHOP_ID FROM MEDICINE_SHOP WHERE SHOP_NAME = 'Wellness Forever'),
        (SELECT BRAND_ID FROM BRAND WHERE BRAND_NAME = 'Zydus Lifesciences')
    ),
    (
        'Diabetic Support Tablets',
        'TABLET',
        '60 tablets',
        'https://example.com/diabetic.jpg',
        'OTHER',
        'ADULT',
        599.99,
        20.00,
        '2024-02-01',
        '2026-02-01',
        (SELECT SHOP_ID FROM MEDICINE_SHOP WHERE SHOP_NAME = 'Apollo Pharmacy'),
        (SELECT BRAND_ID FROM BRAND WHERE BRAND_NAME = 'Dr. Reddy''s')
    ),
    (
        'Calcium + Vitamin D3',
        'TABLET',
        '60 tablets',
        'https://example.com/calcium.jpg',
        'OTHER',
        'ADULT',
        399.99,
        15.00,
        '2024-01-01',
        '2026-06-01',
        (SELECT SHOP_ID FROM MEDICINE_SHOP WHERE SHOP_NAME = 'MedCare Plus'),
        (SELECT BRAND_ID FROM BRAND WHERE BRAND_NAME = 'Lupin Limited')
    );

-- Create initial carts for customers
INSERT INTO CART (CUSTOMER_ID) 
SELECT CUSTOMER_ID FROM CUSTOMER;

-- Add some items to carts
INSERT INTO CART_ITEMS (CART_ID, PRODUCT_ID, QUANTITY)
VALUES
    (1, 1, 2),  -- First customer buying 2 Paracetamol
    (1, 2, 1),  -- First customer buying 1 Vitamin C
    (2, 3, 1),  -- Second customer buying Cough Syrup
    (3, 4, 1),  -- Third customer buying Diabetic Support
    (4, 5, 2);  -- Fourth customer buying 2 Calcium tablets