DROP TABLE IF EXISTS staging_caers_event_product;

CREATE TABLE staging_caers_event_product (
    id serial PRIMARY KEY,
    report_id text,
    CAERS_created_date date,
    date_of_event date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age float, --age 35.76
    age_units text,
    sex text,
    MedDRA_preferred_terms text ,
    outcomes text
);

--Product type depends on the product
--Redundant info so will delete product type column
--Patient age and age units go hand in hand

COPY staging_caers_event_product (report_id, CAERS_created_date, date_of_event, product_type, product, product_code,
    description, patient_age, age_units, sex, MedDRA_preferred_terms ,outcomes)
FROM '/Users/manjiribhandarwar/Documents/GitHub/homework07-manjiri-b/data/CAERS-ASCII-2014-2017_0.csv'
DELIMITER ','
CSV HEADER;