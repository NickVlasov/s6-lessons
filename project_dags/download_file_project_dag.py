from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.decorators import dag

import os
import boto3
import pendulum


def fetch_s3_file(bucket: str, key: str):
    AWS_ACCESS_KEY_ID = "key"
    AWS_SECRET_ACCESS_KEY = "password"

    session = boto3.session.Session()
    s3_client = session.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    )

    os.makedirs('data', exist_ok=True)

    s3_client.download_file(
        Bucket='sprint6',
        Key='group_log.csv',
        Filename='data/group_log.csv'
    )


@dag(schedule_interval=None, start_date=pendulum.parse('2022-07-13'))
def sprint6_project_dag_get_file():

    task1 = PythonOperator(
        task_id='fetch_group_log.csv',
        python_callable=fetch_s3_file,
        op_kwargs={'bucket': 'sprint6', 'key': 'group_log.csv'},
    )

    task1

_ = sprint6_project_dag_get_file()
