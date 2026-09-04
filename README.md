# Capstone Project Services

Enterprise Cloud Application (ECA) — Microservices

This repository contains the **application microservices** of the Enterprise Cloud Application (ECA) capstone project.

The services are independently developed and maintained as separate Git repositories and are included in this repository using **Git submodules**.

The application consists of three core microservices:

* **Student Service**
* **Program Service**
* **Enrollment Service**

These services communicate with the platform components through the API Gateway, Service Registry, and Config Server and are deployed on **Google Cloud Platform (GCP)**.

---

## Student Information

| **Property**       | **Details**                      |
| ------------------ | -------------------------------- |
| **Student Name**   | Thenuri De Silva                 |
| **Student Number** | 241711056                        |
| **Slack Handle**   | thenurisenethma                  |
| **GCP Project ID** | `eca-capstone-2026`              |

---

## Project Description

The Capstone Project Services repository contains the backend business services of the Enterprise Cloud Application.

The microservices architecture separates application functionality into independently deployable services:

### Student Service

Manages student-related information and operations.

**Port:** `8000`

### Program Service

Manages academic program information and operations.

**Port:** `8001`

### Enrollment Service

Manages student enrollment in academic programs.

**Port:** `8002`

Each service has its own database and application configuration and can be developed, built, and deployed independently.

---

## Architecture

```text id="wl3l4b"
                         Client / Frontend
                                │
                                ▼
                     ┌────────────────────┐
                     │    API Gateway     │
                     │       :7000        │
                     └─────────┬──────────┘
                               │
                 ┌─────────────┼─────────────┐
                 │             │             │
                 ▼             ▼             ▼
          Student Service  Program Service  Enrollment
              :8000            :8001          :8002
                 │                │              │
                 ▼                ▼              ▼
           PostgreSQL          MongoDB          MySQL
```

The services use the platform infrastructure for centralized configuration and service discovery.

```text id="6u8f5c"
              ┌──────────────────────────┐
              │      Platform Layer      │
              │                          │
              │ API Gateway   :7000      │
              │ Config Server :8888      │
              │ Eureka        :9001      │
              └────────────┬─────────────┘
                           │
                           ▼
                 ┌────────────────────┐
                 │  Microservices     │
                 │                    │
                 │ Student    :8000   │
                 │ Program    :8001   │
                 │ Enrollment :8002   │
                 └────────────────────┘
```

---

## Technology Stack

| **Technology**                         | **Version / Purpose**                  |
| -------------------------------------- | -------------------------------------- |
| **Java**                               | 25                                     |
| **Spring Boot**                        | 4.1.0                                  |
| **Spring Cloud**                       | 2025.1.2                               |
| **Spring Data JPA**                    | Database persistence                   |
| **Spring Data MongoDB**                | MongoDB persistence                    |
| **Spring Cloud Config Client**         | Centralized configuration              |
| **Spring Cloud Netflix Eureka Client** | Service discovery                      |
| **Spring Boot Actuator**               | Health and management endpoints        |
| **Maven**                              | Build and dependency management        |
| **Docker**                             | Containerization                       |
| **PostgreSQL**                         | Student Service database               |
| **MongoDB**                            | Program Service database               |
| **MySQL**                              | Enrollment Service database            |
| **Google Cloud Platform**              | Cloud deployment                       |
| **Google Artifact Registry**           | Container image storage                |
| **Google Compute Engine**              | Service deployment                     |
| **Cloud SQL**                          | Managed PostgreSQL and MySQL databases |
| **Git & GitHub**                       | Version control                        |

---

## Microservices

### Student Service

The Student Service manages student records and provides REST APIs for student-related operations.

**Application Port:** `8000`

**Database:** PostgreSQL

Main responsibilities:

* Create student records
* Retrieve student information
* Update student information
* Delete student records
* Manage student-related data

---

### Program Service

The Program Service manages academic programs offered by the application.

**Application Port:** `8001`

**Database:** MongoDB

Main responsibilities:

* Create academic programs
* Retrieve program information
* Update program information
* Delete programs
* Manage program-related data

---

### Enrollment Service

The Enrollment Service manages student enrollment in academic programs.

**Application Port:** `8002`

**Database:** MySQL

Main responsibilities:

* Create enrollments
* Retrieve enrollment information
* Validate student information
* Validate program information
* Manage enrollment records

The Enrollment Service communicates with the Student and Program services when validating enrollment requests.

---

## Google Cloud Platform Deployment

### GCP Project

```text id="m1gl4e"
Project ID: eca-capstone-2026
Region:     asia-south1
```

The microservices are containerized using Docker and deployed on Google Compute Engine.

---

## Services Managed Instance Group

The services are deployed using a Regional Managed Instance Group.

```text id="2qj7oe"
MIG Name: eca-mig-services
Template: eca-services-tmpl-v2
Region:   asia-south1
```

The current service deployment uses a Compute Engine instance in the regional environment.

---

## Container Images

Microservice Docker images are stored in Google Artifact Registry:

```text id="uk8k6y"
asia-south1-docker.pkg.dev/eca-capstone-2026/eca-repo
```

Images include:

```text id="s8x0kc"
student-service
program-service
enrollment-service
```

---

## Database Architecture

The microservices use separate databases according to their application requirements.

```text id="0p7kcm"
Student Service
      │
      ▼
PostgreSQL
Cloud SQL
      │
      │
Program Service
      │
      ▼
MongoDB
      │
      │
Enrollment Service
      │
      ▼
MySQL
Cloud SQL
```

### Cloud SQL

The relational databases are hosted using Google Cloud SQL.

```text id="x5q9nm"
PostgreSQL → Student Service
MySQL      → Enrollment Service
```

The services VM uses the **Cloud SQL Auth Proxy** to securely connect to the Cloud SQL instances.

---

## Service Discovery

The microservices use **Netflix Eureka** for service discovery.

```text id="n6c9qv"
                 Eureka
                :9001
                   │
        ┌──────────┼──────────┐
        │          │          │
        ▼          ▼          ▼
     Student    Program   Enrollment
     Service    Service     Service
```

Each microservice registers with the Service Registry, allowing other services and the API Gateway to discover available instances dynamically.

---

## Centralized Configuration

The microservices use **Spring Cloud Config Client** to retrieve configuration from the centralized Config Server.

```text id="h4g1kd"
             Config Server
                 :8888
                    │
          ┌─────────┼─────────┐
          │         │         │
          ▼         ▼         ▼
       Student   Program   Enrollment
       Config    Config      Config
```

This approach keeps service configuration centralized and avoids duplicating configuration across individual services.

---

## Service Communication

The API Gateway provides the external entry point to the services.

```text id="u9x3ve"
Client
  │
  ▼
API Gateway :7000
  │
  ├── /api/v1/students/** ──────► Student Service
  │
  ├── /api/v1/programs/** ──────► Program Service
  │
  └── /api/v1/enrollments/** ──► Enrollment Service
```

The Gateway uses Eureka service discovery and load-balanced service routing.

---

## Git Submodules

Each microservice is maintained as an independent Git repository and included in this repository using Git submodules.

```text id="y8v2me"
Capstone-Project-Services/
│
├── .gitmodules
├── README.md
│
├── Capstone-Project-Service-Student/
│
├── Capstone-Project-Service-Program/
│
└── Capstone-Project-Service-Enrollment/
```

### Submodule Repositories

| **Service**        | **Repository**                        |
| ------------------ | ------------------------------------- |
| Student Service    | `Capstone-Project-Service-Student`    |
| Program Service    | `Capstone-Project-Service-Program`    |
| Enrollment Service | `Capstone-Project-Service-Enrollment` |

Each service repository contains its own source code, configuration, README, Maven configuration, and Git history.

---

## Getting Started

### Prerequisites

* JDK 25
* Maven
* Docker
* Git
* Google Cloud SDK (for GCP deployment)

### Clone the Repository

Clone the parent repository together with all microservice submodules:

```bash id="7b2n5d"
git clone --recurse-submodules https://github.com/thenurisenethma/Capstone-Project-Services.git
cd Capstone-Project-Services
```

If the repository was cloned without submodules:

```bash id="r3s7wq"
git submodule update --init --recursive
```

---

## Building the Services

Each microservice can be built independently.

### Student Service

```bash id="6j9x2p"
cd Capstone-Project-Service-Student
mvn clean package
```

### Program Service

```bash id="5x1k8a"
cd Capstone-Project-Service-Program
mvn clean package
```

### Enrollment Service

```bash id="q4m8zc"
cd Capstone-Project-Service-Enrollment
mvn clean package
```

For service-specific configuration, API endpoints, and local execution instructions, refer to the README inside each service submodule.

---

## Docker Deployment

Each microservice is packaged as an independent Docker image.

Example:

```bash id="b7d3me"
docker build -t student-service .
```

The images are pushed to Google Artifact Registry and deployed to the GCP environment.

---

## Service Ports

| **Service**        | **Port** | **Database** |
| ------------------ | -------: | ------------ |
| Student Service    |   `8000` | PostgreSQL   |
| Program Service    |   `8001` | MongoDB      |
| Enrollment Service |   `8002` | MySQL        |

---

## Deployment Benefits

The microservices architecture provides:

* **Independent service deployment**
* **Separation of business responsibilities**
* **Independent database management**
* **Dynamic service discovery**
* **Centralized configuration**
* **Containerized deployment**
* **Cloud scalability**
* **Fault isolation**
* **Independent development and version control**

---

## Related Repositories

### Platform

The platform infrastructure is maintained separately in:

`Capstone-Project-Platform`

It contains:

* API Gateway
* Config Server
* Service Registry

### Frontend

The frontend application is maintained separately in:

`Capstone-Project-Webapp`

---

## Author

**Thenuri De Silva**

Enterprise Cloud Application — Capstone Project

**GCP Project ID:** `eca-capstone-2026`
