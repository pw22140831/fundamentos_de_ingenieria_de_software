-- #####################################################
-- ROLES
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_roles_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO roles_bitacora (
            id_rol,
            nombre,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_rol,
            NEW.nombre,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO roles_bitacora (
            id_rol,
            nombre,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_rol,
            NEW.nombre,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO roles_bitacora (
            id_rol,
            nombre,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_rol,
            OLD.nombre,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_roles_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON roles
FOR EACH ROW
EXECUTE FUNCTION fn_roles_bitacora();





-- #####################################################
-- USUARIOS
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_usuarios_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO usuarios_bitacora (
            id_usuario,
            nombre,
            apellido_paterno,
            apellido_materno,
            correo,
            password_hash,
            id_rol,
            fecha_creacion,
            activo,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_usuario,
            NEW.nombre,
            NEW.apellido_paterno,
            NEW.apellido_materno,
            NEW.correo,
            NEW.password_hash,
            NEW.id_rol,
            NEW.fecha_creacion,
            NEW.activo,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO usuarios_bitacora (
            id_usuario,
            nombre,
            apellido_paterno,
            apellido_materno,
            correo,
            password_hash,
            id_rol,
            fecha_creacion,
            activo,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_usuario,
            NEW.nombre,
            NEW.apellido_paterno,
            NEW.apellido_materno,
            NEW.correo,
            NEW.password_hash,
            NEW.id_rol,
            NEW.fecha_creacion,
            NEW.activo,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO usuarios_bitacora (
            id_usuario,
            nombre,
            apellido_paterno,
            apellido_materno,
            correo,
            password_hash,
            id_rol,
            fecha_creacion,
            activo,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_usuario,
            OLD.nombre,
            OLD.apellido_paterno,
            OLD.apellido_materno,
            OLD.correo,
            OLD.password_hash,
            OLD.id_rol,
            OLD.fecha_creacion,
            OLD.activo,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_usuarios_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON usuarios
FOR EACH ROW
EXECUTE FUNCTION fn_usuarios_bitacora();





-- #####################################################
-- PROYECTOS
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_proyectos_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO proyectos_bitacora (
            id_proyecto,
            nombre,
            responsable,
            fecha_inicio,
            fecha_fin,
            presupuesto,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_proyecto,
            NEW.nombre,
            NEW.responsable,
            NEW.fecha_inicio,
            NEW.fecha_fin,
            NEW.presupuesto,
            NEW.fecha_creacion,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO proyectos_bitacora (
            id_proyecto,
            nombre,
            responsable,
            fecha_inicio,
            fecha_fin,
            presupuesto,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_proyecto,
            NEW.nombre,
            NEW.responsable,
            NEW.fecha_inicio,
            NEW.fecha_fin,
            NEW.presupuesto,
            NEW.fecha_creacion,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO proyectos_bitacora (
            id_proyecto,
            nombre,
            responsable,
            fecha_inicio,
            fecha_fin,
            presupuesto,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_proyecto,
            OLD.nombre,
            OLD.responsable,
            OLD.fecha_inicio,
            OLD.fecha_fin,
            OLD.presupuesto,
            OLD.fecha_creacion,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_proyectos_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON proyectos
FOR EACH ROW
EXECUTE FUNCTION fn_proyectos_bitacora();

-- #####################################################
-- PROVEEDORES
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_proveedores_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO proveedores_bitacora (
            id_proveedor,
            nombre,
            contacto,
            telefono,
            correo,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_proveedor,
            NEW.nombre,
            NEW.contacto,
            NEW.telefono,
            NEW.correo,
            NEW.fecha_creacion,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO proveedores_bitacora (
            id_proveedor,
            nombre,
            contacto,
            telefono,
            correo,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_proveedor,
            NEW.nombre,
            NEW.contacto,
            NEW.telefono,
            NEW.correo,
            NEW.fecha_creacion,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO proveedores_bitacora (
            id_proveedor,
            nombre,
            contacto,
            telefono,
            correo,
            fecha_creacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_proveedor,
            OLD.nombre,
            OLD.contacto,
            OLD.telefono,
            OLD.correo,
            OLD.fecha_creacion,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_proveedores_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON proveedores
FOR EACH ROW
EXECUTE FUNCTION fn_proveedores_bitacora();






-- #####################################################
-- INVENTARIO
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_inventario_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO inventario_bitacora (
            id_inventario,
            id_proyecto,
            nombre_recurso,
            cantidad,
            estado,
            fecha_actualizacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_inventario,
            NEW.id_proyecto,
            NEW.nombre_recurso,
            NEW.cantidad,
            NEW.estado,
            NEW.fecha_actualizacion,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO inventario_bitacora (
            id_inventario,
            id_proyecto,
            nombre_recurso,
            cantidad,
            estado,
            fecha_actualizacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_inventario,
            NEW.id_proyecto,
            NEW.nombre_recurso,
            NEW.cantidad,
            NEW.estado,
            NEW.fecha_actualizacion,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO inventario_bitacora (
            id_inventario,
            id_proyecto,
            nombre_recurso,
            cantidad,
            estado,
            fecha_actualizacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_inventario,
            OLD.id_proyecto,
            OLD.nombre_recurso,
            OLD.cantidad,
            OLD.estado,
            OLD.fecha_actualizacion,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_inventario_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON inventario
FOR EACH ROW
EXECUTE FUNCTION fn_inventario_bitacora();






-- #####################################################
-- TRANSACCIONES
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_transacciones_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO transacciones_bitacora (
            id_transaccion,
            id_proyecto,
            id_usuario,
            id_proveedor,
            tipo,
            monto,
            fecha,
            descripcion,
            fecha_registro,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_transaccion,
            NEW.id_proyecto,
            NEW.id_usuario,
            NEW.id_proveedor,
            NEW.tipo,
            NEW.monto,
            NEW.fecha,
            NEW.descripcion,
            NEW.fecha_registro,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO transacciones_bitacora (
            id_transaccion,
            id_proyecto,
            id_usuario,
            id_proveedor,
            tipo,
            monto,
            fecha,
            descripcion,
            fecha_registro,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_transaccion,
            NEW.id_proyecto,
            NEW.id_usuario,
            NEW.id_proveedor,
            NEW.tipo,
            NEW.monto,
            NEW.fecha,
            NEW.descripcion,
            NEW.fecha_registro,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO transacciones_bitacora (
            id_transaccion,
            id_proyecto,
            id_usuario,
            id_proveedor,
            tipo,
            monto,
            fecha,
            descripcion,
            fecha_registro,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_transaccion,
            OLD.id_proyecto,
            OLD.id_usuario,
            OLD.id_proveedor,
            OLD.tipo,
            OLD.monto,
            OLD.fecha,
            OLD.descripcion,
            OLD.fecha_registro,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_transacciones_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON transacciones
FOR EACH ROW
EXECUTE FUNCTION fn_transacciones_bitacora();

-- #####################################################
-- USUARIOS_PROYECTOS
-- #####################################################

-- =========================
-- FUNCION
-- =========================
CREATE OR REPLACE FUNCTION fn_usuarios_proyectos_bitacora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN

        INSERT INTO usuarios_proyectos_bitacora (
            id_usuario_proyecto,
            id_usuario,
            id_proyecto,
            fecha_asignacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_usuario_proyecto,
            NEW.id_usuario,
            NEW.id_proyecto,
            NEW.fecha_asignacion,
            NEW.is_active,
            'A',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- UPDATE
    IF TG_OP = 'UPDATE' THEN

        INSERT INTO usuarios_proyectos_bitacora (
            id_usuario_proyecto,
            id_usuario,
            id_proyecto,
            fecha_asignacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            NEW.id_usuario_proyecto,
            NEW.id_usuario,
            NEW.id_proyecto,
            NEW.fecha_asignacion,
            NEW.is_active,
            'C',
            current_setting('audit.user_id', true)::INT
        );

        RETURN NEW;
    END IF;


    -- DELETE
    IF TG_OP = 'DELETE' THEN

        INSERT INTO usuarios_proyectos_bitacora (
            id_usuario_proyecto,
            id_usuario,
            id_proyecto,
            fecha_asignacion,
            is_active,
            accion_bitacora,
            usuario_bitacora
        )
        VALUES (
            OLD.id_usuario_proyecto,
            OLD.id_usuario,
            OLD.id_proyecto,
            OLD.fecha_asignacion,
            OLD.is_active,
            'B',
            current_setting('audit.user_id', true)::INT
        );

        RETURN OLD;
    END IF;

END;
$$;



-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_usuarios_proyectos_bitacora
AFTER INSERT OR UPDATE OR DELETE
ON usuarios_proyectos
FOR EACH ROW
EXECUTE FUNCTION fn_usuarios_proyectos_bitacora();