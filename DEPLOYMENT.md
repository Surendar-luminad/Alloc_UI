# ScraperTrack Deployment Guide

## Prerequisites

### For Docker Deployment (Recommended)
- Docker installed and running
- Port 20020 available and open in firewall
- Access to PostgreSQL database at `172.18.208.149:5432`

### For Direct Node.js Deployment
- Node.js 20+ installed
- npm or yarn package manager
- Port 20020 available and open in firewall
- Access to PostgreSQL database at `172.18.208.149:5432`

## Database Configuration

The application connects to:
- **Host**: 172.18.208.149
- **Port**: 5432
- **Database**: cengage_pdf2ppt
- **Username**: postgres
- **Password**: Welcome123

## Deployment Options

### Option 1: Docker Deployment (Linux/macOS)

1. Make the script executable:
   ```bash
   chmod +x run.sh
   ```

2. Run the deployment script:
   ```bash
   ./run.sh
   ```

3. Access the application:
   - Local: http://localhost:20020
   - External: http://YOUR_SERVER_IP:20020

### Option 2: Docker Deployment (Windows)

1. Run the PowerShell script:
   ```powershell
   .\run.ps1
   ```

2. Access the application:
   - Local: http://localhost:20020
   - External: http://YOUR_SERVER_IP:20020

### Option 3: Direct Node.js Deployment

1. Install dependencies:
   ```bash
   npm ci
   ```

2. Build the application:
   ```bash
   npm run build
   ```

3. Set up the database:
   ```bash
   npm run db:setup
   ```

4. Start the production server:
   ```bash
   npm run start:prod
   ```

## Environment Variables

You can customize the deployment by setting these environment variables:

```bash
export NODE_ENV=production
export PORT=20020
export HOST=0.0.0.0
export DATABASE_URL=postgresql://postgres:Welcome123@172.18.208.149:5432/cengage_pdf2ppt
export SESSION_SECRET=your-secure-session-secret
export ISSUER_URL=https://replit.com/oidc
export CLIENT_ID=your-oauth-client-id
export CLIENT_SECRET=your-oauth-client-secret
```

## Firewall Configuration

Ensure port 20020 is open in your firewall:

### Linux (ufw):
```bash
sudo ufw allow 20020
```

### Linux (iptables):
```bash
sudo iptables -A INPUT -p tcp --dport 20020 -j ACCEPT
```

### Windows:
```powershell
New-NetFirewallRule -DisplayName "ScraperTrack" -Direction Inbound -Port 20020 -Protocol TCP -Action Allow
```

## Health Checks

### Check if the application is running:
```bash
curl http://localhost:20020/api/health
```

### Check Docker container status:
```bash
docker ps
docker logs scrapertrack
```

### Check application logs:
```bash
docker logs -f scrapertrack
```

## Troubleshooting

### Port Already in Use
```bash
# Find what's using the port
netstat -tlnp | grep 20020
# Or on Windows
netstat -ano | findstr :20020

# Kill the process if needed
kill -9 <PID>
```

### Database Connection Issues
```bash
# Test database connectivity
telnet 172.18.208.149 5432
# Or using nc
nc -zv 172.18.208.149 5432
```

### Docker Issues
```bash
# Restart Docker service
sudo systemctl restart docker

# Clean up Docker resources
docker system prune -a
```

## Production Considerations

1. **Security**:
   - Change default SESSION_SECRET
   - Use proper OAuth credentials
   - Set up HTTPS with reverse proxy (nginx/Apache)
   - Implement proper firewall rules

2. **Monitoring**:
   - Set up log rotation
   - Monitor application health
   - Set up alerts for downtime

3. **Backup**:
   - Regular database backups
   - Application data backups
   - Configuration backups

4. **Updates**:
   - Plan for zero-downtime updates
   - Test updates in staging environment
   - Keep backups before updates

## Support

For issues or questions:
1. Check the logs first
2. Verify database connectivity
3. Ensure all prerequisites are met
4. Check firewall and port configuration