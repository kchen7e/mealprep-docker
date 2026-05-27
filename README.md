# MealPrep Docker

Docker Compose orchestration for the full MealPrep stack — frontend, backend, database, and MinIO object storage.

**Backend version:** 0.8.0 | **Frontend version:** 0.4.0 | **Database:** PostgreSQL 15 | **Storage:** MinIO

## Services

| Service | Image | Port | Description |
|---|---|---|---|
| `mealprep-frontend` | Built from `../mealprep-frontend` | `3000` | Vite dev server (mapped from 5173) |
| `mealprep-backend` | Built from `../mealprep-backend` | `8080` | Spring Boot REST API |
| `mealprep-db` | `postgres:15-alpine` | `5432` | PostgreSQL database |
| `mealprep-minio` | `minio/minio:latest` | `9000`, `9001` | S3-compatible object storage + console |

All services share the `mealprep` Docker network. The database and MinIO use the `always` restart policy; frontend and backend use `no`.

## Quick Start

```bash
# From the mealprep-docker directory
docker compose up --build
```

Wait for all services to start, then access:

| URL | Service |
|---|---|
| `http://localhost:3000` | Frontend |
| `http://localhost:8080` | Backend API |
| `http://localhost:9001` | MinIO Console (login: `minioadmin` / `minioadmin`) |

## Configuration

Copy `.env` and adjust for your environment:

```bash
cp .env.example .env   # if you create one, or edit .env directly
```

### Database

| Variable | Default | Description |
|---|---|---|
| `POSTGRES_USER` | `app` | PostgreSQL user |
| `POSTGRES_PASSWORD` | `app` | PostgreSQL password |
| `POSTGRES_DB` | `mealprep` | Database name |

### Backend

| Variable | Default | Description |
|---|---|---|
| `BACKEND_VERSION` | `0.8.0` | JAR version tag |
| `DB_USER` | `app` | DB user for backend |
| `DB_PASSWORD` | `app` | DB password for backend |
| `DB_HOSTNAME` | `mealprep-db` | DB host (container name) |
| `DB_NAME` | `mealprep` | Database name |

### Frontend

| Variable | Default | Description |
|---|---|---|
| `FRONTEND_VERSION` | `0.4.0` | Frontend image tag |
| `REACT_APP_MEALPREP_BACKEND_HOSTNAME` | `mealprep.storm7e.de` | Backend host (from browser) |
| `REACT_APP_MEALPREP_BACKEND_PORT` | `8081` | Backend port (from browser) |

### MinIO

| Variable | Default | Description |
|---|---|---|
| `MINIO_ROOT_USER` | `minioadmin` | MinIO admin username |
| `MINIO_ROOT_PASSWORD` | `minioadmin` | MinIO admin password |

## Volumes

Data is persisted via bind mounts in the project directory:

| Path | Contents |
|---|---|
| `./database/` | PostgreSQL data files |
| `./minio_data/` | MinIO buckets and objects |

Both are git-ignored. To fully reset: `rm -rf database/* minio_data/*`

## Dockerfiles

### Frontend (`mealprep-frontend.Dockerfile`)

Alpine Node image. Copies `mealprep-frontend/` source, installs dependencies, runs Vite dev server. Not suitable for production — use `npm run build` and serve the `build/` directory via nginx for deployment.

### Backend (`mealprep-backend.Dockerfile`)

Eclipse Temurin JDK 21 Alpine. Copies the pre-built JAR and runs it. Build the JAR first via `../mealprep-backend/./gradlew build -x test`, then place the JAR in this directory.

### Database (`mealprep-db.Dockerfile`)

Minimal — just extends `postgres:15-alpine`. All configuration via environment variables and the mounted data directory.

## Architecture Notes

- **Frontend env vars are build-time** — `REACT_APP_*` variables point to the backend from the user's browser. Use the public hostname (e.g., `mealprep.storm7e.de:8081`) in production, or `localhost:8080` for local dev.
- **No startup ordering** — `depends_on` controls container start order but doesn't wait for readiness. The backend may need a restart if the database isn't ready when it first connects.
- **JPA auto-migration** — Hibernate `ddl-auto=update` creates/evolves tables on backend startup. No manual SQL migrations needed.
