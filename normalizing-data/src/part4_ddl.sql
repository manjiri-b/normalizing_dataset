--create product table
create table product (
   product_id serial,
   product_type varchar(15) not null,
   product varchar(250) not null, --From data exploration found out max is 200
   product_code varchar(4) references product_description(product_code) not null, --From data exploration found max is 3
   primary key(product_id)
);

--create product description
create table product_description (
   product_code varchar(4),
   description varchar(50), --Max length is 45 from data exploration
   primary key(product_code)
);

--create patient information table
create table patient_information (
   patient_id serial,
   age varchar(25) not null,
   sex varchar(5) not null,
   primary key(patient_id)
);

--dates table
create table dates (
   id integer references event_description(id),
   CAERS_created_date date,
   date_of_event date,
   primary key(id)
);

--terms table
create table terms (
   term_id serial,
   term varchar(100) not null,
   primary key(term_id)
);

--medical outcomes table
create table outcomes (
   outcome_id serial,
   outcome varchar(50) not null, --Max 35 (seen from inspecting table and counting)
   primary key(outcome_id)
);

--event description
create table event_description (
    id serial,
    report_id varchar(20) not null,
    product_id integer references product(product_id),
    patient_id integer references patient_information(patient_id),
    primary key(id)
);

--join tables for many to many relationships

--event outcomes
create table event_outcomes(
    id integer references event_description(id),
    outcome_id integer references outcomes(outcome_id)
);

--event terms
create table event_terms(
    id integer references event_description(id),
    term_id integer references terms(term_id)
);