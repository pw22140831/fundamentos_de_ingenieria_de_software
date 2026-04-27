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
    DELETE FROM roles
    WHERE id_rol = p_id_rol;
END;
$$;

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
    DELETE FROM proyectos
    WHERE id_proyecto = p_id_proyecto;
END;
$$;