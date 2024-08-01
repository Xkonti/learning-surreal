DEFINE TABLE post TYPE NORMAL SCHEMAFULL;

DEFINE FIELD title
    ON TABLE post
    TYPE string
;

DEFINE FIELD description
    ON TABLE post
    TYPE string
;

DEFINE FIELD slug
    ON TABLE post
    TYPE string
    ASSERT string::len($value) > 3 AND $value == string::slug($value)
;

DEFINE FIELD featured
    ON TABLE post
	TYPE bool
    DEFAULT false
;

DEFINE FIELD obsolete
    ON TABLE post
	TYPE bool
;

DEFINE FIELD draft
    ON TABLE post
	TYPE bool
    DEFAULT true
;

DEFINE FIELD learnable
    ON TABLE post
	TYPE bool
    DEFAULT false
;

DEFINE FIELD og_image
    ON TABLE post
    TYPE string
;

DEFINE FIELD published_on
    ON TABLE post
    TYPE set<string>
    COMMENT "URLs to version of this post on other sites"
;

DEFINE FIELD published_on.*
    ON TABLE post
    TYPE string
    ASSERT string::is::url($value)
;

DEFINE FIELD published_at
    ON TABLE post
	TYPE datetime
    COMMENT "The date and time the post was first published"
;

DEFINE FIELD updates
    ON TABLE post
    TYPE set<object>
    DEFAULT []
    COMMENT "List of updates to the content of the post"
;

DEFINE FIELD updates.*.date
    ON TABLE post
	TYPE datetime
    ASSERT $value > $this.published_at
;

DEFINE FIELD updates.*.description
    ON TABLE post
	TYPE string
;

DEFINE FIELD last_updated
    ON TABLE post
	TYPE datetime
    DEFAULT $this.published_at
    COMMENT "The date and time the post was last updated"
;

DEFINE EVENT on_post_date_update
    ON TABLE post
    WHEN
        $event != "DELETE"
        AND ($before.published_at != $after.published_at OR $before.updates != $after.updates)
    THEN {
        IF array::len($after.updates) > 0 {
            LET $lastest_update = (SELECT VALUE date FROM ONLY $after.updates ORDER BY date DESC LIMIT 1);
            UPDATE $after.id SET last_updated = $lastest_update;
        }
        ELSE {
            UPDATE $after.id SET last_updated = $after.published_at;
        }
    }
;

DEFINE INDEX unique_slug
    ON TABLE post 
    COLUMNS slug
    UNIQUE;