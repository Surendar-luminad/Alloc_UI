import pg from 'pg';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Database configuration
const dbConfig = {
  user: 'postgres',
  password: 'Welcome123',
  host: '172.18.208.149',
  port: '5432',
  database: 'cengage_pdf2ppt'
};
const DATABASE_URL = `postgres://${dbConfig.user}:${dbConfig.password}@${dbConfig.host}:${dbConfig.port}/${dbConfig.database}`;
process.env.DATABASE_URL = DATABASE_URL;

const { Client } = pg;

async function setupDatabase() {
  const client = new Client({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    await client.connect();
    console.log('Connected to PostgreSQL database');

    // Read and execute the SQL setup script
    const sqlScript = fs.readFileSync(path.join(__dirname, 'setup-database.sql'), 'utf8');
    
    await client.query(sqlScript);
    console.log('Database tables created successfully!');
    
  } catch (error) {
    console.error('Error setting up database:', error);
  } finally {
    await client.end();
  }
}

setupDatabase();