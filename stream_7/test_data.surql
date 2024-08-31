-- GENERATE TEST USERS
LET $userCount: int = 5;
LET $users: array<record<user>> = (<array> 1..=$userCount).map(|$i| type::thing("user", "test" + <string> $i));
LET $authors: array<{id: record<user>, username: string, email: string}> = $users.map(|$user: record<user>| {
    id: $user,
    username: $user.id(),
    email: $user.id() + "@xkonti.tech"
});

INSERT INTO user $authors;

-- GENERATE TEST POSTS
LET $postCount: int = 2000;
LET $posts: array<object> = (<array> 1..=$postCount).map(|$i: int| {
    id: type::thing("post", "post" + <string> $i),
    title: "Post " + <string> $i,
    description: "...",
    slug: "post-" + <string> $i,
    obsolete: false,
    draft: rand::bool(),
    learnable: rand::bool(),
    og_image: "wololo.png",
    published_at: rand::time()
});

INSERT INTO post $posts;

LET $batchSize: int = ($postCount / $userCount);
LET $batches = array::clump($posts.id, $batchSize);
FOR $user IN $users {
    LET $i: int = array::find_index($users, $user);
    // maybe replace this via INSERT RELATION INTO authored;
    RELATE $user->authored->($batches[$i]);
};

-- GENERATE TEST LIKES
FOR $author in $authors {
    LET $likes_count = rand::int($posts.len() / 10, $posts.len() / 2);
    LET $posts_to_like = (<array>0..$likes_count).map(|$i| type::thing("post", "post" + <string>rand::int(1, 2000))).distinct();
    
    FOR $post_to_like IN $posts_to_like {
        RELATE ($author.id)->liked->$post_to_like;
    };
};



CREATE comment SET
    content = "Give up already!",
    author = $auth,
    post = post:post2
;

RELATE user:user_2kg38yfLgcs5xwqbzLfcmRzAHp8->approved->comment:xngvv5un5ofefxmrtuq3;

# Calculate likes_count and comments_count for each post
UPDATE post SET
    likes_count = (SELECT count() AS count FROM liked WHERE out.id == $parent.id GROUP ALL)[0].count OR 0,
    comments_count = (SELECT count() AS count FROM comment WHERE post.id == $parent.id AND approved == true GROUP ALL)[0].count OR 0
;