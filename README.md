# Centro de Entrenamiento E-Sports — Sistema de Información

Sistema de gestión para el centro de entrenamiento e-sports ubicado en Medellín.

## Stack Tecnológico

- **Backend:** Python 3.10+ · Django 4.2+ · Django REST Framework
- **Documentación API:** CoreAPI (`/docs/`)
- **Base de datos:** SQL Server 2019+ (Autenticación Windows)
- **Front-end:** HTML · CSS · JavaScript

## Instalación

1. Clona el repositorio e instala el entorno virtual en `backend/`.
2. Configura tu `.env` a partir de `.env.example`.
3. Ejecuta los scripts SQL de la carpeta `database/` en tu servidor SQL Server.
4. Genera las tablas de Django: `cd backend` y luego `python manage.py migrate`
5. Crea un superusuario: `python manage.py createsuperuser`
6. Inicia el servidor de backend: `python manage.py runserver`
7. Para el frontend, usa una extensión como Live Server en VS Code para abrir `frontend/index.html`.

## Estructura

- `backend/api`: Modelos ORM, serializadores y ViewSets de DRF.
- `database/`: Scripts DDL y datos predefinidos para MSSQL.
- `frontend/`: Interfaz gráfica independiente.

## URLs

- `http://localhost:8000/api/v1/`: Raíz de API
- `http://localhost:8000/docs/`: Documentación
- `http://localhost:8000/admin/`: Admin Django
- `http://localhost:5500/`: Interfaz de usuario
