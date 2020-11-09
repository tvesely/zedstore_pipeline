To fly the pipeline:

```
fly -t dev set-pipeline -p zedstore_pipeline -c concourse/pipelines/pipeline.yaml -v zedstore_pipeline_branch=master -v postgres_repo_uri=https://github.com/greenplum-db/postgres.git -v postgres_repo_branch=zedstore -v tpch_scale_factor=1
```