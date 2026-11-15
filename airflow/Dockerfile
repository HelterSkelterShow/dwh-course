FROM apache/airflow:2.10.5-python3.11
USER root
RUN python -m venv /opt/dbt-venv && \
    /opt/dbt-venv/bin/pip install --no-cache-dir \
    dbt-core==1.8.9 dbt-postgres==1.8.2
USER airflow
