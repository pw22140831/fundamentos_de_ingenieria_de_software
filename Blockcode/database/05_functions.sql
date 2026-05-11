CREATE OR REPLACE FUNCTION fn_obtener_login_usuario(
    p_correo VARCHAR(150)
)
RETURNS TABLE (
    id_usuario INT,
    nombre VARCHAR,
    apellido_paterno VARCHAR,
    apellido_materno VARCHAR,
    correo VARCHAR,
    password_hash TEXT,
    id_rol INT,
    rol VARCHAR,
    activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY

    SELECT
        u.id_usuario,
        u.nombre,
        u.apellido_paterno,
        u.apellido_materno,
        u.correo,
        u.password_hash,

        r.id_rol,
        r.nombre AS rol,

        u.activo

    FROM usuarios u

    INNER JOIN roles r
        ON u.id_rol = r.id_rol

    WHERE u.correo = p_correo
    AND u.activo = TRUE
    AND r.is_active = TRUE

    LIMIT 1;

END;
$$;