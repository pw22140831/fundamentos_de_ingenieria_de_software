-- =====================================================
-- USUARIOS
-- =====================================================

-- Busquedas frecuentes por correo/login
CREATE INDEX idx_usuarios_correo
ON usuarios(correo);

-- =====================================================
-- PROYECTOS
-- =====================================================

-- Busquedas por responsable
CREATE INDEX idx_proyectos_responsable
ON proyectos(responsable);

-- =====================================================
-- USUARIOS_PROYECTOS
-- =====================================================

-- Relaciones FK
CREATE INDEX idx_usuarios_proyectos_id_usuario
ON usuarios_proyectos(id_usuario);

CREATE INDEX idx_usuarios_proyectos_id_proyecto
ON usuarios_proyectos(id_proyecto);

-- =====================================================
-- PROVEEDORES
-- =====================================================

-- Busquedas por nombre
CREATE INDEX idx_proveedores_nombre
ON proveedores(nombre);

-- =====================================================
-- INVENTARIO
-- =====================================================

-- Busquedas por recurso
CREATE INDEX idx_inventario_nombre_recurso
ON inventario(nombre_recurso);

-- Busquedas por estado
CREATE INDEX idx_inventario_estado
ON inventario(estado);

-- =====================================================
-- TRANSACCIONES
-- =====================================================

-- Relaciones FK
CREATE INDEX idx_transacciones_id_proyecto
ON transacciones(id_proyecto);

CREATE INDEX idx_transacciones_id_usuario
ON transacciones(id_usuario);

-- Busquedas por tipo
CREATE INDEX idx_transacciones_tipo
ON transacciones(tipo);

-- Busquedas por fecha
CREATE INDEX idx_transacciones_fecha
ON transacciones(fecha);


-- Consultas financieras por proyecto + fecha
CREATE INDEX idx_transacciones_proyecto_fecha
ON transacciones(id_proyecto, fecha);