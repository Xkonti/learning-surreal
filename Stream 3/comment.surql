DEFINE TABLE comment TYPE NORMAL SCHEMAFULL;

DEFINE FIELD content
    ON TABLE comment
    TYPE string
    ASSERT string::len($value) <= 1000
;

DEFINE FIELD author
    ON TABLE comment
    TYPE record<user>
    ASSERT !!$value.id
;

DEFINE FIELD created_at
    ON TABLE comment
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE FIELD post
    ON TABLE comment
    TYPE record<post>
    ASSERT !!$value.id AND ($this.reply_to IS NONE OR $this.reply_to.post.id == $value.id)
;

DEFINE FIELD reply_to
    ON TABLE comment
    TYPE option<record<comment>>
    ASSERT $value IS NONE OR !!$value.id
;

DEFINE FIELD approved
    ON TABLE comment
  	TYPE bool
    DEFAULT false
;