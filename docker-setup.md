# Quick setup with Docker PostgreSQL
docker run --name scraperflow-postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=scraperflowtrack -p 5432:5432 -d postgres:15

# Then update your .env file:
# DATABASE_URL=postgresql://postgres:password@localhost:5432/scraperflowtrack