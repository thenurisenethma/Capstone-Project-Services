#!/bin/bash
export HOME=/var/lib/docker-creds
mkdir -p $HOME
docker-credential-gcr configure-docker --registries=asia-south1-docker.pkg.dev

iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
iptables -I INPUT -p tcp --dport 8001 -j ACCEPT
iptables -I INPUT -p tcp --dport 8002 -j ACCEPT

docker run -d --restart=always --network=host \
  --name cloud-sql-proxy \
  gcr.io/cloud-sql-connectors/cloud-sql-proxy:latest \
  --address=0.0.0.0 --port=5432 eca-capstone-2026:asia-south1:eca-postgres \
  --port=3306 eca-capstone-2026:asia-south1:eca-mysql

sleep 10

docker run -d --restart=always --network=host \
  --name student-service \
  -e SERVER_PORT=8000 \
  -e DB_PASSWORD='}|2^k3I"03}\1:r}' \
  -e EUREKA_URL=http://10.160.0.2:9001/eureka \
  -e CONFIG_URI=http://10.160.0.8:9000 \
  asia-south1-docker.pkg.dev/eca-capstone-2026/eca-repo/student-service

docker run -d --restart=always --network=host \
  --name enrollment-service \
  -e SERVER_PORT=8002 \
  -e DB_PASSWORD='1212mysql1212' \
  -e EUREKA_URL=http://10.160.0.2:9001/eureka \
  -e CONFIG_URI=http://10.160.0.8:9000 \
  asia-south1-docker.pkg.dev/eca-capstone-2026/eca-repo/enrollment-service

docker run -d --restart=always --network=host \
  --name program-service \
  -e SERVER_PORT=8001 \
  -e MONGO_URI='mongodb://eca_admin:1212mongodb1212@10.160.0.9:27017/eca?authSource=admin' \
  -e EUREKA_URL=http://10.160.0.2:9001/eureka \
  -e CONFIG_URI=http://10.160.0.8:9000 \
  asia-south1-docker.pkg.dev/eca-capstone-2026/eca-repo/program-service