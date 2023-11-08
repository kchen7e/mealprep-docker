### Create a .env file and define following variables

## Database

#### config database, this sets up credentials and default DB for backend to access

POSTGRES_USER=app

POSTGRES_PASSWORD=app

POSTGRES_DB=mealprep


## Frontend

##### please sure `mealprep-front` (produced by `npm run build` in the frontend project) is present in current folder
#### config frontend docker image

FRONTEND_VERSION=0.2

#### config frontend, this will be used to connect to backend API

REACT_APP_MEALPREP_BACKEND_HOSTNAME=mealprep.storm7e.de

#### this might be different from mealprep-backend service in docker-compose.yaml if backend is deployed behind a reverse proxy

REACT_APP_MEALPREP_BACKEND_PORT=8081

## Backend

#### config backend docker image

BACKEND_VERSION=0.5.1

#### config backend, this will be used by backend to access DB

DB_USER=app

DB_PASSWORD=app

DB_HOSTNAME=mealprep-db #should be DB container name

DB_NAME=mealprep
