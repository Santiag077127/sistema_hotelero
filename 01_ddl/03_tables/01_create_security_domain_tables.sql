-- Security domain
CREATE TABLE person (
  id BIGSERIAL PRIMARY KEY,
  document_type VARCHAR(30) NOT NULL,
  document_number VARCHAR(40) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(40),
  email VARCHAR(160),
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_person_document UNIQUE (document_type, document_number),
  CONSTRAINT uk_person_email UNIQUE (email)
);

CREATE TABLE app_role (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(255),
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_app_role_name UNIQUE (name)
);

CREATE TABLE permission (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(255),
  action VARCHAR(80) NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_permission_name_action UNIQUE (name, action)
);

CREATE TABLE module (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  base_path VARCHAR(160) NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_module_name UNIQUE (name),
  CONSTRAINT uk_module_base_path UNIQUE (base_path)
);

CREATE TABLE app_view (
  id BIGSERIAL PRIMARY KEY,
  module_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(255),
  path VARCHAR(180) NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_app_view_module_path UNIQUE (module_id, path),
  CONSTRAINT fk_app_view_module FOREIGN KEY (module_id) REFERENCES module (id)
);

CREATE TABLE app_user (
  id BIGSERIAL PRIMARY KEY,
  person_id BIGINT NOT NULL,
  username VARCHAR(80) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  last_access_at TIMESTAMP,
  is_blocked BOOLEAN NOT NULL DEFAULT FALSE,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_app_user_person UNIQUE (person_id),
  CONSTRAINT uk_app_user_username UNIQUE (username),
  CONSTRAINT fk_app_user_person FOREIGN KEY (person_id) REFERENCES person (id)
);

CREATE TABLE user_role (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_user_role UNIQUE (user_id, role_id),
  CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES app_user (id),
  CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES app_role (id)
);

CREATE TABLE role_permission (
  id BIGSERIAL PRIMARY KEY,
  role_id BIGINT NOT NULL,
  permission_id BIGINT NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_role_permission UNIQUE (role_id, permission_id),
  CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id) REFERENCES app_role (id),
  CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id) REFERENCES permission (id)
);

CREATE TABLE module_view (
  id BIGSERIAL PRIMARY KEY,
  module_id BIGINT NOT NULL,
  view_id BIGINT NOT NULL,
  created_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by BIGINT,
  updated_at TIMESTAMP,
  deleted_by BIGINT,
  deleted_at TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  CONSTRAINT uk_module_view UNIQUE (module_id, view_id),
  CONSTRAINT fk_module_view_module FOREIGN KEY (module_id) REFERENCES module (id),
  CONSTRAINT fk_module_view_view FOREIGN KEY (view_id) REFERENCES app_view (id)
);