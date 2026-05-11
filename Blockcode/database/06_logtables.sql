-- =====================================================
-- TABLAS DE BITACORA / AUDITORIA
-- PostgreSQL
-- =====================================================
-- Convención:
-- {tabla}_bitacora
--
-- Campos agregados:
-- id_{tabla}_bitacora
-- accion_bitacora
-- usuario_bitacora
-- fecha_bitacora
--
-- accion_bitacora:
-- A = Alta
-- B = Baja
-- C = Cambio
-- =====================================================



-- #####################################################
-- ROLES_BITACORA
-- #####################################################

CREATE TABLE roles_bitacora (
    id_rol_bitacora SERIAL PRIMARY KEY,

    id_rol INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_roles_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- USUARIOS_BITACORA
-- #####################################################

CREATE TABLE usuarios_bitacora (
    id_usuario_bitacora SERIAL PRIMARY KEY,

    id_usuario INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    password_hash TEXT NOT NULL,
    id_rol INT NOT NULL,
    fecha_creacion TIMESTAMP,
    activo BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_usuarios_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- PROYECTOS_BITACORA
-- #####################################################

CREATE TABLE proyectos_bitacora (
    id_proyecto_bitacora SERIAL PRIMARY KEY,

    id_proyecto INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    responsable VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    presupuesto NUMERIC(14,2),
    fecha_creacion TIMESTAMP,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_proyectos_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- USUARIOS_PROYECTOS_BITACORA
-- #####################################################

CREATE TABLE usuarios_proyectos_bitacora (
    id_usuario_proyecto_bitacora SERIAL PRIMARY KEY,

    id_usuario_proyecto INT NOT NULL,
    id_usuario INT NOT NULL,
    id_proyecto INT NOT NULL,
    fecha_asignacion TIMESTAMP,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_usuarios_proyectos_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- PROVEEDORES_BITACORA
-- #####################################################

CREATE TABLE proveedores_bitacora (
    id_proveedor_bitacora SERIAL PRIMARY KEY,

    id_proveedor INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    contacto VARCHAR(150),
    telefono VARCHAR(30),
    correo VARCHAR(150),
    fecha_creacion TIMESTAMP,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_proveedores_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- INVENTARIO_BITACORA
-- #####################################################

CREATE TABLE inventario_bitacora (
    id_inventario_bitacora SERIAL PRIMARY KEY,

    id_inventario INT NOT NULL,
    id_proyecto INT NOT NULL,
    nombre_recurso VARCHAR(150) NOT NULL,
    cantidad INT NOT NULL,
    estado VARCHAR(50) NOT NULL,
    fecha_actualizacion TIMESTAMP,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_inventario_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);




-- #####################################################
-- TRANSACCIONES_BITACORA
-- #####################################################

CREATE TABLE transacciones_bitacora (
    id_transaccion_bitacora SERIAL PRIMARY KEY,

    id_transaccion INT NOT NULL,
    id_proyecto INT NOT NULL,
    id_usuario INT NOT NULL,
    id_proveedor INT,

    tipo VARCHAR(50) NOT NULL,
    monto NUMERIC(14,2) NOT NULL,
    fecha DATE NOT NULL,
    descripcion TEXT,
    fecha_registro TIMESTAMP,
    is_active BOOLEAN,

    accion_bitacora CHAR(1) NOT NULL,
    usuario_bitacora INT,
    fecha_bitacora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transacciones_accion_bitacora
        CHECK (accion_bitacora IN ('A', 'B', 'C'))
);