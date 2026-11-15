from datetime import timedelta
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="dwh_pipeline",
    start_date=pendulum.datetime(2024, 1, 1, tz="Europe/Moscow"),
    schedule="*/5 * * * *",
    catchup=False,
    max_active_runs=1,
    default_args={"retries": 1, "retry_delay": timedelta(minutes=1)},
    tags=["coursework"],
) as dag:
    build = BashOperator(
        task_id="dbt_build",
        bash_command=(
            "cd /opt/airflow/dbt && "
            "/opt/dbt-venv/bin/dbt build "
            "--profiles-dir /opt/airflow/dbt"
        ),
        execution_timeout=timedelta(minutes=10),
    )
