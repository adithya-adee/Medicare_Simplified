-- DATABASE TABLE STRUCTURE

-- USING UUID FOR MY APP
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CUSTOMER TABLE (UUID)
CREATE TABLE CUSTOMER (
    CUSTOMER_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    NAME VARCHAR(50) NOT NULL,
    ADDRESS VARCHAR(250) NOT NULL,
    PHONE_NO VARCHAR(15) CHECK(PHONE_NO ~ '^[5-9][0-9]{9}$'), 
    PINCODE NUMERIC(6,0) NOT NULL CHECK (PINCODE BETWEEN 100001 AND 999998),
    AGE NUMERIC NOT NULL CHECK(AGE BETWEEN 1 AND 149),
    GENDER VARCHAR(7) CHECK(GENDER IN ('MALE', 'FEMALE', 'OTHER')),
    DOCTOR_ID UUID  -- Matches DOCTOR_CONSULTATION.DOCTOR_ID
);

-- DOCTOR CONSULTATION TABLE (UUID)
CREATE TABLE DOCTOR_CONSULTATION (
    DOCTOR_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    DOCTOR_NAME VARCHAR(50) NOT NULL,
    DOCTOR_ADDRESS VARCHAR(250),
    DOCTOR_PHONE_NO VARCHAR(15) CHECK(DOCTOR_PHONE_NO ~ '^[5-9][0-9]{9}$'),
    DOCTOR_QUALIFICATION VARCHAR(100) NOT NULL,
    DOCTOR_SPECIALIZATION VARCHAR(25) NOT NULL
);

ALTER TABLE CUSTOMER 
ADD CONSTRAINT FK_CUSTOMER_DOCTOR FOREIGN KEY (DOCTOR_ID) 
REFERENCES DOCTOR_CONSULTATION (DOCTOR_ID) ON DELETE CASCADE;

-- MEDICINE SHOP TABLE (UUID)
CREATE TABLE MEDICINE_SHOP (
    SHOP_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    SHOP_NAME VARCHAR(100) NOT NULL,
    SHOP_ADDRESS VARCHAR(250) NOT NULL,
    SHOP_PHONE_NO VARCHAR(15) CHECK(SHOP_PHONE_NO ~ '^[5-9][0-9]{9}$')
);

-- BRAND TABLE (UUID)
CREATE TABLE BRAND (
    BRAND_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    BRAND_NAME VARCHAR(50) NOT NULL,
    BRAND_LOCATION VARCHAR(50),
    BRAND_OFFICIAL_PHONE VARCHAR(15) CHECK(BRAND_OFFICIAL_PHONE ~ '^[5-9][0-9]{9}$')
);

-- PRODUCT TABLE (BIGSERIAL)
CREATE TABLE PRODUCT (
    PRODUCT_ID BIGSERIAL PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_TYPE VARCHAR(25) NOT NULL,
    PRODUCT_QUANTITY VARCHAR(20) NOT NULL,
    PRODUCT_BASED_ON_GENDER VARCHAR(7) CHECK(PRODUCT_BASED_ON_GENDER IN ('MALE', 'FEMALE', 'OTHER')),
    PRODUCT_AGE_GROUP VARCHAR(20) CHECK(PRODUCT_AGE_GROUP IN ('INFANT', 'CHILDREN', 'ADULT', 'ANY')),
    PRODUCT_PRICE NUMERIC(10,2) NOT NULL CHECK(PRODUCT_PRICE > 0),
    PRODUCT_COMMISSION_PERCENT NUMERIC(5,2) NOT NULL CHECK(PRODUCT_COMMISSION_PERCENT >= 0),
    PRODUCT_MFG_DATE DATE,
    PRODUCT_EXP_DATE DATE,
    PRODUCT_SHOP_ID UUID NOT NULL,
    PRODUCT_BRAND_ID UUID NOT NULL
);

ALTER TABLE PRODUCT
ADD CONSTRAINT FK_PRODUCT_SHOP FOREIGN KEY (PRODUCT_SHOP_ID) 
REFERENCES MEDICINE_SHOP (SHOP_ID) ON DELETE CASCADE;

ALTER TABLE PRODUCT
ADD CONSTRAINT FK_PRODUCT_BRAND FOREIGN KEY (PRODUCT_BRAND_ID) 
REFERENCES BRAND (BRAND_ID) ON DELETE CASCADE;

-- CART TABLE (BIGSERIAL)
CREATE TABLE CART (
    CART_ID BIGSERIAL PRIMARY KEY,
    CUSTOMER_ID UUID UNIQUE NOT NULL,
    DELIVERY_TIME TIME
);

ALTER TABLE CART 
ADD CONSTRAINT FK_CART_CUSTOMER FOREIGN KEY (CUSTOMER_ID) 
REFERENCES CUSTOMER (CUSTOMER_ID) ON DELETE CASCADE;

-- CART_ITEMS TABLE (BIGSERIAL)
CREATE TABLE CART_ITEMS (
    CART_ID BIGINT NOT NULL,
    PRODUCT_ID BIGINT NOT NULL,
    QUANTITY INT NOT NULL CHECK(QUANTITY > 0),
    PRIMARY KEY (CART_ID, PRODUCT_ID),
    FOREIGN KEY (CART_ID) REFERENCES CART (CART_ID) ON DELETE CASCADE,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID) ON DELETE CASCADE
);

-- WISHLIST TABLE (UUID + BIGSERIAL)
CREATE TABLE WISHLIST (
    CUSTOMER_ID UUID NOT NULL,
    PRODUCT_ID BIGINT NOT NULL,
    PRIMARY KEY (CUSTOMER_ID, PRODUCT_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID) ON DELETE CASCADE,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID) ON DELETE CASCADE
);

-- PAYMENT TABLE (UUID)
CREATE TABLE PAYMENT (
    PAYMENT_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    TRANSACTION_ID VARCHAR(50) UNIQUE NOT NULL, 
    TOTAL_PRICE NUMERIC(10,2) NOT NULL CHECK(TOTAL_PRICE > 0),
    PAYMENT_METHOD VARCHAR(50) NOT NULL CHECK(PAYMENT_METHOD IN ('CASH ON DELIVERY', 'CREDIT/DEBIT CARD', 'E-WALLETS', 'NETBANKING')),
    PAYMENT_STATUS VARCHAR(20) NOT NULL CHECK(PAYMENT_STATUS IN ('PENDING', 'COMPLETED', 'FAILED')),
    PAYMENT_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    COUPON_APPLIED BOOLEAN NOT NULL DEFAULT FALSE,
    CART_ID BIGINT NOT NULL, -- Matches CART.CART_ID
    CUSTOMER_ID UUID NOT NULL -- Matches CUSTOMER.CUSTOMER_ID
);

ALTER TABLE PAYMENT 
ADD CONSTRAINT FK_PAYMENT_CUSTOMER FOREIGN KEY (CUSTOMER_ID) 
REFERENCES CUSTOMER (CUSTOMER_ID) ON DELETE CASCADE;

ALTER TABLE PAYMENT
ADD CONSTRAINT FK_PAYMENT_CART FOREIGN KEY (CART_ID) 
REFERENCES CART (CART_ID) ON DELETE CASCADE;


-- ORDER_HISTORY TABLE (BIG SERIAL)
CREATE TABLE ORDER_HISTORY (
    ORDER_ID BIGSERIAL PRIMARY KEY,                              
    CART_ID BIGINT NOT NULL,                                     
    CUSTOMER_ID UUID NOT NULL,                                    
    ORDER_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              
    TOTAL_AMOUNT NUMERIC(10,2) NOT NULL CHECK (TOTAL_AMOUNT > 0),
    ORDER_STATUS VARCHAR(20) NOT NULL CHECK (
        ORDER_STATUS IN ('PENDING', 'COMPLETED', 'CANCELLED')
    ),
    SHIPPING_ADDRESS VARCHAR(250) NOT NULL,                      
    BILLING_ADDRESS VARCHAR(250) NOT NULL,                       
    PAYMENT_STATUS VARCHAR(20) NOT NULL CHECK (
        PAYMENT_STATUS IN ('PENDING', 'PAID', 'FAILED')
    ),
    PAYMENT_REFERENCE VARCHAR(100),                              
    COMPLETED_TIMESTAMP TIMESTAMP,                              
    CANCELLED_TIMESTAMP TIMESTAMP,                               
    SHIPPING_METHOD VARCHAR(50) NOT NULL CHECK (
        SHIPPING_METHOD IN ('STANDARD', 'EXPRESS', 'OVERNIGHT')
    ),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,               -- Audit field: when the order record was created
    LAST_MODIFIED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,            -- Audit field: last modification timestamp
    CREATED_BY UUID,                                              -- Optional: Who created the order (could be the customer or an admin)
    LAST_MODIFIED_BY UUID                                         -- Optional: Who last modified the order
);

ALTER TABLE ORDER_HISTORY
ADD CONSTRAINT FK_ORDER_HISTORY_CART FOREIGN KEY (CART_ID)
    REFERENCES CART (CART_ID) ON DELETE CASCADE;

ALTER TABLE ORDER_HISTORY
ADD CONSTRAINT FK_ORDER_HISTORY_CUSTOMER FOREIGN KEY (CUSTOMER_ID)
    REFERENCES CUSTOMER (CUSTOMER_ID) ON DELETE CASCADE;


-- ORDER_ITEMS TABLE
CREATE TABLE ORDER_ITEMS (
    ORDER_ITEM_ID BIGSERIAL PRIMARY KEY,   -- Unique identifier for each order item
    ORDER_ID BIGINT NOT NULL,               -- References the order in ORDER_HISTORY
    PRODUCT_ID BIGINT NOT NULL,             -- References the product from the PRODUCT table
    PRODUCT_NAME VARCHAR(100) NOT NULL,     -- Snapshot of the product name at time of order
    PRODUCT_PRICE NUMERIC(10,2) NOT NULL,     -- Snapshot of the product price
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    SUBTOTAL NUMERIC(10,2) NOT NULL,          -- (PRODUCT_PRICE * QUANTITY)
    -- Additional snapshot columns can be added as needed
    ORDERED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp for when this item was added to the order
);

-- Add a foreign key from ORDER_ITEMS to ORDER_HISTORY
ALTER TABLE ORDER_ITEMS
ADD CONSTRAINT FK_ORDER_ITEMS_ORDER FOREIGN KEY (ORDER_ID)
    REFERENCES ORDER_HISTORY (ORDER_ID) ON DELETE CASCADE;

-- Add a foreign key from ORDER_ITEMS to PRODUCT
ALTER TABLE ORDER_ITEMS
ADD CONSTRAINT FK_ORDER_ITEMS_PRODUCT FOREIGN KEY (PRODUCT_ID)
    REFERENCES PRODUCT (PRODUCT_ID) ON DELETE CASCADE;
