# Centro de Entrenamiento E-Sports — Sistema de Información

Sistema de gestión para el centro de entrenamiento e-sports de la Alcaldía de Medellín (INDER / Secretaría de la Juventud / Secretaría de Cultura), ubicado en Ciudad del Río.

## Stack Tecnológico

| Capa | Tecnología |
|---|---|
| **Backend** | Python 3.10+ · Django 4.2+ · Django REST Framework 3.14 |
| **Base de datos** | SQL Server 2019+ (autenticación Windows o SQL) |
| **ORM / Driver** | `mssql-django` + `pyodbc` (ODBC Driver 17 for SQL Server) |
| **Documentación API** | CoreAPI interactiva en `/docs/` |
| **Frontend** | HTML5 · CSS3 · JavaScript Vanilla |
| **Variables de entorno** | `python-dotenv` |

---

## Prerrequisitos del sistema

- Python **3.10 o superior**
- **SQL Server 2019+** con ODBC Driver 17 instalado
- [`uv`](https://github.com/astral-sh/uv) *(recomendado)* **o** `pip`
- Extensión **Live Server** de VS Code (para el frontend)
- No se requiere Node.js

---

## Instalación con UV *(recomendado)*

```bash
# 1. Entra a la carpeta del backend
cd backend

# 2. Instala las dependencias con uv
uv pip install -r requirements.txt

# 3. Activa el entorno virtual (Windows PowerShell)
.\.venv\Scripts\activate
```

---

## Instalación alternativa con PIP

```bash
cd backend

# Crea y activa el entorno virtual manualmente
python -m venv .venv
.\.venv\Scripts\activate   # Windows PowerShell

# Instala dependencias
pip install -r requirements.txt
```

---

## Configuración del archivo `.env`

Crea el archivo `backend/.env` con las siguientes variables (puedes copiar `.env.example`):

```env
# Clave secreta de Django (cámbiala en producción)
DJANGO_SECRET_KEY=tu-clave-secreta-aqui

# Modo depuración (True en desarrollo, False en producción)
DEBUG=True

# Base de datos — SQL Server
DB_NAME=esports_center
DB_HOST=localhost
DB_PORT=1433
DB_TRUSTED=yes        # yes = autenticación Windows | no = autenticación SQL

# Solo si DB_TRUSTED=no:
# DB_USER=sa
# DB_PASSWORD=tu_contraseña

# Hosts permitidos (separados por coma)
ALLOWED_HOSTS=localhost,127.0.0.1
```

---

## Configuración de la base de datos

Ejecuta los siguientes scripts SQL en tu servidor SQL Server (en orden):

```bash
# 1. Crear tablas y relaciones
database/schema.sql

# 2. Insertar datos de prueba (mínimo 5 registros por entidad)
database/seed.sql
```

---

## Migraciones, superusuario y servidor

```bash
# Generar y aplicar migraciones de Django
python manage.py migrate

# Crear superusuario para el panel de administración
python manage.py createsuperuser

# Iniciar el servidor de desarrollo
python manage.py runserver
```

---

## URLs de la API y documentación

| URL | Descripción |
|---|---|
| `http://localhost:8000/api/v1/` | Raíz de la API REST |
| `http://localhost:8000/api/v1/plataformas/` | CRUD de plataformas |
| `http://localhost:8000/api/v1/juegos/` | CRUD de juegos |
| `http://localhost:8000/api/v1/equipos/` | CRUD de equipos |
| `http://localhost:8000/docs/` | **Documentación interactiva CoreAPI** |
| `http://localhost:8000/admin/` | Panel de administración Django |

---

## Ejecución del frontend

1. Abre la carpeta del proyecto en **VS Code**.
2. Haz clic derecho sobre `frontend/index.html`.
3. Selecciona **"Open with Live Server"**.
4. El frontend se abrirá en `http://127.0.0.1:5500` y consumirá automáticamente la API en el puerto 8000.

> ⚠️ El backend (`python manage.py runserver`) debe estar activo antes de abrir el frontend.

---

## Estructura del proyecto

```
esports-center/
├── backend/
│   ├── api/
│   │   ├── models/          # Un modelo ORM por entidad
│   │   ├── serializers/     # Un ModelSerializer por entidad
│   │   └── views/           # Un ModelViewSet por entidad
│   ├── esports/             # Configuración Django (settings, urls, wsgi)
│   └── requirements.txt
├── database/
│   ├── schema.sql           # DDL completo (SQL Server)
│   └── seed.sql             # Datos de prueba (≥5 registros por entidad)
├── docs/
│   ├── diagrama_relacional.png
│   └── diagrama_clases.png
└── frontend/
    ├── index.html
    ├── css/styles.css
    └── js/app.js
```
