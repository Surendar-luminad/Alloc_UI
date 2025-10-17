-- Create tables for ScraperFlowTrack application

-- Sessions table (for authentication)
CREATE TABLE IF NOT EXISTS sessions (
    sid VARCHAR PRIMARY KEY,
    sess JSONB NOT NULL,
    expire TIMESTAMP NOT NULL
);
CREATE INDEX IF NOT EXISTS IDX_session_expire ON sessions(expire);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR UNIQUE,
    first_name VARCHAR,
    last_name VARCHAR,
    profile_image_url VARCHAR,
    role VARCHAR DEFAULT 'viewer',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Developers table
CREATE TABLE IF NOT EXISTS developers (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR REFERENCES users(id),
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    skills TEXT[],
    workload_capacity INTEGER DEFAULT 20,
    current_workload INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Scrapers table
CREATE TABLE IF NOT EXISTS scrapers (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    scraper_id VARCHAR NOT NULL UNIQUE,
    priority VARCHAR NOT NULL,
    journal_frequency VARCHAR,
    ts_source_id VARCHAR,
    title TEXT NOT NULL,
    agreement_url TEXT,
    content_website_access_types TEXT,
    content_access_instructions TEXT,
    category VARCHAR NOT NULL,
    project_name VARCHAR,
    complexity_level VARCHAR NOT NULL,
    frequency_term VARCHAR,
    skill_requirements TEXT[],
    last_run_date TIMESTAMP,
    current_status VARCHAR DEFAULT 'Unassigned',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Allocations table
CREATE TABLE IF NOT EXISTS allocations (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    scraper_id VARCHAR REFERENCES scrapers(id),
    developer_id VARCHAR REFERENCES developers(id),
    assigned_date TIMESTAMP DEFAULT NOW(),
    reassigned_date TIMESTAMP,
    expected_completion_date TIMESTAMP,
    comments TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Status Changes table
CREATE TABLE IF NOT EXISTS status_changes (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    scraper_id VARCHAR REFERENCES scrapers(id),
    from_status VARCHAR,
    to_status VARCHAR NOT NULL,
    changed_by VARCHAR REFERENCES users(id),
    comments TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Queries table
CREATE TABLE IF NOT EXISTS queries (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    scraper_id VARCHAR REFERENCES scrapers(id),
    developer_id VARCHAR REFERENCES developers(id),
    title VARCHAR NOT NULL,
    description TEXT NOT NULL,
    developer_comments TEXT,
    query_status VARCHAR DEFAULT 'Open',
    priority VARCHAR DEFAULT 'Medium',
    client_feedback TEXT,
    resolution_comments TEXT,
    resolved_at TIMESTAMP,
    resolved_by VARCHAR REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Packages table
CREATE TABLE IF NOT EXISTS packages (
    id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid(),
    scraper_id VARCHAR REFERENCES scrapers(id),
    package_generated_by VARCHAR REFERENCES developers(id),
    package_generation_status VARCHAR DEFAULT 'Pending',
    package_generation_start_date TIMESTAMP,
    package_generation_end_date TIMESTAMP,
    package_validated_by VARCHAR REFERENCES developers(id),
    package_validation_status VARCHAR DEFAULT 'Pending',
    package_validation_start_date TIMESTAMP,
    package_validation_end_date TIMESTAMP,
    package_validation_comments TEXT,
    deployed_by VARCHAR REFERENCES developers(id),
    deployment_status VARCHAR DEFAULT 'Pending',
    deployment_date TIMESTAMP,
    rework_required BOOLEAN DEFAULT false,
    rework_comments TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert a default local development user
INSERT INTO users (id, email, first_name, last_name, role) 
VALUES ('local-dev-user', 'dev@localhost.com', 'Local', 'Developer', 'admin')
ON CONFLICT (id) DO NOTHING;

COMMIT;