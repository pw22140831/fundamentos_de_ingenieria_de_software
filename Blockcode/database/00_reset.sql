-- =====================================================
-- RESET COMPLETO DE BASE DE DATOS
-- PostgreSQL
-- =====================================================

-- =====================================================
-- TRIGGERS
-- =====================================================

DROP TRIGGER IF EXISTS trg_roles_bitacora ON roles;
DROP TRIGGER IF EXISTS trg_usuarios_bitacora ON usuarios;
DROP TRIGGER IF EXISTS trg_proyectos_bitacora ON proyectos;
DROP TRIGGER IF EXISTS trg_proveedores_bitacora ON proveedores;
DROP TRIGGER IF EXISTS trg_inventario_bitacora ON inventario;
DROP TRIGGER IF EXISTS trg_transacciones_bitacora ON transacciones;
DROP TRIGGER IF EXISTS trg_usuarios_proyectos_bitacora ON usuarios_proyectos;

-- =====================================================
-- FUNCIONES DE TRIGGERS
-- =====================================================

DROP FUNCTION IF EXISTS fn_roles_bitacora();
DROP FUNCTION IF EXISTS fn_usuarios_bitacora();
DROP FUNCTION IF EXISTS fn_proyectos_bitacora();
DROP FUNCTION IF EXISTS fn_proveedores_bitacora();
DROP FUNCTION IF EXISTS fn_inventario_bitacora();
DROP FUNCTION IF EXISTS fn_transacciones_bitacora();
DROP FUNCTION IF EXISTS fn_usuarios_proyectos_bitacora();

-- =====================================================
-- FUNCIONES GENERALES
-- =====================================================

DROP FUNCTION IF EXISTS fn_obtener_login_usuario(VARCHAR);

-- =====================================================
-- PROCEDIMIENTOS
-- =====================================================

-- ROLES
DROP PROCEDURE IF EXISTS sp_insertar_rol(VARCHAR);
DROP PROCEDURE IF EXISTS sp_actualizar_rol(INT, VARCHAR);
DROP PROCEDURE IF EXISTS sp_eliminar_rol(INT);

-- USUARIOS
DROP PROCEDURE IF EXISTS sp_insertar_usuario(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT,
    INT,
    BOOLEAN
);

DROP PROCEDURE IF EXISTS sp_actualizar_usuario(
    INT,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    TEXT,
    INT,
    BOOLEAN
);

DROP PROCEDURE IF EXISTS sp_eliminar_usuario(INT);

-- PROYECTOS
DROP PROCEDURE IF EXISTS sp_insertar_proyecto(
    VARCHAR,
    VARCHAR,
    DATE,
    DATE,
    NUMERIC
);

DROP PROCEDURE IF EXISTS sp_actualizar_proyecto(
    INT,
    VARCHAR,
    VARCHAR,
    DATE,
    DATE,
    NUMERIC
);

DROP PROCEDURE IF EXISTS sp_eliminar_proyecto(INT);

-- PROVEEDORES
DROP PROCEDURE IF EXISTS sp_insertar_proveedor(
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR
);

DROP PROCEDURE IF EXISTS sp_actualizar_proveedor(
    INT,
    VARCHAR,
    VARCHAR,
    VARCHAR,
    VARCHAR
);

DROP PROCEDURE IF EXISTS sp_eliminar_proveedor(INT);

-- INVENTARIO
DROP PROCEDURE IF EXISTS sp_insertar_inventario(
    INT,
    VARCHAR,
    INT,
    VARCHAR
);

DROP PROCEDURE IF EXISTS sp_actualizar_inventario(
    INT,
    INT,
    VARCHAR,
    INT,
    VARCHAR
);

DROP PROCEDURE IF EXISTS sp_eliminar_inventario(INT);

-- TRANSACCIONES
DROP PROCEDURE IF EXISTS sp_insertar_transaccion(
    INT,
    INT,
    INT,
    VARCHAR,
    NUMERIC,
    DATE,
    TEXT
);

DROP PROCEDURE IF EXISTS sp_actualizar_transaccion(
    INT,
    INT,
    INT,
    INT,
    VARCHAR,
    NUMERIC,
    DATE,
    TEXT
);

DROP PROCEDURE IF EXISTS sp_eliminar_transaccion(INT);

-- USUARIOS_PROYECTOS
DROP PROCEDURE IF EXISTS sp_insertar_usuario_proyecto(
    INT,
    INT
);

DROP PROCEDURE IF EXISTS sp_actualizar_usuario_proyecto(
    INT,
    INT,
    INT
);

DROP PROCEDURE IF EXISTS sp_eliminar_usuario_proyecto(INT);

-- =====================================================
-- VISTAS
-- =====================================================

DROP VIEW IF EXISTS vw_roles CASCADE;
DROP VIEW IF EXISTS vw_usuarios CASCADE;
DROP VIEW IF EXISTS vw_proyectos CASCADE;
DROP VIEW IF EXISTS vw_proveedores CASCADE;
DROP VIEW IF EXISTS vw_inventario CASCADE;
DROP VIEW IF EXISTS vw_transacciones CASCADE;
DROP VIEW IF EXISTS vw_usuarios_proyectos CASCADE;

-- =====================================================
-- TABLAS DE BITACORA
-- =====================================================

DROP TABLE IF EXISTS roles_bitacora CASCADE;
DROP TABLE IF EXISTS usuarios_bitacora CASCADE;
DROP TABLE IF EXISTS proyectos_bitacora CASCADE;
DROP TABLE IF EXISTS usuarios_proyectos_bitacora CASCADE;
DROP TABLE IF EXISTS proveedores_bitacora CASCADE;
DROP TABLE IF EXISTS inventario_bitacora CASCADE;
DROP TABLE IF EXISTS transacciones_bitacora CASCADE;

-- =====================================================
-- DROP INDEXES
-- PostgreSQL
-- =====================================================

-- =====================================================
-- USUARIOS
-- =====================================================

DROP INDEX IF EXISTS idx_usuarios_correo;

-- =====================================================
-- PROYECTOS
-- =====================================================

DROP INDEX IF EXISTS idx_proyectos_responsable;

-- =====================================================
-- USUARIOS_PROYECTOS
-- =====================================================

DROP INDEX IF EXISTS idx_usuarios_proyectos_id_usuario;
DROP INDEX IF EXISTS idx_usuarios_proyectos_id_proyecto;

-- =====================================================
-- PROVEEDORES
-- =====================================================

DROP INDEX IF EXISTS idx_proveedores_nombre;

-- =====================================================
-- INVENTARIO
-- =====================================================

DROP INDEX IF EXISTS idx_inventario_nombre_recurso;
DROP INDEX IF EXISTS idx_inventario_estado;

-- =====================================================
-- TRANSACCIONES
-- =====================================================

DROP INDEX IF EXISTS idx_transacciones_id_proyecto;
DROP INDEX IF EXISTS idx_transacciones_id_usuario;
DROP INDEX IF EXISTS idx_transacciones_tipo;
DROP INDEX IF EXISTS idx_transacciones_fecha;
DROP INDEX IF EXISTS idx_transacciones_proyecto_fecha;

-- =====================================================
-- TABLAS PRINCIPALES
-- =====================================================

DROP TABLE IF EXISTS usuarios_proyectos CASCADE;
DROP TABLE IF EXISTS transacciones CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS proveedores CASCADE;
DROP TABLE IF EXISTS proyectos CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS roles CASCADE;