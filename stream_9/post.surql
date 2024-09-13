DEFINE TABLE OVERWRITE post TYPE NORMAL SCHEMAFULL;

DEFINE FIELD OVERWRITE title
    ON TABLE post
    TYPE string
;

DEFINE FIELD OVERWRITE description
    ON TABLE post
    TYPE string
;

DEFINE FIELD OVERWRITE slug
    ON TABLE post
    TYPE string
    ASSERT $value.len() > 3 AND $value == $value.slug()
;

DEFINE FIELD OVERWRITE featured
    ON TABLE post
	TYPE bool
    DEFAULT false
;

DEFINE FIELD OVERWRITE obsolete
    ON TABLE post
	TYPE bool
;

DEFINE FIELD OVERWRITE draft
    ON TABLE post
	TYPE bool
    DEFAULT true
;

DEFINE FIELD OVERWRITE learnable
    ON TABLE post
	TYPE bool
    DEFAULT false
;

DEFINE FIELD OVERWRITE og_image
    ON TABLE post
    TYPE string
;

DEFINE FIELD OVERWRITE published_on
    ON TABLE post
    TYPE set<string>
    DEFAULT []
    COMMENT "URLs to version of this post on other sites"
;

DEFINE FIELD OVERWRITE published_on.*
    ON TABLE post
    TYPE string
    ASSERT $value.is_url();

DEFINE FIELD OVERWRITE published_at
    ON TABLE post
	TYPE datetime
    COMMENT "The date and time the post was first published"
;

DEFINE FIELD OVERWRITE updates
    ON TABLE post
    TYPE set<object>
    DEFAULT []
    COMMENT "List of updates to the content of the post"
;

DEFINE FIELD OVERWRITE updates.*.date
    ON TABLE post
	TYPE datetime
    ASSERT $value > published_at
;

DEFINE FIELD OVERWRITE updates.*.description
    ON TABLE post
	TYPE string
;

DEFINE FIELD OVERWRITE last_updated
    ON TABLE post
	TYPE datetime
    DEFAULT published_at
    COMMENT "The date and time the post was last updated"
;

DEFINE FIELD OVERWRITE deleted_at
    ON TABLE post
    TYPE option<datetime>
    DEFAULT NONE
    COMMENT "The date and time the post was marked as deleted, it will be automatically deleted after a certain amount of time"
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE post
    TYPE uuid
    COMMENT "The ID of the last update to the post - used to detect deleted posts"
;

DEFINE FIELD OVERWRITE likes_count
    ON TABLE post
	TYPE int
    DEFAULT 0
    COMMENT "Calculated automatically"
;

DEFINE FIELD OVERWRITE comments_count
    ON TABLE post
	TYPE int
    DEFAULT 0
    COMMENT "Calculated automatically"
;

DEFINE EVENT OVERWRITE on_post_date_update
    ON TABLE post
    WHEN
        $event != "DELETE"
        AND ($before.published_at != $after.published_at OR $before.updates != $after.updates)
    THEN {
        IF $after.updates.len() > 0 {
            LET $lastest_update = (SELECT VALUE date FROM ONLY $after.updates ORDER BY date DESC LIMIT 1);
            UPDATE $after.id SET last_updated = $lastest_update;
        }
        ELSE {
            UPDATE $after.id SET last_updated = $after.published_at;
        }
    }
;

DEFINE INDEX OVERWRITE unique_slug
    ON TABLE post 
    COLUMNS slug
    UNIQUE;