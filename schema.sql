CREATE TABLE users (
    id BIGSERIAL NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT email_uniq UNIQUE (email)
);
