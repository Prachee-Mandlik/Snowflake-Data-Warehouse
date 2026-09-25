
use role sysadmin;

use warehouse pc_sigma_wh;

create or replace database plugs_db;

use database plugs_db;

use schema public;

CREATE or REPLACE STAGE plugs_db.public.sigma_stage
    URL = 's3://sigma-snowflake-vhol/data/';

ls @sigma_stage;

create or replace table transactions  
(order_number integer,
  date timestamp,
  sku_number string,
  quantity integer,
  cost integer,
  price integer,
  product_type string,
  product_family string,
  product_name string,
  store_name string,
  store_key integer,
  store_region string,
  store_state string,
  store_city string,
  store_latitude integer,
  store_longitude integer,
  customer_name string,
  cust_key integer);
 
 CREATE FILE FORMAT "PLUGS_DB"."PUBLIC".COMMA_DELIMITED 
          TYPE = 'CSV' 
          COMPRESSION = 'AUTO' 
          FIELD_DELIMITER = ',' 
          RECORD_DELIMITER = '\n' 
          SKIP_HEADER = 1 
          FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' 
          TRIM_SPACE = FALSE 
          ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE 
          ESCAPE = 'NONE' 
          ESCAPE_UNENCLOSED_FIELD = '\134' 
          DATE_FORMAT = 'AUTO' 
          TIMESTAMP_FORMAT = 'AUTO' 
          NULL_IF = ('\\N');
 
 
COPY INTO transactions from @sigma_stage/Plugs_Transactions.csv FILE_FORMAT = ( FORMAT_NAME = 'COMMA_DELIMITED' );
 
SELECT COUNT(*) FROM TRANSACTIONS;
  
create or replace table Customer  
(cust_key integer,
 cust_json variant);
  
COPY INTO Customer from @sigma_stage/Plugs_Customers.csv FILE_FORMAT = ( FORMAT_NAME = 'COMMA_DELIMITED' );

select * from Customer;

grant USAGE on DATABASE PLUGS_DB to role PC_SIGMA_ROLE;

grant USAGE on SCHEMA PLUGS_DB.PUBLIC to role PC_SIGMA_ROLE;

grant SELECT on TABLE PLUGS_DB.PUBLIC.TRANSACTIONS to role PC_SIGMA_ROLE;

grant SELECT on TABLE PLUGS_DB.PUBLIC.CUSTOMER to role PC_SIGMA_ROLE;

use role PC_SIGMA_ROLE;

select * from Customer;

select count(*) from transactions;
