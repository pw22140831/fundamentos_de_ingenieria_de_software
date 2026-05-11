CREATE OR REPLACE VIEW vw_roles AS
SELECT
    id_rol,
    nombre
FROM roles
WHERE is_active = TRUE;

CREATE OR REPLACE VIEW vw_usuarios AS
SELECT
    u.id_usuario,
    u.nombre,
    u.apellido_paterno,
    u.apellido_materno,
    u.correo,
    r.nombre AS rol,
    u.fecha_creacion,
    u.activo
FROM usuarios u
INNER JOIN roles r
    ON u.id_rol = r.id_rol
WHERE u.activo = TRUE;

    CREATE OR REPLACE VIEW vw_proyectos AS
SELECT
    id_proyecto,
    nombre,
    responsable,
    fecha_inicio,
    fecha_fin,
    presupuesto,
    fecha_creacion
FROM proyectos
WHERE is_active = TRUE;

CREATE OR REPLACE VIEW vw_proveedores AS
SELECT
    id_proveedor,
    nombre,
    contacto,
    telefono,
    correo,
    fecha_creacion
FROM proveedores
WHERE is_active = TRUE;

CREATE OR REPLACE VIEW vw_inventario AS
SELECT
    i.id_inventario,
    i.nombre_recurso,
    i.cantidad,
    i.estado,
    i.fecha_actualizacion,

    p.id_proyecto,
    p.nombre AS proyecto

FROM inventario i
INNER JOIN proyectos p
    ON i.id_proyecto = p.id_proyecto

WHERE i.is_active = TRUE
AND p.is_active = TRUE;

CREATE OR REPLACE VIEW vw_transacciones AS
SELECT
    t.id_transaccion,
    t.tipo,
    t.monto,
    t.fecha,
    t.descripcion,
    t.fecha_registro,

    p.id_proyecto,
    p.nombre AS proyecto,

    u.id_usuario,
    CONCAT(
        u.nombre,
        ' ',
        u.apellido_paterno,
        ' ',
        u.apellido_materno
    ) AS usuario,

    pr.id_proveedor,
    pr.nombre AS proveedor

FROM transacciones t

INNER JOIN proyectos p
    ON t.id_proyecto = p.id_proyecto

INNER JOIN usuarios u
    ON t.id_usuario = u.id_usuario

LEFT JOIN proveedores pr
    ON t.id_proveedor = pr.id_proveedor

WHERE t.is_active = TRUE
AND p.is_active = TRUE;

CREATE OR REPLACE VIEW vw_usuarios_proyectos AS
SELECT
    up.id_usuario_proyecto,
    up.fecha_asignacion,

    u.id_usuario,
    CONCAT(
        u.nombre,
        ' ',
        u.apellido_paterno,
        ' ',
        u.apellido_materno
    ) AS usuario,

    r.nombre AS rol,

    p.id_proyecto,
    p.nombre AS proyecto

FROM usuarios_proyectos up

INNER JOIN usuarios u
    ON up.id_usuario = u.id_usuario

INNER JOIN roles r
    ON u.id_rol = r.id_rol

INNER JOIN proyectos p
    ON up.id_proyecto = p.id_proyecto

WHERE up.is_active = TRUE
AND u.activo = TRUE
AND p.is_active = TRUE
AND r.is_active = TRUE;