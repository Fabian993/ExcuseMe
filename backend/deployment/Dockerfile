FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /usr/src/app

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential libpq-dev curl \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && rm -rf /var/lib/apt/lists/* 

ENV PATH="/root/.cargo/bin:/root/.local/bin:$PATH"

#Direct install from requirements.txt
COPY src/requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system -r requirements.txt --no-cache

COPY deployment/scripts /app/deployment/scripts
RUN chmod -R +x /app/deployment/scripts/*

COPY src/ ./
