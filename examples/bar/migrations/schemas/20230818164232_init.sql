-- Add migration script here
BEGIN;

CREATE TABLE IF NOT EXISTS nodes (
    -- Columns --
    id BIGSERIAL,
    content varchar(255),

    -- Constraints --
    PRIMARY KEY (id),
    UNIQUE(content)
);

COMMIT;