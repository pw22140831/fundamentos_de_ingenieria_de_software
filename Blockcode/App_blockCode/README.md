# BlockCode - Technology Stack

## Descripción General

BlockCode es una plataforma desarrollada bajo una arquitectura web moderna, utilizando tecnologías separadas por capas para garantizar:

* escalabilidad
* mantenibilidad
* seguridad
* portabilidad
* facilidad de despliegue

El sistema está compuesto por:

* Frontend Web
* Backend API
* Aplicación móvil
* Base de datos relacional
* Infraestructura cloud

---

# Arquitectura General

```text id="d8x4ik"
Frontend React
        ↓
Backend PHP API
        ↓
PostgreSQL Database
        ↓
Auditoría y Procedures
```

Aplicación móvil:

```text id="0c13jq"
Flutter Mobile App
        ↓
Backend PHP API
        ↓
PostgreSQL Database
```

Infraestructura:

```text id="3brpdu"
AWS Cloud Infrastructure
```

---

# Frontend Web

## Tecnología

* React
* JavaScript
* Axios
* React Router

## Objetivo

El frontend web proporciona la interfaz principal para:

* administración
* gestión de usuarios
* proyectos
* inventario
* transacciones

## Características

* SPA (Single Page Application)
* consumo de APIs REST
* manejo de JWT
* control de roles
* componentes reutilizables

## Librerías principales

| Librería     | Uso             |
| ------------ | --------------- |
| React        | UI              |
| React Router | Navegación      |
| Axios        | Peticiones HTTP |

---

# Backend API

## Tecnología

* PHP
* PDO
* JWT Authentication

## Objetivo

El backend actúa como capa intermedia entre:

* frontend
* aplicación móvil
* base de datos

## Responsabilidades

* autenticación
* autorización
* validación
* ejecución de procedures
* manejo de auditoría
* control de permisos

## Características

* arquitectura REST
* autenticación JWT
* middleware de seguridad
* conexión PostgreSQL mediante PDO

## Seguridad

* passwords con hash bcrypt
* JWT firmado
* validación de tokens
* control de roles

---

# Aplicación Móvil

## Tecnología

* Flutter
* Dart

## Objetivo

Proveer acceso móvil multiplataforma para:

* Android
* iOS

## Características

* interfaz multiplataforma
* consumo de APIs REST
* autenticación JWT
* sincronización con backend

## Beneficios de Flutter

* un solo código para múltiples plataformas
* alto rendimiento
* UI moderna
* mantenimiento simplificado

---

# Base de Datos

## Tecnología

* PostgreSQL

## Objetivo

Gestionar toda la información operativa y administrativa del sistema.

## Características implementadas

* modelo relacional
* procedimientos almacenados
* funciones
* vistas
* triggers
* auditoría automática
* soft delete

## Módulos principales

* usuarios
* roles
* proyectos
* inventario
* proveedores
* transacciones
* bitácora

## Seguridad

* roles SQL
* permisos específicos
* integridad referencial
* constraints
* checks

---

# Auditoría

## Implementación

La auditoría se realiza mediante:

* triggers
* tablas bitácora
* variables de sesión PostgreSQL

## Información registrada

* altas
* cambios
* bajas
* usuario responsable
* fecha y hora

## Objetivo

Garantizar:

* trazabilidad
* integridad histórica
* monitoreo
* control administrativo

---

# Infraestructura Cloud

## Plataforma

* AWS (Amazon Web Services)

## Objetivo

Hospedar todos los componentes del sistema.

## Servicios utilizados

| Servicio AWS   | Uso                  |
| -------------- | -------------------- |
| EC2            | Backend y frontend   |
| Route 53       | DNS Dinámico         |
| IAM            | Control de acceso    |

---

# Seguridad General

## Implementaciones actuales

* JWT Authentication
* Hash bcrypt
* Middleware de autorización
* Soft delete
* Auditoría automática
* Roles y permisos

---

# Flujo de autenticación

```text id="cjlwmu"
Usuario inicia sesión
        ↓
Backend valida credenciales
        ↓
Generación de JWT
        ↓
Frontend guarda token
        ↓
Token enviado en cada request
        ↓
Middleware valida JWT
        ↓
Backend ejecuta operaciones
```

---

# Ventajas del Stack

## Escalabilidad

Cada capa puede crecer independientemente.

---

## Mantenibilidad

Separación clara entre:

* frontend
* backend
* base de datos

---

## Seguridad

Integración de:

* JWT
* auditoría
* control de roles
* hashing seguro

---

# Tecnologías Utilizadas

| Capa           | Tecnología |
| -------------- | ---------- |
| Frontend Web   | React      |
| Backend API    | PHP        |
| Mobile         | Flutter    |
| Database       | PostgreSQL |
| Cloud          | AWS        |
| Authentication | JWT        |
| HTTP Client    | Axios      |
| ORM/DB Access  | PDO        |

---

# Estado Actual del Proyecto

## Implementado

* autenticación JWT
* CRUDs
* vistas
* procedures
* funciones
* auditoría
* control de roles
* frontend React
* backend PHP

---

# Objetivo del Proyecto

BlockCode busca proporcionar una plataforma robusta para la administración de:

* proyectos
* inventario
* usuarios
* transacciones

manteniendo:

* seguridad
* trazabilidad
* escalabilidad
* mantenibilidad
