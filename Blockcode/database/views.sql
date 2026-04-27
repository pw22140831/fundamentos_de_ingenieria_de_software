CREATE OR REPLACE VIEW vw_roles AS
SELECT
    id_rol,
    nombre
FROM roles;

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
    ON u.id_rol = r.id_rol;

    CREATE OR REPLACE VIEW vw_proyectos AS
SELECT
    id_proyecto,
    nombre,
    responsable,
    fecha_inicio,
    fecha_fin,
    presupuesto,
    fecha_creacion
FROM proyectos;