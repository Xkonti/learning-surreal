DEFINE TABLE OVERWRITE comment TYPE NORMAL SCHEMAFULL
    PERMISSIONS
        FOR select WHERE approved = true
        FOR create FULL
;

DEFINE FIELD OVERWRITE content
    ON TABLE comment
    TYPE string
    ASSERT $value.len() <= 1000
;

DEFINE FIELD OVERWRITE author
    ON TABLE comment
    TYPE record<user>
    ASSERT $value.exists()
    PERMISSIONS
        FOR create WHERE author = $auth.id
;

DEFINE FIELD OVERWRITE created_at
    ON TABLE comment
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE FIELD OVERWRITE post
    ON TABLE comment
    TYPE record<post>
    ASSERT !reply_to OR reply_to.post.id == $value.id
    READONLY
;

DEFINE FIELD OVERWRITE reply_to
    ON TABLE comment
    TYPE option<record<comment>>
    ASSERT !$value OR $value.exists()
;

DEFINE FIELD OVERWRITE likes_count
    ON TABLE comment
	TYPE int
    DEFAULT 0
    PERMISSIONS
        FOR create, update, delete NONE
        FOR select FULL
    COMMENT "Calculated automatically"
;

DEFINE FIELD OVERWRITE approved
    ON TABLE comment
  	TYPE bool
    DEFAULT false
    PERMISSIONS
        FOR select, update, create, delete NONE
;

DEFINE EVENT OVERWRITE on_comment_created ON TABLE comment
    WHEN $event == "CREATE"
    THEN {
        IF !$after.post.exists() OR $after.post.draft {
            THROW "Can't comment on something that doesn't exist";
        };
        UPDATE $after.id SET
            approved = false,
            likes_count = 0
        ;
        # TODO: This is an opportunity to automatically approve the comment if it's the author's comment
    }
;

DEFINE EVENT OVERWRITE on_comment_approval_update ON TABLE comment
    WHEN $event == "UPDATE" AND $before.approved AND $before.approved != $after.approved
    THEN {
        IF $after.approved {
            UPDATE $after.post SET comments_count += 1;
        }
        ELSE {
            UPDATE $after.post SET comments_count -= 1;
        };
    }
;

DEFINE EVENT OVERWRITE on_comment_delete ON TABLE comment
    WHEN $event == "DELETE"
    THEN {
        IF $before.approved {
            UPDATE $before.post SET comments_count -= 1;
        };
    }
;