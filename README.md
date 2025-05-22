# Task Management API

Una API de gestión de tareas desarrollada con Ruby on Rails que proporciona endpoints para administrar usuarios y tareas.

## Tecnologías

- Ruby 3.x
- Rails 8.0.2
- PostgreSQL 15
- Docker & Docker Compose
- Autenticación con BCrypt
- Pruebas con RSpec, Factory Bot y Shoulda Matchers
- Documentación API con Rswag
- Paginación con Pagy
- Active Model Serializers

## Estructura del proyecto

El proyecto sigue la arquitectura MVC de Rails con una capa adicional de servicios:

- **Modelos**: Representan los datos y la lógica de negocio
  - `User`: Gestión de usuarios con roles (usuario/admin)
  - `Task`: Gestión de tareas con estados (pendiente/en progreso/completada/cancelada)

- **Controladores**: Manejan las solicitudes HTTP y responden con JSON
  - `Api::UsersController`: CRUD para usuarios
  - `Api::TasksController`: CRUD para tareas

- **Servicios**: Encapsulan la lógica de negocio
  - Servicios para manejo de usuarios y tareas

## Instalación y configuración

### Requisitos previos

- Docker y Docker Compose
- Git

### Pasos para instalar

1. Clonar el repositorio:
   ```
   git clone <url-del-repositorio>
   cd inetum
   ```

2. Iniciar los contenedores con Docker Compose:
   ```
   docker-compose up -d
   ```

3. Crear y migrar la base de datos:
   ```
   docker-compose exec web rails db:create db:migrate
   ```

4. (Opcional) Cargar datos de ejemplo:
   ```
   docker-compose exec web rails db:seed
   ```

## Endpoints de API

### Usuarios

- `GET /api/users`: Listar todos los usuarios (paginado)
- `GET /api/users/:id`: Mostrar un usuario específico
- `POST /api/users`: Crear un nuevo usuario

### Tareas

- `GET /api/tasks`: Listar todas las tareas (paginado)
- `GET /api/tasks/:id`: Mostrar una tarea específica
- `POST /api/tasks`: Crear una nueva tarea
- `PUT/PATCH /api/tasks/:id`: Actualizar una tarea existente
- `DELETE /api/tasks/:id`: Eliminar una tarea

## Estructura de la base de datos

- **Users**: Almacena la información de los usuarios
  - email (string, único)
  - full_name (string)
  - role (enum: user, admin)
  - password_digest (string)

- **Tasks**: Almacena la información de las tareas
  - title (string)
  - description (text)
  - status (enum: pending, in_progress, completed, cancelled)
  - due_date (datetime)
  - user_id (foreign key)

## Ejecutar pruebas

```
docker-compose exec web bundle exec rspec
```

## Documentación de la API

La documentación de la API está disponible a través de Swagger UI:

```
http://localhost:3000/api-docs
```
