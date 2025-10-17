// Minimal server for debugging
import express from "express";
import { createServer } from "http";

const app = express();

app.use(express.json());

// Simple health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    env: process.env.NODE_ENV,
    host: req.get('host'),
    database: process.env.DATABASE_URL ? 'configured' : 'not configured'
  });
});

// Basic test endpoint
app.get('/api/test', (req, res) => {
  res.json({ message: 'Server is working!' });
});

// Serve static files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static('dist/public'));
  
  // Catch-all handler for client-side routing
  app.get('*', (req, res) => {
    res.sendFile(path.join(process.cwd(), 'dist/public/index.html'));
  });
}

const server = createServer(app);
const port = parseInt(process.env.PORT || '5000', 10);
const host = process.env.HOST || '0.0.0.0';

server.listen(port, host, () => {
  console.log(`Minimal server running on ${host}:${port}`);
  console.log(`Environment: ${process.env.NODE_ENV}`);
  console.log(`Health check: http://${host}:${port}/api/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught exception:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled rejection at:', promise, 'reason:', reason);
  process.exit(1);
});