WITH source AS (
    SELECT event_json::json ->> 'id' AS id,
        event_json::json #>> '{common,userId}' AS user_id,
        event_json::json #>> '{common,object}' AS "object",
        event_json::json #>> '{common,product}' AS "product",
        event_json::json #>> '{common,verb}' AS "verb",
        event_json::json #>> '{common,timestamp}' AS event_ts
        FROM {{ source('signals', 'event') }}
)

SELECT *
    FROM source