CREATE USER dwh WITH PASSWORD 'dwh';
CREATE USER airflow WITH PASSWORD 'airflow';
CREATE USER superset WITH PASSWORD 'superset';
CREATE USER bi_reader WITH PASSWORD 'bi_reader';
CREATE DATABASE warehouse OWNER dwh;
CREATE DATABASE airflow OWNER airflow;
CREATE DATABASE superset OWNER superset;
\connect warehouse
SET ROLE dwh;
CREATE SCHEMA raw AUTHORIZATION dwh;
CREATE SCHEMA stg AUTHORIZATION dwh;
CREATE SCHEMA dm AUTHORIZATION dwh;
CREATE TABLE raw.events (
    event_id text PRIMARY KEY,
    dataset_id text NOT NULL,
    payload jsonb NOT NULL,
    source_record text NOT NULL
);
GRANT CONNECT ON DATABASE warehouse TO bi_reader;
GRANT USAGE ON SCHEMA dm TO bi_reader;
ALTER DEFAULT PRIVILEGES FOR ROLE dwh IN SCHEMA dm
    GRANT SELECT ON TABLES TO bi_reader;
