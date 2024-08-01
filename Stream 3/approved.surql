DEFINE TABLE approved
    TYPE RELATION
    SCHEMAFULL
;

REMOVE FIELD in ON TABLE approved;
DEFINE FIELD in
    ON TABLE approved
    TYPE record<user>
    ASSERT !!$value.id AND $value.id IN $this->comment.post<-authored<-user.id
;

REMOVE FIELD out ON TABLE approved;
DEFINE FIELD out
    ON TABLE approved
    TYPE record<comment>
    ASSERT !!$value.id
;

DEFINE FIELD date
    ON TABLE approved
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE FIELD note
    ON TABLE approved
    TYPE option<string>
;

DEFINE INDEX only_one_approval_per_comment
    ON TABLE approved 
    COLUMNS out UNIQUE;


DEFINE EVENT on_approval_creation
    ON TABLE approved
    WHEN
        $event == "CREATE"
    THEN {
        UPDATE $after.out SET approved = true;
    }
;

DEFINE EVENT on_approval_deletion
    ON TABLE approved
    WHEN
        $event == "DELETE"
    THEN {
        UPDATE $before.out SET approved = false;
    }
;

DEFINE EVENT on_approval_update
    ON TABLE approved
    WHEN
        $event == "UPDATE"
    THEN {
        THROW "Cannot update approval status (" + <string>$after.id + ")";
    }
;