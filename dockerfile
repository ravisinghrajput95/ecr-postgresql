# Use the official PostgreSQL image
FROM postgres:16.3-alpine3.20

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=root
ENV POSTGRES_DB=demo

# Expose the PostgreSQL port
EXPOSE 5432