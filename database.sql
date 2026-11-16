DROP TABLE IF EXISTS blogs;
DROP TABLE IF EXISTS discussions;
DROP TABLE IF EXISTS exercises;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS certificates;
DROP TABLE IF EXISTS program_completions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS teaching_groups;
DROP TABLE IF EXISTS program_modules;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS course_modules;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS modules;

DROP TYPE IF EXISTS roles;
DROP TYPE IF EXISTS subscription_status;
DROP TYPE IF EXISTS payment_status;
DROP TYPE IF EXISTS completion_status;
DROP TYPE IF EXISTS blog_status;

CREATE TYPE roles AS ENUM('student', 'tutor', 'admin');
CREATE TYPE subscription_status AS ENUM ('active', 'pending', 'cancelled', 'completed');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE completion_status AS ENUM ('active', 'completed', 'pending', 'cancelled');
CREATE TYPE blog_status AS ENUM ('created', 'in moderation', 'published', 'archived');

CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE course_modules (
    module_id BIGINT REFERENCES modules (id),
    course_id BIGINT REFERENCES courses (id),
    PRIMARY KEY (module_id, course_id)
);

CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    content TEXT NOT NULL,
    video_url VARCHAR(64) NOT NULL,
    position SMALLINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    course_id BIGINT NOT NULL REFERENCES courses (id),
    deleted_at TIMESTAMP
);

CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    program_type VARCHAR(32) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_modules (
    module_id BIGINT REFERENCES modules (id),
    program_id BIGINT REFERENCES programs (id),
    PRIMARY KEY (program_id, module_id)
);

CREATE TABLE teaching_groups (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slug VARCHAR(32) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(32) NOT NULL,
    email VARCHAR(32) NOT NULL,
    password_hash VARCHAR(32) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    teaching_group_id BIGINT NOT NULL REFERENCES teaching_groups (id),
    role roles NOT NULL
);

CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    program_id BIGINT NOT NULL REFERENCES programs (id),
    status subscription_status NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id BIGINT NOT NULL REFERENCES enrollments (id),
    amount NUMERIC(10, 2) NOT NULL,
    status payment_status NOT NULL,
    paid_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_completions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    program_id BIGINT NOT NULL REFERENCES programs (id),
    status completion_status NOT NULL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE certificates (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id),
    program_id BIGINT NOT NULL REFERENCES programs (id),
    url VARCHAR(64) NOT NULL,
    issued_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE quizzes (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT NOT NULL REFERENCES lessons (id),
    name VARCHAR(32) NOT NULL,
    content JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT NOT NULL REFERENCES lessons (id),
    name VARCHAR(32) NOT NULL,
    url VARCHAR(64) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT NOT NULL REFERENCES lessons (id),
    user_id BIGINT NOT NULL REFERENCES users (id), 
    text JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE blogs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL REFERENCES users (id), 
    name VARCHAR(32) NOT NULL,
    content TEXT NOT NULL,
    status blog_status NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);