DEFINE TABLE OVERWRITE topic TYPE NORMAL SCHEMAFULL;

DEFINE FIELD OVERWRITE name
    ON TABLE topic
    TYPE string
    ASSERT $value.len() >= 1
;

DEFINE FIELD OVERWRITE description
    ON TABLE topic
    TYPE string
    ASSERT $value.len() >= 10
;

DEFINE FIELD OVERWRITE slug
    ON TABLE topic
    TYPE string
    ASSERT $value.len() > 1 AND $value == $value.slug()
;

DEFINE FIELD OVERWRITE deleted_at
    ON TABLE topic
    TYPE option<datetime>
    DEFAULT NONE
    COMMENT "The date and time the topic was marked as deleted, it will be automatically deleted after a certain amount of time"
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE topic
    TYPE uuid
    COMMENT "The ID of the last update to the topic - used to detect deleted topics"
;