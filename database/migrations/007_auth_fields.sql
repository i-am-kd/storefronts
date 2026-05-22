-- +goose Up
ALTER TABLE stores ADD COLUMN password_hash VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE stores ADD CONSTRAINT chk_password_hash CHECK (length(password_hash)>0);

-- +goose Down
ALTER TABLE stores DROP CONSTRAINT chk_password_hash;
ALTER TABLE stores DROP COLUMN password_hash;