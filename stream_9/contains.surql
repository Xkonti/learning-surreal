DEFINE TABLE OVERWRITE contains
    TYPE RELATION
    IN series OUT post ENFORCED
    SCHEMAFULL
;

DEFINE FIELD OVERWRITE deleted_at
    ON TABLE contains
    TYPE option<datetime>
    DEFAULT NONE
    COMMENT "The date and time the relation was marked as deleted, it will be automatically deleted after a certain amount of time"
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE contains
    TYPE uuid
    COMMENT "The ID of the last update to the relation - used to detect deleted relations"
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE contains 
    COLUMNS in, out UNIQUE;