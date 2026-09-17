# Stage 1: Build Angular Frontend
FROM node:20-slim AS ui-builder
WORKDIR /app/src-ui
COPY src-ui/package.json src-ui/pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile
COPY src-ui/ .
RUN pnpm ng build --configuration production

# Stage 2: Application Container
FROM python:3.11-slim

# Install system dependencies & Redis
RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-server \
    tesseract-ocr \
    poppler-utils \
    unpaper \
    ffmpeg \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

WORKDIR /app
COPY . .

# Copy frontend static build into Django static directory
COPY --from=ui-builder /app/src-ui/dist /app/src/static/ui

# Store a template seed copy of your current SQLite database
RUN mkdir -p /app/seed
COPY src/db.sqlite3 /app/seed/db.sqlite3

EXPOSE 8000
ENTRYPOINT ["/app/entrypoint.sh"]
