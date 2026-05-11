-- =====================================================
-- LIMPIEZA PREVIA
-- =====================================================

-- =========================
-- VISTAS
-- =========================
DROP VIEW IF EXISTS vw_roles CASCADE;
DROP VIEW IF EXISTS vw_usuarios CASCADE;
DROP VIEW IF EXISTS vw_proyectos CASCADE;


-- =========================
-- PROCEDIMIENTOS
-- =========================

-- ROLES
DROP PROCEDURE IF EXISTS sp_insertar_rol;
DROP PROCEDURE IF EXISTS sp_actualizar_rol;
DROP PROCEDURE IF EXISTS sp_eliminar_rol;

-- USUARIOS
DROP PROCEDURE IF EXISTS sp_insertar_usuario;
DROP PROCEDURE IF EXISTS sp_actualizar_usuario;
DROP PROCEDURE IF EXISTS sp_eliminar_usuario;

-- PROYECTOS
DROP PROCEDURE IF EXISTS sp_insertar_proyecto;
DROP PROCEDURE IF EXISTS sp_actualizar_proyecto;
DROP PROCEDURE IF EXISTS sp_eliminar_proyecto;


-- =========================
-- TABLAS
-- =========================

DROP TABLE IF EXISTS transacciones CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS usuarios_proyectos CASCADE;
DROP TABLE IF EXISTS proveedores CASCADE;
DROP TABLE IF EXISTS proyectos CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS roles CASCADE;