DEFINE TABLE approved
    TYPE RELATION
    IN user OUT comment ENFORCED
    SCHEMAFULL
    PERMISSIONS
        FOR select, create, delete WHERE $access = "users" AND in = $auth.id
;

DEFINE FIELD OVERWRITE date
    ON TABLE approved
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE FIELD OVERWRITE note
    ON TABLE approved
    TYPE option<string>
;

DEFINE INDEX OVERWRITE only_one_approval_per_comment
    ON TABLE approved 
    COLUMNS out UNIQUE;


DEFINE EVENT OVERWRITE on_approval_creation
    ON TABLE approved
    WHEN $event == "CREATE"
    THEN {
        -- TODO: Test this properly with a frontend user
        IF $after.in NOT IN (SELECT VALUE ->comment.post<-authored<-user.id FROM ONLY $after LIMIT 1).flatten() {
            THROW "Only the outhor of the post can approve a comment on it";
        };

        UPDATE $after.out SET approved = true;
    }
;

DEFINE EVENT OVERWRITE on_approval_deletion
    ON TABLE approved
    WHEN $event == "DELETE"
    THEN {
        UPDATE $before.out SET approved = false;
    }
;

DEFINE EVENT OVERWRITE on_approval_update
    ON TABLE approved
    WHEN $event == "UPDATE"
    THEN {
        THROW "Cannot update approval status (" + (<string> $after.id) + ")";
    }
;