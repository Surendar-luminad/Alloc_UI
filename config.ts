// Database Configuration
export const dbConfig = {
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'Welcome123',
  host: process.env.DB_HOST || '172.18.208.149',
  port: process.env.DB_PORT || '5432',
  database: process.env.DB_DATABASE || 'cengage_pdf2ppt'
};

// Construct DATABASE_URL for the application
export const DATABASE_URL = process.env.DATABASE_URL || `postgres://${dbConfig.user}:${dbConfig.password}@${dbConfig.host}:${dbConfig.port}/${dbConfig.database}`;

// Set environment variables only if not already set
if (!process.env.DATABASE_URL) {
  process.env.DATABASE_URL = DATABASE_URL;
}

// Server configuration
const port = process.env.PORT || '20020';
const host = process.env.HOST || '0.0.0.0';

// Environment-specific configuration
if (process.env.NODE_ENV === 'production') {
  // Production environment variables
  process.env.SESSION_SECRET = process.env.SESSION_SECRET || 'change-this-in-production-' + Math.random().toString(36);
  process.env.ISSUER_URL = process.env.ISSUER_URL || 'https://replit.com/oidc';
} else {
  // Development environment variables
  process.env.REPLIT_DOMAINS = `localhost:${port}`;
  process.env.REPL_ID = 'local-dev-app';
  process.env.SESSION_SECRET = process.env.SESSION_SECRET || 'your-super-secret-session-key-change-this-in-production';
  process.env.ISSUER_URL = process.env.ISSUER_URL || 'https://replit.com/oidc';
}

console.log(`Configuration loaded for ${process.env.NODE_ENV || 'development'} environment`);
console.log(`Server will run on ${host}:${port}`);
console.log(`Database: ${DATABASE_URL.replace(/:\/\/[^:]+:[^@]+@/, '://***:***@')}`);