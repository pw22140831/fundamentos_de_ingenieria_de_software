-- #####################################################
-- TABLA: ROLES
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_rol(
    p_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO roles (nombre)
    VALUES (p_nombre);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_rol(
    p_id_rol INT,
    p_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE roles
    SET nombre = p_nombre
    WHERE id_rol = p_id_rol;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_rol(
    p_id_rol INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE roles
    SET is_active = FALSE
    WHERE id_rol = p_id_rol;
END;
$$;

-- #####################################################
-- TABLA: USUARIOS
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_usuario(
    p_nombre VARCHAR,
    p_apellido_paterno VARCHAR,
    p_apellido_materno VARCHAR,
    p_correo VARCHAR,
    p_password_hash TEXT,
    p_id_rol INT,
    p_activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuarios (
        nombre,
        apellido_paterno,
        apellido_materno,
        correo,
        password_hash,
        id_rol,
        activo
    )
    VALUES (
        p_nombre,
        p_apellido_paterno,
        p_apellido_materno,
        p_correo,
        p_password_hash,
        p_id_rol,
        p_activo
    );
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario(
    p_id_usuario INT,
    p_nombre VARCHAR,
    p_apellido_paterno VARCHAR,
    p_apellido_materno VARCHAR,
    p_correo VARCHAR,
    p_password_hash TEXT,
    p_id_rol INT,
    p_activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE usuarios
    SET
        nombre = p_nombre,
        apellido_paterno = p_apellido_paterno,
        apellido_materno = p_apellido_materno,
        correo = p_correo,
        password_hash = p_password_hash,
        id_rol = p_id_rol,
        activo = p_activo
    WHERE id_usuario = p_id_usuario;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_usuario(
    p_id_usuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE usuarios
    SET activo = FALSE
    WHERE id_usuario = p_id_usuario;
END;
$$;

-- #####################################################
-- TABLA: PROYECTOS
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_proyecto(
    p_nombre VARCHAR,
    p_responsable VARCHAR,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_presupuesto NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proyectos (
        nombre,
        responsable,
        fecha_inicio,
        fecha_fin,
        presupuesto
    )
    VALUES (
        p_nombre,
        p_responsable,
        p_fecha_inicio,
        p_fecha_fin,
        p_presupuesto
    );
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_proyecto(
    p_id_proyecto INT,
    p_nombre VARCHAR,
    p_responsable VARCHAR,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_presupuesto NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyectos
    SET
        nombre = p_nombre,
        responsable = p_responsable,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        presupuesto = p_presupuesto
    WHERE id_proyecto = p_id_proyecto;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_proyecto(
    p_id_proyecto INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyectos
    SET is_active = FALSE
    WHERE id_proyecto = p_id_proyecto;
END;
$$;

-- #####################################################
-- TABLA: PROVEEDORES
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_proveedor(
    p_nombre VARCHAR,
    p_contacto VARCHAR,
    p_telefono VARCHAR,
    p_correo VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proveedores (
        nombre,
        contacto,
        telefono,
        correo
    )
    VALUES (
        p_nombre,
        p_contacto,
        p_telefono,
        p_correo
    );
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_proveedor(
    p_id_proveedor INT,
    p_nombre VARCHAR,
    p_contacto VARCHAR,
    p_telefono VARCHAR,
    p_correo VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proveedores
    SET
        nombre = p_nombre,
        contacto = p_contacto,
        telefono = p_telefono,
        correo = p_correo
    WHERE id_proveedor = p_id_proveedor
    AND is_active = TRUE;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_proveedor(
    p_id_proveedor INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proveedores
    SET is_active = FALSE
    WHERE id_proveedor = p_id_proveedor;
END;
$$;

-- #####################################################
-- TABLA: INVENTARIO
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_inventario(
    p_id_proyecto INT,
    p_nombre_recurso VARCHAR,
    p_cantidad INT,
    p_estado VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO inventario (
        id_proyecto,
        nombre_recurso,
        cantidad,
        estado
    )
    VALUES (
        p_id_proyecto,
        p_nombre_recurso,
        p_cantidad,
        p_estado
    );
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_inventario(
    p_id_inventario INT,
    p_id_proyecto INT,
    p_nombre_recurso VARCHAR,
    p_cantidad INT,
    p_estado VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE inventario
    SET
        id_proyecto = p_id_proyecto,
        nombre_recurso = p_nombre_recurso,
        cantidad = p_cantidad,
        estado = p_estado,
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_inventario = p_id_inventario
    AND is_active = TRUE;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_inventario(
    p_id_inventario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE inventario
    SET is_active = FALSE
    WHERE id_inventario = p_id_inventario;
END;
$$;

-- #####################################################
-- TABLA: TRANSACCIONES
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
    p_id_proyecto INT,
    p_id_usuario INT,
    p_id_proveedor INT,
    p_tipo VARCHAR,
    p_monto NUMERIC,
    p_fecha DATE,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO transacciones (
        id_proyecto,
        id_usuario,
        id_proveedor,
        tipo,
        monto,
        fecha,
        descripcion
    )
    VALUES (
        p_id_proyecto,
        p_id_usuario,
        p_id_proveedor,
        p_tipo,
        p_monto,
        p_fecha,
        p_descripcion
    );
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_transaccion(
    p_id_transaccion INT,
    p_id_proyecto INT,
    p_id_usuario INT,
    p_id_proveedor INT,
    p_tipo VARCHAR,
    p_monto NUMERIC,
    p_fecha DATE,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE transacciones
    SET
        id_proyecto = p_id_proyecto,
        id_usuario = p_id_usuario,
        id_proveedor = p_id_proveedor,
        tipo = p_tipo,
        monto = p_monto,
        fecha = p_fecha,
        descripcion = p_descripcion
    WHERE id_transaccion = p_id_transaccion
    AND is_active = TRUE;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_transaccion(
    p_id_transaccion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE transacciones
    SET is_active = FALSE
    WHERE id_transaccion = p_id_transaccion;
END;
$$;

-- #####################################################
-- TABLA: RELACION USUARIOS - PROYECTOS
-- #####################################################
CREATE OR REPLACE PROCEDURE sp_insertar_usuario_proyecto(
    p_id_usuario INT,
    p_id_proyecto INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    -- Evitar asignaciones duplicadas activas
    IF EXISTS (
        SELECT 1
        FROM usuarios_proyectos
        WHERE id_usuario = p_id_usuario
        AND id_proyecto = p_id_proyecto
        AND is_active = TRUE
    ) THEN
        RAISE EXCEPTION
        'El usuario ya está asignado a este proyecto';
    END IF;

    INSERT INTO usuarios_proyectos (
        id_usuario,
        id_proyecto
    )
    VALUES (
        p_id_usuario,
        p_id_proyecto
    );

END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario_proyecto(
    p_id_usuario_proyecto INT,
    p_id_usuario INT,
    p_id_proyecto INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    -- Evitar duplicados al actualizar
    IF EXISTS (
        SELECT 1
        FROM usuarios_proyectos
        WHERE id_usuario = p_id_usuario
        AND id_proyecto = p_id_proyecto
        AND id_usuario_proyecto <> p_id_usuario_proyecto
        AND is_active = TRUE
    ) THEN
        RAISE EXCEPTION
        'Ya existe otra asignación activa con esos datos';
    END IF;

    UPDATE usuarios_proyectos
    SET
        id_usuario = p_id_usuario,
        id_proyecto = p_id_proyecto
    WHERE id_usuario_proyecto = p_id_usuario_proyecto
    AND is_active = TRUE;

END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_usuario_proyecto(
    p_id_usuario_proyecto INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE usuarios_proyectos
    SET is_active = FALSE
    WHERE id_usuario_proyecto = p_id_usuario_proyecto;

END;
$$;