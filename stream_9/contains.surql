DEFINE TABLE OVERWRITE contains
    TYPE RELATION
    IN series OUT post ENFORCED
    SCHEMAFULL
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE contains
    TYPE uuid
    COMMENT "The ID of the last update to the relation - used to detect deleted relations"
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE contains 
    COLUMNS in, out UNIQUE;