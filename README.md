# Deploying a Flask and React Microservice to AWS ECS

## Build Docker images and set tag

### API
```
docker build \
        -f services/users/Dockerfile \
        -t 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-api:dev \
        ./services/users
```

### Client
```
docker build \
        -f services/client/Dockerfile \
        -t 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-client:dev \
        ./services/client
```

## Login to ECR docker

```
aws ecr get-login-password --region eu-central-1 \
     | docker login --username AWS --password-stdin 027485240632.dkr.ecr.eu-central-1.amazonaws.com
```


## Push Docker images
```
docker push 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-client:dev

docker push 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-api:dev
```


## Create prod docker build

### DB
services/db/Dockerfile
```
# pull official base image
FROM postgres:14-alpine

# run create.sql on init
ADD create.sql /docker-entrypoint-initdb.d
```

services/users/db/create.sql
```
CREATE DATABASE api_prod;
CREATE DATABASE api_dev;
CREATE DATABASE api_test;
```


### Flask

services/users/Dockerfile.prod

```
# pull official base image
FROM python:3.10.3-slim-buster

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat \
  && apt-get clean

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# add app
COPY . .

# run server
CMD gunicorn -b 0.0.0.0:5000 manage:app
```


### React

services/client/Dockerfile.prod
```
###########
# BUILDER #
###########

# pull official base image
FROM node:18-alpine as builder

# set working directory
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci
RUN npm install react-scripts@5.0.0 --silent


# set environment variables
ARG REACT_APP_API_SERVICE_URL
ENV REACT_APP_API_SERVICE_URL $REACT_APP_API_SERVICE_URL
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

# create build
COPY . .
RUN npm run build


#########
# FINAL #
#########

# base image
FROM nginx:stable-alpine

# update nginx conf
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

# copy static files
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# expose port
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]
```


### Docker-compose prod file
```
version: '3.8'

services:

  api:
    build:
      context: ./services/users
      dockerfile: Dockerfile.prod
    ports:
      - 5004:5000
    environment:
      - FLASK_ENV=production
      - APP_SETTINGS=src.config.ProductionConfig
      - DATABASE_URL=postgres://postgres:postgres@api-db:5432/api_prod
      - DATABASE_TEST_URL=postgres://postgres:postgres@api-db:5432/api_test
      - SECRET_KEY=my_precious
    depends_on:
      - api-db

  api-db:
    build:
      context: ./services/db
      dockerfile: Dockerfile
    expose:
      - 5432
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres

  client:
    build:
      context: ./services/client
      dockerfile: Dockerfile.prod
      args:
        - NODE_ENV=production
        - REACT_APP_API_SERVICE_URL=${REACT_APP_API_SERVICE_URL}
    ports:
      - 3007:80
    depends_on:
      - api
```


## Test these steps

```
export REACT_APP_API_SERVICE_URL=http://localhost:5004

docker-compose -f docker-compose.prod.yml up -d --build

```

## Push prod to ECR

###

```
docker build \
  -f services/users/Dockerfile.prod \
  -t 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-api:prod \
  ./services/users


$ docker build \
  -f services/client/Dockerfile.prod \
  -t 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-client:prod \
  --build-arg NODE_ENV=production \
  --build-arg REACT_APP_API_SERVICE_URL=${REACT_APP_API_SERVICE_URL} \
  ./services/client


$ docker push 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-api:prod


$ docker push 027485240632.dkr.ecr.eu-central-1.amazonaws.com/sysblink-client:prod

```


###  Needs to create ALB
```
name: sysblink-alb
scheme: internet-facing
address type: ipv4

- attach new security group

-- inbound rules:
0.0.0.0:80 -> 0.0.0.0/0 // HTTP
0.0.0.0:22 -> 0.0.0.0/0 // SSH

- add Listener for HTTP:80

- create new target group
name: client-target-group
port: 80
health checks: /

name: api-target-group
port: 5000
health checks: /ping

- review and create alb

- post creation:

- add listener roule with condition if pathname is /ping or /doc or /api* redirect to api-target-group
```

Navigate to Amazon EC2 --> Load Balancers --> Create Load Balancer


### Create Target groups

### Create Listener and set rules to specific target groups


### Update codebuild REACT_APP_API_SERVICE_URL

## Create RDS DB

Check status of db

```
aws --region eu-central-1 rds describe-db-instances \
        --db-instance-identifier sysblink-db \
        --query 'DBInstances[].{DBInstanceStatus:DBInstanceStatus}'
```


Get db address
```
aws --region eu-central-1 rds describe-db-instances \
  --db-instance-identifier sysblink-db \
  --query 'DBInstances[].{Address:Endpoint.Address}'
```

Connection string
```
postgres://webapp:rnPf1FLqNYv3RZMkvD8E@sysblink-db.chsku8uc0yt9.eu-west-3.rds.amazonaws.com:5432/api_prod
```

Secret key
```
rVjWSl4XmXA1N52EsaPv70bbxdelzGKs
```

## Create task definitions for api and client

## Create project cluster


terraform apply && terraform output > ../.env.terraform

gh secret set -f ../.env.terraform
