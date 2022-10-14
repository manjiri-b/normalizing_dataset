-- 1. This query tries to determine whether or not report id is unique
SELECT
  report_id,
  count(*) as frequency
FROM staging_caers_event_product
GROUP BY report_id
HAVING count(*) > 1
ORDER BY desc;

-- report_id | frequency
-------------+-----------
-- 209126    |         2
-- 209563    |         2
-- 180072    |         3
-- 181790    |         4
-- 203668    |         2
--(5 rows)

--2. Checking if there are duplicate rows
select report_id, CAERS_created_date, date_of_event,
       product_type, product, product_code,
       description, patient_age, age_units,
       sex, MedDRA_preferred_terms, outcomes, count(*) as c
from staging_caers_event_product
group by report_id, CAERS_created_date, date_of_event,
       product_type, product, product_code,
       description, patient_age, age_units,
       sex, MedDRA_preferred_terms, outcomes
order by c desc limit 5;

--3. Removing duplicate rows
create or replace view d_caers_event_product as
select distinct report_id, CAERS_created_date, date_of_event,
       product_type, product, product_code,
       description, patient_age, age_units,
       sex, MedDRA_preferred_terms, outcomes
from staging_caers_event_product;
--CREATE VIEW

--4. checking potential canditate keys
select report_id, product, count(*) as c
from d_caers_event_product
group by report_id, product
order by c desc;

--    report_id    |                                                                                                 product                                                                                                  | c
-- -----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---
--  213904          | EXEMPTION 4                                                                                                                                                                                              | 3
--  178211          | EXEMPTION 4                                                                                                                                                                                              | 3
--  194882          | EXEMPTION 4                                                                                                                                                                                              | 3

--5. Adding a new columns in the composite key until no duplicates are there:
-- final candidate keys (report_id, product, product_type, product_code)
select report_id, product, product_type, product_code, count(*) as c
from d_caers_event_product
group by report_id, product, product_type, product_code
having count(*) >  1
order by c desc;

-- report_id | product | product_type | product_code | c
-- -----------+---------+--------------+--------------+---
-- (0 rows)

--6. Checking functional dependency between product code and description
select product_code, count(product_code) as count from (
	select distinct product_code, description
	from staging_caers_event_product
) pcd
group by product_code
order by count desc;

-- product_code | count
-- --------------+-------
--  34           |     1
--  18           |     1
--  2            |     1

--7. Checking functional dependency between product and product_code
select product, count(product) as count from (
	select distinct product, product_code
	from staging_caers_event_product
) pcd
group by product
order by count;

--                product                | count
-- --------------------------------------+-------
--  EXEMPTION 4                          |    33
--  TURMERIC                             |     4
--  COCONUT OIL                          |     3
--  SYNC                                 |     3
--  PREMIER PROTEIN                      |     3

--8. Seeing Distinct set of Medra Preferred Terms Exploration

select distinct(trim(loc[array_length(loc, 1)])) as terms
from (select string_to_array(MedDRA_preferred_terms, ',') as loc from staging_caers_event_product) staging_caers_event_product;

--                        btrim
-- ---------------------------------------------------
--  ONYCHALGIA
--  HYPOAESTHESIA
--  EMBOLISM
--  ARRHYTHMIA
--  DRUG INTOLERANCE
--  BLOOD PARATHYROID HORMONE INCREASED
--  HAEMORRHOIDAL HAEMORRHAGE
--  GRAM STAIN POSITIVE
--  DIARRHOEA
--  BLOOD POTASSIUM DECREASED
--  EPIGASTRIC DISCOMFORT
--  FUNCTIONAL GASTROINTESTINAL DISORDER

--9. Seeing distinct set of Outcomes
select distinct(trim(loc1[array_length(loc1, 1)])) as outcomes
from (select string_to_array(outcomes, ',') as loc1 from staging_caers_event_product) staging_caers_event_product;

--               outcomes
-- -------------------------------------
--  Other Outcome
--  Death
--  Patient Visited ER
--  Patient Visited Healthcare Provider
--  Hospitalization
--  Life Threatening
--  Congenital Anomaly

--10. Exploring maximum lengths
select max(char_length(sex)) from staging_caers_event_product; --4
select max(char_length(product)) from staging_caers_event_product; --
select max(char_length(product_type)) from staging_caers_event_product; --11
select max(char_length(description)) from staging_caers_event_product; --45
select max(char_length(report_id)) from staging_caers_event_product; --15