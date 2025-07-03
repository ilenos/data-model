# Data Model
## Purpose 
Document and highlight areas of knowledge surrounding SQL, data modeling, and data engineering.

`Some things like profile names and environment setup were kept vague/simple on purpose to keep focus on the intent of the exercise.  These would obviously be different in a production setting.
`

## Requirements
- admin priveleges to the target installation machine
- [uv](https://docs.astral.sh/uv/) - Python environment/dependency management
- [docker desktop](https://www.docker.com/products/docker-desktop/) - deployment for local postgres instance

## Setup
### Configure your local virtual environment
```sh
uv sync
```

### Setup environment variables
```sh
# navigate to project_root if needed
cp .env.sample .env
# Modify the .env file contents to match your target profiles.yml user credentials for the local Postgres instance.
```

### Start Postgres and Adminer
```sh
# navigate to project_root if needed
docker compose up -d
```

### Seed the database
```sh
# navigate to project_root if needed
cat .docker/postgres/seed.sql | docker exec -i postgres psql -h localhost -U postgres -f-
```

### Time for dbt
```sh
# navigate to project_root/dwh
dbt seed
dbt run
dbt test
```

Entity Relationship Diagram
```mermaid
erDiagram
    date {
        date date_day PK
        date prior_date_day
        date next_date_day
    }
    dim_date {
        date date_day PK
        date prior_date_day
        date next_date_day
    }
    dim_object {
        string object_key PK "MD5 hash"
        string description
    }
    dim_product {
        string product_key PK "MD5 hash"
        string description
    }
    dim_verb {
        string verb_key PK "MD5 hash"
        string description
    }
    dim_user {
        string user_id PK
    }
    fct_event {
        string id PK
        string user_id FK
        string verb_key FK
        string object_key FK
        string product_key FK
        timestamp event_ts

    }
    date ||--|| dim_date:::bg : "date_day"
    dim_date ||--o{ fct_event : "event_ts"
    dim_object ||--o{ fct_event : "object_key"
    dim_product ||--o{ fct_event : "product_key"
    dim_user ||--o{ fct_event : "user_id"
    dim_verb ||--o{ fct_event : "verb_key"

    classDef default fill:#a0bff0
```