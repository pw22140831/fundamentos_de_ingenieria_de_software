# BlockCode - Database Scripts

## Descripción

Esta carpeta contiene todos los scripts necesarios para construir, inicializar y configurar la base de datos PostgreSQL del sistema **BlockCode**.

La estructura está organizada por etapas para facilitar:

* despliegues
* reinicialización de ambientes
* mantenimiento
* migraciones
* auditoría
* configuración de seguridad

---

# Orden de ejecución

Los scripts deben ejecutarse en el siguiente orden:

```text
00_reset.sql
01_schema.sql
02_seed.sql
03_views.sql
04_procedures.sql
05_functions.sql
06_logtables.sql
07_triggers.sql
08_permissions.sql
```

---

# Explicación de cada archivo

---

## 00_reset.sql

### Propósito

Elimina todos los objetos principales de la base de datos para permitir una reinstalación limpia.

### Contenido esperado

* DROP TABLE
* DROP VIEW
* DROP FUNCTION
* DROP PROCEDURE
* DROP TRIGGER
* DROP TYPE
* DROP ROLE (opcional)

### Uso

Ideal para:

* desarrollo
* pruebas
* reinicialización completa
* despliegues controlados

### Importante

Debe ejecutarse únicamente en ambientes controlados.

---

## 01_schema.sql

### Propósito

Crea la estructura principal de la base de datos.

### Contenido

Tablas principales:

* roles
* usuarios
* proyectos
* usuarios_proyectos
* proveedores
* inventario
* transacciones

### Incluye

* Primary Keys
* Foreign Keys
* Constraints
* Checks
* Relaciones
* Soft Delete (`is_active` / `activo`)

### Objetivo

Definir el modelo relacional principal del sistema.

---

## 02_seed.sql

### Propósito

Inserta datos iniciales de prueba.

### Contenido

* roles
* usuarios
* proyectos
* proveedores
* inventario
* transacciones
* relaciones usuario/proyecto

### Notas

Las contraseñas usan hashes simulados o bcrypt.

### Uso

* testing
* desarrollo
* demos
* validación funcional

---

## 03_views.sql

### Propósito

Define las vistas utilizadas por el backend.

### Objetivo

Evitar consultas directas a tablas desde la aplicación.

### Beneficios

* encapsulamiento
* seguridad
* mantenibilidad
* desacoplamiento

### Ejemplos

* vw_usuarios
* vw_proyectos
* vw_transacciones
* vw_inventario

---

## 04_procedures.sql

### Propósito

Contiene todos los procedimientos almacenados CRUD.

### Incluye

Por cada entidad:

* insertar
* actualizar
* eliminar (soft delete)

### Características

* encapsulan lógica de negocio
* evitan SQL directo desde backend
* facilitan auditoría
* centralizan reglas

### Soft Delete

Las eliminaciones utilizan:

```sql
UPDATE is_active = FALSE
```

o:

```sql
UPDATE activo = FALSE
```

---

## 05_functions.sql

### Propósito

Contiene funciones auxiliares y funciones de consulta especializada.

### Ejemplos

* login de usuarios
* validaciones
* búsquedas parametrizadas

### Diferencia con procedures

Las funciones:

* retornan resultados
* pueden usarse en SELECT

Los procedures:

* ejecutan acciones
* manejan operaciones CRUD

---

## 06_logtables.sql

### Propósito

Crea las tablas de auditoría (bitácora).

### Estructura

Cada tabla principal tiene una copia:

```text
usuarios_bitacora
proyectos_bitacora
transacciones_bitacora
...
```

### Incluyen

* copia completa de columnas originales
* id independiente de bitácora
* accion_bitacora
* usuario_bitacora
* fecha_bitacora

### Acciones registradas

| Código | Acción |
| ------ | ------ |
| A      | Alta   |
| B      | Baja   |
| C      | Cambio |

### Objetivo

Mantener historial completo de modificaciones.

---

## 07_triggers.sql

### Propósito

Automatizar la inserción de registros en bitácora.

### Funcionamiento

Cada:

* INSERT
* UPDATE
* DELETE lógico

genera automáticamente un registro histórico.

### Fuente del usuario auditor

Los triggers leen:

```sql
current_setting('audit.user_id', true)
```

Este valor es configurado desde el backend usando JWT autenticado.

### Beneficios

* auditoría centralizada
* trazabilidad
* historial completo
* integridad operativa

---

## 08_permissions.sql

### Propósito

Configura permisos y roles de PostgreSQL.

### Contenido actual

Creación del rol:

```sql
blockcode_admin
```

### Privilegios

* conexión
* uso de schema
* ejecución de funciones
* CRUD sobre tablas
* uso de secuencias

### Objetivo

Separar permisos administrativos del usuario root/postgres.

### Importante

En producción:

* usar contraseñas seguras
* restringir IPs
* evitar privilegios excesivos
* usar SSL/TLS

---

# Flujo general del sistema

```text
Frontend
    ↓
Backend API
    ↓
JWT Authentication
    ↓
Stored Procedures / Functions
    ↓
Triggers
    ↓
Bitácora automática
```

---

# Características principales del diseño

## Seguridad

* JWT
* Roles
* Soft Delete
* Procedures
* Auditoría

---

## Arquitectura

* PostgreSQL relacional
* Backend desacoplado
* Vistas
* Procedures
* Triggers

---

## Auditoría

Registro automático de:

* altas
* cambios
* bajas

incluyendo:

* usuario responsable
* fecha
* datos históricos

---

# Tecnologías

* PostgreSQL
* PHP
* JWT
* React
* Axios

---

# Autor

Proyecto académico/profesional BlockCode.
