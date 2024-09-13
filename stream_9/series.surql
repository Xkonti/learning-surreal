DEFINE TABLE OVERWRITE series TYPE NORMAL SCHEMAFULL;

DEFINE FIELD OVERWRITE name
    ON TABLE series
    TYPE string
    ASSERT $value.len() >= 1
;

DEFINE FIELD OVERWRITE description
    ON TABLE series
    TYPE string
    ASSERT $value.len() >= 10
;

DEFINE FIELD OVERWRITE slug
    ON TABLE series
    TYPE string
    ASSERT $value.len() > 3 AND $value == $value.slug()
;

DEFINE FIELD OVERWRITE deleted_at
    ON TABLE series
    TYPE option<datetime>
    DEFAULT NONE
    COMMENT "The date and time the series was marked as deleted, it will be automatically deleted after a certain amount of time"
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE series
    TYPE uuid
    COMMENT "The ID of the last update to the series - used to detect deleted series"
;