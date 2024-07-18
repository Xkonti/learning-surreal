# USERS

CREATE user:xkonti SET name= "Xkonti";

# POSTS

CREATE post SET
  author = user:xkonti,
  name = 'Creating Quasar Framework project with Typescript support (pre v1.9.6)',
  slug = 'quasar-framework-with-typescript-pre196',
  tags = [
    "Quasar Framework",
    "Typescript",
    "frontend",
    "tutorial",
    "vue",
    "vuex"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Home automation with HubHazard',
  slug = 'home-automation-with-hubhazard',
  tags = [
    "HubHazard",
    "automation",
    "smart home",
    "hubitat",
    "raspberry pi"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Starting with HubHazard',
  slug = 'starting-with-hubhazard',
  tags = [
    "HubHazard",
    "automation",
    "smart home",
    "hubitat",
    "raspberry pi"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Creating Quasar Framework project with Typescript support',
  slug = 'quasar-framework-with-typescript',
  tags = [
    "Quasar Framework",
    "Typescript",
    "frontend",
    "tutorial",
    "vue",
    "vuex"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Giving your GPT a long-term memory',
  slug = 'giving-gpt-memory',
  tags = [
    "openai",
    "chatgpt",
    "valtown",
    "javascript",
    "typescript",
    "api"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Creating GPT Actions with ValTown',
  slug = 'gpt-actions-with-val-town',
  tags = [
    "openai",
    "chatgpt",
    "valtown",
    "javascript",
    "typescript",
    "api"
  ];

CREATE post SET
  author = user:xkonti,
  name = 'Adding Mermaid diagrams to Astro MDX',
  slug = 'astro-mermaid-mdx',
  tags = [
    "astro",
    "webdev",
    "markdown",
    "mdx",
    "mermaid"
  ];

# COMMENTS

LET $gptMemoryPostId = (SELECT VALUE id FROM ONLY post WHERE slug = 'giving-gpt-memory' LIMIT 1);

CREATE comment SET
  author = user:xkonti,
  post = $gptMemoryPostId,
  text = 'This article sucks!';

CREATE comment SET
  author = user:xkonti,
  post = $gptMemoryPostId,
  parent = (SELECT VALUE id FROM ONLY comment WHERE text = 'This article sucks!' LIMIT 1),
  text = 'This comment sucks too!';