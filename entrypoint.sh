#!/bin/bash
set -e

# Start Redis in the background
redis-server --daemonize yes

# Ensure data directory exists and seed fresh SQLite DB if not present
mkdir -p /app/data
if [ ! -f /app/data/db.sqlite3 ] && [ -f /app/seed/db.sqlite3 ]; then
	echo "Seeding fresh SQLite database..."
	cp /app/seed/db.sqlite3 /app/data/db.sqlite3
fi

export PAPERLESS_CONFIGURATION_PATH="/app/src/paperless.conf"
export PAPERLESS_DATA_DIR="/app/data"
export PYTHONPATH="/app/src:$PYTHONPATH"

echo "Starting Paperless-ngx background services..."
uv run celery --app paperless --workdir src worker -l DEBUG &
uv run python src/manage.py document_consumer &

echo "Starting Web Server..."
exec uv run python src/manage.py runserver 0.0.0.0:8000
