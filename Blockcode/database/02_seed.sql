INSERT INTO roles (nombre) VALUES
('Administrador'),
('Operador'),
('Trabajador');

INSERT INTO usuarios (
    nombre,
    apellido_paterno,
    apellido_materno,
    correo,
    password_hash,
    id_rol,
    activo
) VALUES
('Carlos', 'Mendoza', 'García', 'carlos@blockcode.com', '$2b$12$hashsimulado_admin1', 1, TRUE),
('Fernanda', 'López', 'Martínez', 'fernanda@blockcode.com', '$2b$12$hashsimulado_admin2', 1, TRUE),
('Luis', 'Ramírez', 'Sánchez', 'luis@blockcode.com', '$2b$12$hashsimulado_operador1', 2, TRUE),
('Andrea', 'Torres', 'Hernández', 'andrea@blockcode.com', '$2b$12$hashsimulado_operador2', 2, TRUE),
('Miguel', 'Sánchez', 'Pérez', 'miguel@blockcode.com', '$2b$12$hashsimulado_trabajador1', 3, TRUE),
('Daniela', 'Cruz', 'Rodríguez', 'daniela@blockcode.com', '$2b$12$hashsimulado_trabajador2', 3, TRUE),
('José', 'Herrera', 'González', 'jose@blockcode.com', '$2b$12$hashsimulado_trabajador3', 3, TRUE),
('Mariana', 'Vega', 'López', 'mariana@blockcode.com', '$2b$12$hashsimulado_operador3', 2, TRUE);

INSERT INTO proyectos (
    nombre,
    responsable,
    fecha_inicio,
    fecha_fin,
    presupuesto
) VALUES
('Construcción Torre Alpha', 'Carlos Mendoza', '2026-01-10', '2026-12-20', 850000.00),
('Remodelación Plaza Central', 'Fernanda López', '2026-02-15', '2026-09-30', 420000.00),
('Infraestructura Parque Norte', 'Luis Ramírez', '2026-03-01', '2026-11-15', 610000.00),
('Centro Logístico Industrial', 'Andrea Torres', '2026-01-25', '2027-03-10', 1250000.00),
('Edificio Corporativo Sigma', 'Miguel Sánchez', '2026-04-05', '2027-01-30', 970000.00);

INSERT INTO usuarios_proyectos (
    id_usuario,
    id_proyecto
) VALUES
(1,1),
(2,1),
(3,1),
(5,1),

(1,2),
(4,2),
(6,2),

(2,3),
(3,3),
(7,3),

(1,4),
(4,4),
(8,4),

(2,5),
(3,5),
(5,5),
(6,5);

INSERT INTO proveedores (
    nombre,
    contacto,
    telefono,
    correo
) VALUES
('Materiales del Bajío SA', 'Roberto Salinas', '4421234567', 'ventas@bajio.com'),
('Acero Industrial MX', 'Patricia Gómez', '4427654321', 'contacto@aceroindustrial.com'),
('Concretos Premium', 'Javier Morales', '4428881122', 'ventas@concretospremium.com'),
('Equipos Pesados Querétaro', 'Laura Jiménez', '4429987766', 'soporte@equipospesados.com'),
('Suministros El Constructor', 'Raúl Navarro', '4425544332', 'pedidos@constructor.com');

INSERT INTO inventario (
    id_proyecto,
    nombre_recurso,
    cantidad,
    estado
) VALUES
(1, 'Cemento Portland', 500, 'Disponible'),
(1, 'Varilla de acero', 300, 'Disponible'),
(2, 'Pintura blanca exterior', 120, 'Bajo stock'),
(2, 'Loseta cerámica', 200, 'Disponible'),
(3, 'Arena fina', 450, 'Disponible'),
(3, 'Grava triturada', 380, 'Disponible'),
(4, 'Montacargas', 4, 'En uso'),
(4, 'Excavadora hidráulica', 2, 'Mantenimiento'),
(5, 'Cableado estructural', 700, 'Disponible'),
(5, 'Paneles de vidrio', 85, 'Bajo stock');

INSERT INTO transacciones (
    id_proyecto,
    id_usuario,
    id_proveedor,
    tipo,
    monto,
    fecha,
    descripcion
) VALUES
(1, 3, 1, 'Compra', 25000.00, '2026-01-15', 'Compra inicial de cemento'),
(1, 3, 2, 'Compra', 18500.00, '2026-01-20', 'Adquisición de varilla'),
(2, 4, 3, 'Compra', 9800.00, '2026-02-18', 'Pedido de pintura exterior'),
(2, 4, 5, 'Compra', 14500.00, '2026-02-25', 'Compra de loseta'),
(3, 3, 3, 'Compra', 21000.00, '2026-03-10', 'Arena y grava'),
(3, 7, NULL, 'Salida', 5000.00, '2026-03-15', 'Gasto operativo interno'),
(4, 8, 4, 'Renta', 42000.00, '2026-03-28', 'Renta de maquinaria pesada'),
(4, 4, 4, 'Mantenimiento', 12500.00, '2026-04-03', 'Servicio a excavadora'),
(5, 3, 5, 'Compra', 31000.00, '2026-04-12', 'Cableado estructural'),
(5, 6, 2, 'Compra', 27500.00, '2026-04-20', 'Paneles y estructura metálica'),
(5, 5, NULL, 'Salida', 7600.00, '2026-04-25', 'Pago de transporte'),
(1, 5, NULL, 'Salida', 4300.00, '2026-01-30', 'Pago de logística');