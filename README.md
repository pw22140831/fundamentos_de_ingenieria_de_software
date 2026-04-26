# BLOCKCODE - Base de Datos PostgreSQL

## Estructura de archivos

### 1. `schema.sql`

Contiene la creación completa de tablas y relaciones principales del sistema:

* `roles`
* `usuarios`
* `proyectos`
* `usuarios_proyectos`
* `proveedores`
* `inventario`
* `transacciones`

También incluye:

* llaves foráneas
* `CHECK`
* `UNIQUE`
* valores por defecto
* control básico de integridad

---

### 2. `seed.sql`

Contiene datos de ejemplo para pruebas funcionales.

Incluye:

* mínimo 5 registros por tabla
* más registros en tablas relacionales
* simulación de `password_hash`
* escenarios realistas de operación

Esto permite probar relaciones, consultas y procedimientos desde el inicio.

---

### 3. `views.sql`

Contiene vistas para el primer bloque:

### Tablas incluidas

* `roles`
* `usuarios`
* `proyectos`

---

### 4. `procedures.sql`

Contiene procedimientos de insertar, eliminar y actualizar para el primer bloque:

### Tablas incluidas

* `roles`
* `usuarios`
* `proyectos`

En el caso de usuarios se utiliza **soft delete** mediante el campo `activo`.

---

## Orden recomendado de ejecución

Ejecutar en este orden:

### Paso 1

```sql
schema.sql
```

Primero se crean todas las tablas y relaciones.

---

### Paso 2

```sql
seed.sql
```

Después se insertan los datos iniciales.

---

### Paso 3

```sql
views.sql
```

Se agregan vistas.

---

### Paso 3

```sql
procedures.sql
```

Se agregan procedimientos almacenados.

---

## Pendiente por agregar

Aún faltan los siguientes bloques CRUD:

### Bloque 2

* `proveedores`
* `inventario`
* `transacciones`
* `usuarios_proyectos`

---