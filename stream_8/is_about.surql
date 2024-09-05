DEFINE TABLE OVERWRITE is_about
    TYPE RELATION
    IN post|series OUT topic ENFORCED
    SCHEMAFULL
;

DEFINE FIELD OVERWRITE deleted_at
    ON TABLE is_about
    TYPE option<datetime>
    DEFAULT NONE
    COMMENT "The date and time the relation was marked as deleted, it will be automatically deleted after a certain amount of time"
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE is_about
    TYPE uuid
    COMMENT "The ID of the last update to the relation - used to detect deleted relations"
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE is_about 
    COLUMNS in, out UNIQUE;