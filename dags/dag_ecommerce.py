# dags/fraud_dbt_dag.py
from datetime import datetime
from airflow import DAG
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig
from airflow.operators.empty import EmptyOperator

# path to dbt folder in container
DBT_PROJECT_DIR = "/opt/airflow/dbt_ecommerce"

profile_config = ProfileConfig(
    profile_name="dbt_ecommerce",
    target_name="dev",
    profiles_yml_filepath=f"{DBT_PROJECT_DIR}/profiles.yml"
)

with DAG(
    dag_id="fraud_analytics_pipeline",
    start_date=datetime(2026, 5, 16),
    schedule_interval="@daily",
    catchup=False,
    tags=["brazillian-ecommerce", "dbt", "bigquery", "analytics"],
) as dag:

    start = EmptyOperator(task_id="start_pipeline")
    
    # Cosmos reads dbt_ecommerce folder automaticaly and draws dag graph
    dbt_run = DbtTaskGroup(
        group_id="dbt_transformations",
        project_config=ProjectConfig(DBT_PROJECT_DIR),
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path="/usr/local/bin/dbt",
        ),
    )

    end = EmptyOperator(task_id="end_pipeline")

    start >> dbt_run >> end