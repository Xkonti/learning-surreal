DEFINE FUNCTION OVERWRITE fn::update_content(
    $topics: array<object>,
    $posts: array<object>,
    $series: array<object>
    ) -> bool {
        -- Validate topics
        FOR $topic IN $topics {
            IF !$topic.id.is_uuid() {
                THROW "Invalid topic ID: " + <string>$topic.id;
            };
        };

        -- Validate posts
        FOR $post IN $posts {
            IF !$post.id.is_uuid() {
                THROW "Invalid post ID: " + <string>$post.id;
            };
            IF !$post.authors.is_array() {
                THROW "Authors for a post must be an array - post ID: " + <string>$post.id;
            };
            IF $post.authors.len() == 0 {
                THROW "Post must have at least one author - post ID: " + <string>$post.id;
            };
            IF !$post.topic_ids.is_array() {
                THROW "Topics for a post must be an array - post ID: " + <string>$post.id;
            };
        };

        -- Validate series
        FOR $s IN $series {
            IF !$s.id.is_uuid() {
                THROW "Invalid series ID: " + <string>$s.id;
            };
            IF !$s.topic_ids.is_array() {
                THROW "Topics for a series must be an array - series ID: " + <string>$s.id;
            };
            IF !$s.post_ids.is_array() {
                THROW "Posts for a series must be an array - series ID: " + <string>$s.id;
            };
        };

        -- TODO: Update stuff
        LET $update_id = rand::uuid();

        -- UPDATE topics - mark them as not deleted to un-delete previously deleted topics that
        -- match the ID
        FOR $topic IN $topics {
            LET $topic_id = type::thing("topic", $topic.id);
            UPSERT $topic_id CONTENT {
                name: $topic.name,
                description: $topic.description,
                slug: $topic.slug,
                deleted_at: NONE,
                last_update_id: $update_id
            };
        };

        -- Detect deleted topics
        LET $topics_to_delete = (SELECT VALUE id FROM topic WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $topics_to_delete SET deleted_at = time::now();

        -- UPDATE posts - mark them as not deleted to un-delete previously deleted posts that
        -- match the ID
        FOR $post IN $posts {
            LET $post_id = type::thing("post", $post.id);
            UPSERT $post_id SET
                title = $post.title,
                description = $post.description,
                slug = $post.slug,
                featured = $post.featured,
                obsolete = $post.obsolete,
                draft = $post.draft,
                learnable = $post.learnable,
                og_image = $post.og_image,
                published_on = $post.published_on,
                published_at = $post.published_at,
                last_updated = $post.published_at,
                updates = $post.updates,
                deleted_at = NONE,
                last_update_id = $update_id
            ;

            FOR $author_id_string IN $post.authors {
                LET $author_id = (SELECT VALUE id FROM user WHERE author_id == $author_id_string LIMIT 1)[0];
                IF !$author_id {
                    THROW "Invalid author ID: " + <string>$author_id_string + " - post ID: " + <string>$post.id;
                };

                LET $existing_relation = (SELECT VALUE id FROM authored WHERE in == $author_id AND out == $post_id LIMIT 1);
                IF !$existing_relation {                    
                    RELATE $author_id->authored->$post_id SET
                        last_update_id = $update_id
                    ;
                }
                ELSE {
                    IF !$post_id.exists() {
                        THROW "Invalid post ID: " + (<string>$post_id);
                    };
                    UPDATE $existing_relation SET
                        last_update_id = $update_id
                    ;
                };
            };

            FOR $topic_id_string IN $post.topic_ids {
                LET $topic_id = type::thing("topic", $topic_id_string);
                LET $existing_relation = (SELECT VALUE id FROM is_about WHERE in == $post_id AND out == $topic_id LIMIT 1);
                IF !$existing_relation {
                    RELATE $post_id->is_about->$topic_id SET
                        last_update_id = $update_id
                    ;
                }
                ELSE {
                    IF !$topic_id.exists() {
                        THROW "Invalid topic ID: " + (<string>$topic_id);
                    };
                    UPDATE $existing_relation SET
                        last_update_id = $update_id
                    ;
                };
            };
        };

        -- Detect deleted posts
        LET $posts_to_delete = (SELECT VALUE id FROM post WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $posts_to_delete SET deleted_at = time::now();

        -- Detect deleted user->authored->post relations
        LET $authored_relations_to_delete = (SELECT VALUE id FROM authored WHERE last_update_id != $update_id);
        DELETE $authored_relations_to_delete;
        

        -- UPDATE series - mark them as not deleted to un-delete previously deleted series that
        -- match the ID
        FOR $s IN $series {
            LET $series_id = type::thing("series", $s.id);
            UPSERT $series_id CONTENT {
                name: $s.name,
                description: $s.description,
                slug: $s.slug,
                deleted_at: NONE,
                last_update_id: $update_id
            };

            FOR $topic_id_string IN $s.topic_ids {
                LET $topic_id = type::thing("topic", $topic_id_string);
                LET $existing_relation = (SELECT VALUE id FROM is_about WHERE in == $series_id AND out == $topic_id LIMIT 1);
                IF !$existing_relation {
                    RELATE $series_id->is_about->$topic_id SET
                        last_update_id = $update_id
                    ;
                }
                ELSE {
                    IF !$topic_id.exists() {
                        THROW "Invalid topic ID: " + (<string>$topic_id);
                    };
                    UPDATE $existing_relation SET
                        last_update_id = $update_id
                    ;
                };
            };

            FOR $post_id_string IN $s.post_ids {
                LET $post_id = type::thing("post", $post_id_string);
                LET $existing_relation = (SELECT VALUE id FROM contains WHERE in == $series_id AND out == $post_id LIMIT 1);
                IF !$existing_relation {
                    RELATE $series_id->contains->$post_id SET
                        last_update_id = $update_id
                    ;
                }
                ELSE {
                    IF !$post_id.exists() {
                        THROW "Invalid post ID: " + (<string>$post_id);
                    };
                    UPDATE $existing_relation SET
                        last_update_id = $update_id
                    ;
                };
            };
        };

        -- Detect deleted series
        LET $series_to_delete = (SELECT VALUE id FROM series WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $series_to_delete SET deleted_at = time::now();

        -- Detect deleted series->contains->post relations
        LET $contains_relations_to_delete = (SELECT VALUE id FROM contains WHERE last_update_id != $update_id);
        DELETE $contains_relations_to_delete;

        -- Detect deleted something->is_about->topic relations
        LET $about_topic_relations_to_delete = (SELECT VALUE id FROM is_about WHERE last_update_id != $update_id);
        DELETE $about_topic_relations_to_delete;


        -- Detect invalid relations - relations not marked as deleted but pointing frot/to a deleted record
        -- This signifies invalid input data

        -- is_about relations
        LET $invalid_is_about_relations = (SELECT in.id AS in_id, out.id AS out_id FROM is_about WHERE in.deleted_at OR out.deleted_at);
        IF $invalid_is_about_relations.len() > 0 {
            THROW "Invalid is_about relations detected: " + <string>$invalid_is_about_relations;
        };

        -- contains relations
        LET $invalid_contains_relations = (SELECT in.id AS in_id, out.id AS out_id FROM contains WHERE in.deleted_at OR out.deleted_at);
        IF $invalid_contains_relations.len() > 0 {
            THROW "Invalid contains relations detected: " + <string>$invalid_contains_relations;
        };

        return true;
    }
;