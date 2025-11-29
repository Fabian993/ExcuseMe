#!/bin/bash
set -e #exit on error

# Run migrations, collect static files and start server
if [ "$APP_ENV" != "prod" ]; then
    uv run python manage.py makemigrations --noinput
    uv run python manage.py migrate --noinput
    uv run python manage.py runserver "$APP_HOST":"$APP_PORT"
else
    uv run python manage.py makemigrations --noinput
    uv run python manage.py migrate --noinput
    uv run python manage.py collectstatic --noinput
    uv run gunicorn "$APP_NAME".wsgi:application --bind "$APP_HOST":"$APP_PORT" --workers 3 --log-level=info
fi
