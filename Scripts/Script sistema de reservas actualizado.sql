-- =====================================================
-- PROYECTO FINAL: Sistema Reservas Viajes Terrestres (CUC)
-- CURSO: TI-142 Fundamentos de Bases de Datos
-- ALUMNO: Rodrigo, Nestor
-- =====================================================

USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SistemaGestionViajes_Final')
    DROP DATABASE SistemaGestionViajes_Final;
GO
CREATE DATABASE SistemaGestionViajes_Final;
GO
USE SistemaGestionViajes_Final;
GO

-- =====================================================
-- 1. CREACIÓN DE TABLAS (ORDEN DE DEPENDENCIAS)
-- =====================================================

-- CATÁLOGOS GEOGRÁFICOS
CREATE TABLE ZONA (
    PK_ID_ZONA INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_ZONA VARCHAR(30) NOT NULL
);

CREATE TABLE CIUDAD (
    PK_ID_CIUDAD INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_CIUDAD VARCHAR(60) NOT NULL,
    FK_ZONA INT NOT NULL,
    CONSTRAINT FK_CIUDAD_ZONA FOREIGN KEY (FK_ZONA) REFERENCES ZONA(PK_ID_ZONA)
);

CREATE TABLE DIRECCION (
    PK_ID_DIRECCION INT PRIMARY KEY IDENTITY(1,1),
    PROVINCIA VARCHAR(20) NOT NULL,
    CANTON VARCHAR(50) NOT NULL,
    DISTRITO VARCHAR(20) NOT NULL,
    DESCRIPCION VARCHAR(150)
);

-- PERSONAS Y PERFILES
CREATE TABLE PROFESION (
    PK_ID_PROFESION INT PRIMARY KEY IDENTITY(1,1),
    DETALLE VARCHAR(50) NOT NULL
);

CREATE TABLE RANGO_SALARIAL (
    PK_ID_RANGO INT PRIMARY KEY IDENTITY(1,1),
    DESCRIPCION VARCHAR(50) NOT NULL,
    SALARIO_MIN DECIMAL(10,2),
    SALARIO_MAX DECIMAL(10,2)
);

CREATE TABLE EMPRESA_CLIENTE (
    PK_ID_EMPRESA INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE VARCHAR(80) NOT NULL,
    TELEFONO VARCHAR(16),
    CORREO VARCHAR(100),
    FK_DIRECCION INT,
    CONSTRAINT FK_EMPRESA_DIRECCION FOREIGN KEY (FK_DIRECCION) REFERENCES DIRECCION(PK_ID_DIRECCION)
);

CREATE TABLE CLIENTE (
    PK_ID_CLIENTE INT PRIMARY KEY IDENTITY(1,1),
    CEDULA VARCHAR(20) UNIQUE NOT NULL,
    NOMBRE_COMPLETO VARCHAR(100) NOT NULL,
    TELEFONO VARCHAR(16),
    CORREO VARCHAR(100),
    FK_PROFESION INT NOT NULL,
    FK_EMPRESA INT,
    FK_RANGO INT NOT NULL,
    FECHA_REGISTRO DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CLIENTE_PROFESION FOREIGN KEY (FK_PROFESION) REFERENCES PROFESION(PK_ID_PROFESION),
    CONSTRAINT FK_CLIENTE_EMPRESA FOREIGN KEY (FK_EMPRESA) REFERENCES EMPRESA_CLIENTE(PK_ID_EMPRESA),
    CONSTRAINT FK_CLIENTE_RANGO FOREIGN KEY (FK_RANGO) REFERENCES RANGO_SALARIAL(PK_ID_RANGO)
);

CREATE TABLE ROL_EMPLEADO (
    PK_ID_ROL INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_ROL VARCHAR(30) NOT NULL
);

CREATE TABLE EMPLEADO (
    PK_ID_EMPLEADO INT PRIMARY KEY IDENTITY(1,1),
    CEDULA VARCHAR(20) UNIQUE NOT NULL,
    NOMBRE_COMPLETO VARCHAR(100) NOT NULL,
    FK_ROL INT NOT NULL,
    ACTIVO BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_EMPLEADO_ROL FOREIGN KEY (FK_ROL) REFERENCES ROL_EMPLEADO(PK_ID_ROL)
);

-- VEHÍCULOS Y MANTENIMIENTO
CREATE TABLE TIPO_AUTOBUS (
    PK_ID_TIPO INT PRIMARY KEY IDENTITY(1,1),
    DESCRIPCION VARCHAR(40) NOT NULL
);

CREATE TABLE AUTOBUS (
    PK_ID_AUTOBUS INT PRIMARY KEY IDENTITY(1,1),
    PLACA VARCHAR(10) UNIQUE NOT NULL,
    CAPACIDAD_ASIENTOS INT NOT NULL,
    FK_TIPO_AUTOBUS INT NOT NULL,
    ESTADO_UNIDAD VARCHAR(30) DEFAULT 'DISPONIBLE',
    ACTIVO BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_AUTOBUS_TIPO FOREIGN KEY (FK_TIPO_AUTOBUS) REFERENCES TIPO_AUTOBUS(PK_ID_TIPO)
);

CREATE TABLE TIPO_MANTENIMIENTO (
    PK_ID_TIPO_MANT INT PRIMARY KEY IDENTITY(1,1),
    DESCRIPCION VARCHAR(50) NOT NULL
);

CREATE TABLE MANTENIMIENTO_AUTOBUS (
    PK_ID_MANTENIMIENTO INT PRIMARY KEY IDENTITY(1,1),
    FK_AUTOBUS INT NOT NULL,
    FK_TIPO_MANTENIMIENTO INT NOT NULL,
    FECHA_INICIO DATETIME NOT NULL DEFAULT GETDATE(),
    FECHA_FIN DATETIME NULL,
    COSTO DECIMAL(10,2),
    CONSTRAINT FK_MANT_BUS FOREIGN KEY (FK_AUTOBUS) REFERENCES AUTOBUS(PK_ID_AUTOBUS),
    CONSTRAINT FK_MANT_TIPO FOREIGN KEY (FK_TIPO_MANTENIMIENTO) REFERENCES TIPO_MANTENIMIENTO(PK_ID_TIPO_MANT)
);

-- RUTAS Y VIAJES
CREATE TABLE RUTA (
    PK_ID_RUTA INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_RUTA VARCHAR(80) NOT NULL,
    FK_CIUDAD_ORIGEN INT NOT NULL,
    FK_CIUDAD_DESTINO INT NOT NULL,
    DURACION_ESTIMADA_MIN INT,
    CONSTRAINT FK_RUTA_ORIGEN FOREIGN KEY (FK_CIUDAD_ORIGEN) REFERENCES CIUDAD(PK_ID_CIUDAD),
    CONSTRAINT FK_RUTA_DESTINO FOREIGN KEY (FK_CIUDAD_DESTINO) REFERENCES CIUDAD(PK_ID_CIUDAD)
);

CREATE TABLE VIAJE_PROGRAMADO (
    PK_ID_VIAJE INT PRIMARY KEY IDENTITY(1,1),
    FK_RUTA INT NOT NULL,
    FK_AUTOBUS INT NOT NULL,
    FK_CHOFER INT NOT NULL,
    FK_FISCAL INT NOT NULL,
    FECHA_SALIDA DATETIME NOT NULL,
    TARIFA_BASE DECIMAL(10,2) NOT NULL,
    ESTADO_VIAJE VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADO',
    CONSTRAINT FK_VIAJE_RUTA FOREIGN KEY (FK_RUTA) REFERENCES RUTA(PK_ID_RUTA),
    CONSTRAINT FK_VIAJE_BUS FOREIGN KEY (FK_AUTOBUS) REFERENCES AUTOBUS(PK_ID_AUTOBUS),
    CONSTRAINT FK_VIAJE_CHOFER FOREIGN KEY (FK_CHOFER) REFERENCES EMPLEADO(PK_ID_EMPLEADO),
    CONSTRAINT FK_VIAJE_FISCAL FOREIGN KEY (FK_FISCAL) REFERENCES EMPLEADO(PK_ID_EMPLEADO)
);

-- RESERVAS Y FACTURACIÓN
CREATE TABLE RESERVACION (
    PK_ID_RESERVACION INT PRIMARY KEY IDENTITY(1,1),
    FK_CLIENTE INT NOT NULL,
    FK_VIAJE INT NOT NULL,
    FK_ADMINISTRATIVO INT NOT NULL,
    FECHA_RESERVA DATETIME DEFAULT GETDATE(),
    CANTIDAD_ASIENTOS INT NOT NULL,
    ESTADO_RESERVA VARCHAR(20) DEFAULT 'PENDIENTE',
    CONSTRAINT FK_RESERVA_CLIENTE FOREIGN KEY (FK_CLIENTE) REFERENCES CLIENTE(PK_ID_CLIENTE),
    CONSTRAINT FK_RESERVA_VIAJE FOREIGN KEY (FK_VIAJE) REFERENCES VIAJE_PROGRAMADO(PK_ID_VIAJE),
    CONSTRAINT FK_RESERVA_ADMIN FOREIGN KEY (FK_ADMINISTRATIVO) REFERENCES EMPLEADO(PK_ID_EMPLEADO)
);

CREATE TABLE METODO_PAGO (
    PK_ID_METODO INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_METODO VARCHAR(40) NOT NULL
);

CREATE TABLE FACTURA (
    PK_ID_FACTURA INT PRIMARY KEY IDENTITY(1,1),
    NUMERO_FACTURA VARCHAR(20) UNIQUE NOT NULL,
    FK_RESERVACION INT NOT NULL,
    FK_METODO_PAGO INT NOT NULL,
    FECHA_FACTURA DATETIME DEFAULT GETDATE(),
    SUBTOTAL DECIMAL(10,2) NOT NULL,
    IMPUESTOS DECIMAL(10,2) NOT NULL,
    DESCUENTOS DECIMAL(10,2) DEFAULT 0,
    MONTO_TOTAL DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_FACTURA_RESERVA FOREIGN KEY (FK_RESERVACION) REFERENCES RESERVACION(PK_ID_RESERVACION),
    CONSTRAINT FK_FACTURA_METODO FOREIGN KEY (FK_METODO_PAGO) REFERENCES METODO_PAGO(PK_ID_METODO)
);

-- SEGURIDAD
CREATE TABLE USUARIO_SISTEMA (
    PK_ID_USUARIO INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_USUARIO VARCHAR(40) UNIQUE NOT NULL,
    CLAVE_HASH VARCHAR(200) NOT NULL,
    FK_EMPLEADO INT NOT NULL,
    CONSTRAINT FK_USUARIO_EMP FOREIGN KEY (FK_EMPLEADO) REFERENCES EMPLEADO(PK_ID_EMPLEADO)
);
GO

-- =====================================================
-- 2. TRIGGERS (REQUERIMIENTO PÁG. 1)
-- =====================================================

-- Cambia estado a EN_MANTENIMIENTO al insertar registro
CREATE TRIGGER tr_ActualizarEstadoBusMantenimiento
ON MANTENIMIENTO_AUTOBUS
AFTER INSERT
AS
BEGIN
    UPDATE AUTOBUS
    SET ESTADO_UNIDAD = 'EN_MANTENIMIENTO'
    FROM AUTOBUS
    INNER JOIN inserted ON AUTOBUS.PK_ID_AUTOBUS = inserted.FK_AUTOBUS;
END;
GO

-- Cambia estado a DISPONIBLE cuando se llena FECHA_FIN
CREATE TRIGGER tr_FinalizarMantenimientoBus
ON MANTENIMIENTO_AUTOBUS
AFTER UPDATE
AS
BEGIN
    IF UPDATE(FECHA_FIN)
    BEGIN
        UPDATE AUTOBUS
        SET ESTADO_UNIDAD = 'DISPONIBLE'
        FROM AUTOBUS
        INNER JOIN inserted ON AUTOBUS.PK_ID_AUTOBUS = inserted.FK_AUTOBUS
        WHERE inserted.FECHA_FIN IS NOT NULL;
    END
END;
GO

-- =====================================================
-- 3. FUNCIONES (REQUERIMIENTO PÁG. 3)
-- =====================================================

CREATE FUNCTION fn_asientos_disponibles (@id_viaje INT)
RETURNS INT
AS
BEGIN
    DECLARE @capacidad INT, @reservados INT;
    SELECT @capacidad = A.CAPACIDAD_ASIENTOS 
    FROM AUTOBUS A INNER JOIN VIAJE_PROGRAMADO V ON A.PK_ID_AUTOBUS = V.FK_AUTOBUS
    WHERE V.PK_ID_VIAJE = @id_viaje;

    SELECT @reservados = ISNULL(SUM(CANTIDAD_ASIENTOS), 0) 
    FROM RESERVACION WHERE FK_VIAJE = @id_viaje AND ESTADO_RESERVA != 'CANCELADA';

    RETURN @capacidad - @reservados;
END;
GO

CREATE FUNCTION fn_tipo_cliente (@id_rango INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @tipo VARCHAR(20);
    SELECT @tipo = DESCRIPCION FROM RANGO_SALARIAL WHERE PK_ID_RANGO = @id_rango;
    RETURN ISNULL(@tipo, 'Económico');
END;
GO

-- =====================================================
-- 4. PROCEDIMIENTOS (REQUERIMIENTO PÁG. 2)
-- =====================================================

CREATE PROCEDURE sp_asignar_unidad_ruta
    @id_viaje INT,
    @id_bus INT,
    @id_chofer INT
AS
BEGIN
    -- Validar disponibilidad del Bus
    IF NOT EXISTS (SELECT 1 FROM AUTOBUS WHERE PK_ID_AUTOBUS = @id_bus AND ESTADO_UNIDAD = 'DISPONIBLE')
    BEGIN
        RAISERROR('El autobús no está disponible.', 16, 1);
        RETURN;
    END
    -- Validar que el chofer no tenga viaje a la misma hora
    DECLARE @fecha DATETIME;
    SELECT @fecha = FECHA_SALIDA FROM VIAJE_PROGRAMADO WHERE PK_ID_VIAJE = @id_viaje;
    
    IF EXISTS (SELECT 1 FROM VIAJE_PROGRAMADO WHERE FK_CHOFER = @id_chofer AND FECHA_SALIDA = @fecha AND PK_ID_VIAJE <> @id_viaje)
    BEGIN
        RAISERROR('El conductor ya tiene un viaje asignado a esa hora.', 16, 1);
        RETURN;
    END

    UPDATE VIAJE_PROGRAMADO SET FK_AUTOBUS = @id_bus, FK_CHOFER = @id_chofer WHERE PK_ID_VIAJE = @id_viaje;
END;
GO

-- =====================================================
-- 5. DATOS DE PRUEBA (20+ REGISTROS)
-- =====================================================

INSERT INTO ZONA VALUES ('Valle Central'), ('Pacífico'), ('Caribe'), ('Zona Norte');
INSERT INTO CIUDAD VALUES ('San José', 1), ('Alajuela', 1), ('Cartago', 1), ('Puntarenas', 2), ('Limón', 3), ('Liberia', 2), ('Ciudad Quesada', 4);
INSERT INTO DIRECCION VALUES ('Cartago', 'Central', 'Occidental', 'Cerca del CUC'), ('San José', 'Central', 'Carmen', 'San Pedro');
INSERT INTO PROFESION VALUES ('Software Dev'), ('Médico'), ('Contador'), ('Docente');
INSERT INTO RANGO_SALARIAL VALUES ('Económico', 0, 500000), ('Regular', 500001, 1500000), ('VIP', 1500001, 9999999);
INSERT INTO EMPRESA_CLIENTE VALUES ('Empresa A', '2222-1111', 'a@mail.com', 1);
INSERT INTO CLIENTE (CEDULA, NOMBRE_COMPLETO, TELEFONO, CORREO, FK_PROFESION, FK_EMPRESA, FK_RANGO, FECHA_REGISTRO) 
VALUES ('1-1111', 'Rodrigo Alvarado', '8888-1111', 'rodri@mail.com', 1, 1, 3, GETDATE());
INSERT INTO ROL_EMPLEADO VALUES ('Administrativo'), ('Chofer'), ('Fiscal');
INSERT INTO EMPLEADO (CEDULA, NOMBRE_COMPLETO, FK_ROL, ACTIVO) VALUES ('1-0999', 'Juan Retana', 2, 1), ('1-0888', 'Ana Méndez', 1, 1), ('1-0777', 'Luis Fiscal', 3, 1);
INSERT INTO TIPO_AUTOBUS VALUES ('Premium'), ('Regular');
INSERT INTO AUTOBUS (PLACA, CAPACIDAD_ASIENTOS, FK_TIPO_AUTOBUS) VALUES ('SJB-001', 50, 1), ('SJB-002', 45, 2);
INSERT INTO RUTA VALUES ('SJ-Cartago', 1, 3, 45), ('SJ-Limón', 1, 5, 180);
INSERT INTO VIAJE_PROGRAMADO VALUES (1, 1, 1, 3, '2026-05-10 08:00:00', 1000, 'PROGRAMADO');
INSERT INTO METODO_PAGO VALUES ('Efectivo'), ('SINPE'), ('Tarjeta');
INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, CANTIDAD_ASIENTOS) VALUES (1, 1, 2, 2);
INSERT INTO TIPO_MANTENIMIENTO VALUES ('Preventivo'), ('Correctivo');

-- Verificar Triggers/Funciones
EXEC sp_asignar_unidad_ruta 1, 1, 1;
SELECT dbo.fn_asientos_disponibles(1) as AsientosLibres;
SELECT dbo.fn_tipo_cliente(3) as Categoria;
GO


-- datos de pruebas -- 

-- Completar ZONA (Ya hay 4, faltan 11)
INSERT INTO ZONA (NOMBRE_ZONA) VALUES 
('Pacífico Central'), ('Chorotega'), ('Huetar Norte'), ('Huetar Caribe'), 
('Brunca'), ('Sur-Sur'), ('Península'), ('Frontera Norte'), 
('Los Santos'), ('Occidente'), ('Sarapiquí');

-- Completar CIUDAD (Ya hay 7, faltan 8)
INSERT INTO CIUDAD (NOMBRE_CIUDAD, FK_ZONA) VALUES 
('Esparza', 2), ('Nicoya', 6), ('Guápiles', 3), ('Pérez Zeledón', 9), 
('Quepos', 5), ('Jacó', 5), ('San Ramón', 14), ('Grecia', 14);

-- Completar DIRECCION (Ya hay 2, faltan 13)
INSERT INTO DIRECCION (PROVINCIA, CANTON, DISTRITO, DESCRIPCION) VALUES 
('Alajuela', 'Central', 'Agonía', 'Costado Norte Plaza'), ('Heredia', 'Central', 'Mercedes', 'Calle 4'),
('Guanacaste', 'Liberia', 'Mayorga', 'Barrio Lajas'), ('Limón', 'Pococí', 'Guápiles', 'Frente a la terminal'),
('Puntarenas', 'Garabito', 'Jacó', 'Av. Pastor Diaz'), ('San José', 'Escazú', 'San Rafael', 'Centro Comercial'),
('Cartago', 'Paraíso', 'Llanos', 'Frente a Escuela'), ('Heredia', 'Belén', 'San Antonio', 'Cerca de Intel'),
('Alajuela', 'San Carlos', 'Quesada', 'Barrio El Carmen'), ('Puntarenas', 'Quepos', 'Savegre', 'Finca 2'),
('San José', 'Desamparados', 'San Miguel', 'Calle principal'), ('Guanacaste', 'Nicoya', 'Mansión', '50m Este Iglesia'),
('Cartago', 'La Unión', 'Tres Ríos', 'Terramall');

-- Completar PROFESION (Ya hay 4, faltan 11)
INSERT INTO PROFESION (DETALLE) VALUES 
('Ingeniero Civil'), ('Arquitecto'), ('Enfermero'), ('Abogado'), ('Psicólogo'), 
('Chef'), ('Mecánico'), ('Estudiante'), ('Vendedor'), ('Policía'), ('Periodista');

-- Completar EMPRESA_CLIENTE (Ya hay 1, faltan 14)
INSERT INTO EMPRESA_CLIENTE (NOMBRE, TELEFONO, CORREO, FK_DIRECCION) VALUES 
('Tech Solutions', '2255-0000', 'info@tech.com', 2), ('ConsulTico', '2288-1111', 'hr@consultico.com', 3),
('AgroNorte', '2460-2222', 'ventas@agronorte.com', 4), ('Constructora X', '2551-3333', 'proyectos@cx.com', 5),
('Hotel Playa', '2661-4444', 'reservas@hplaya.com', 6), ('Tienda Mia', '2233-5555', 'admin@mia.com', 7),
('Taller ABC', '2552-6666', 'jefe@abc.com', 8), ('Clinica Salud', '2244-7777', 'citas@salud.com', 9),
('Banco Local', '2211-8888', 'soporte@banco.com', 10), ('Super Mercado', '2440-9999', 'contabilidad@super.com', 11),
('Escuela ABC', '2222-1010', 'dir@escuela.com', 12), ('Pura Vida S.A', '2230-1112', 'info@puravida.com', 13),
('Logística CR', '2430-1213', 'ops@logistica.com', 14), ('Exportaciones Sol', '2771-1415', 'ceo@sol.com', 15);

-- Completar CLIENTE (Ya hay 1, faltan 14)
INSERT INTO CLIENTE (CEDULA, NOMBRE_COMPLETO, TELEFONO, CORREO, FK_PROFESION, FK_EMPRESA, FK_RANGO, FECHA_REGISTRO) VALUES 
('2-2222', 'Maria Lopez', '8888-2222', 'mlopez@mail.com', 2, 2, 2, '2026-01-10'),
('3-3333', 'Carlos Soto', '8888-3333', 'csoto@mail.com', 3, 3, 1, '2026-01-15'),
('4-4444', 'Lucia Mendez', '8888-4444', 'lmendez@mail.com', 4, 4, 3, '2026-02-01'),
('5-5555', 'Jorge Cano', '8888-5555', 'jcano@mail.com', 5, 5, 2, '2026-02-10'),
('6-6666', 'Elena Rivas', '8888-6666', 'erivas@mail.com', 6, 6, 1, '2026-03-05'),
('7-7777', 'Pedro Picado', '8888-7777', 'ppicado@mail.com', 7, 7, 2, '2026-03-12'),
('8-8888', 'Sofia Rojas', '8888-8888', 'srojas@mail.com', 8, 8, 1, '2026-04-01'),
('9-9999', 'Andres Gil', '8888-9999', 'agil@mail.com', 9, 9, 3, '2026-04-10'),
('1-1234', 'Laura Vega', '8800-1122', 'lvega@mail.com', 10, 10, 2, '2026-04-15'),
('2-3456', 'Roberto Paz', '8800-3344', 'rpaz@mail.com', 11, 11, 1, '2026-04-20'),
('3-5678', 'Diana Solano', '8800-5566', 'dsolano@mail.com', 1, 12, 3, '2026-04-21'),
('4-7890', 'Marco Ruiz', '8800-7788', 'mruiz@mail.com', 2, 13, 2, '2026-04-22'),
('5-9012', 'Valeria Mora', '8800-9900', 'vmora@mail.com', 3, 14, 1, '2026-04-23'),
('6-1234', 'Esteban Jara', '8811-2233', 'ejara@mail.com', 4, 15, 2, '2026-04-23');

-- Completar EMPLEADO (Ya hay 3, faltan 12)
INSERT INTO EMPLEADO (CEDULA, NOMBRE_COMPLETO, FK_ROL, ACTIVO) VALUES 
('1-0666', 'Mario Bros', 2, 1), ('1-0555', 'Luigi Bros', 2, 1), ('1-0444', 'Peach Toad', 1, 1),
('1-0333', 'Yoshi Dino', 3, 1), ('1-0222', 'Wario Gold', 2, 1), ('1-0111', 'Daisy Flower', 1, 1),
('2-0999', 'Kevin Alpizar', 2, 1), ('2-0888', 'Felipe Castro', 2, 1), ('2-0777', 'Jimena Mata', 1, 1),
('3-0999', 'Oscar Duarte', 3, 1), ('3-0888', 'Nancy Ortiz', 2, 1), ('3-0777', 'Gabriel Umaña', 1, 1);

-- Completar AUTOBUS (Ya hay 2, faltan 13)
INSERT INTO AUTOBUS (PLACA, CAPACIDAD_ASIENTOS, FK_TIPO_AUTOBUS) VALUES 
('SJB-003', 50, 1), ('SJB-004', 40, 2), ('SJB-005', 45, 1), ('SJB-006', 50, 2),
('SJB-007', 30, 1), ('SJB-008', 45, 2), ('SJB-009', 50, 1), ('SJB-010', 40, 2),
('SJB-011', 45, 1), ('SJB-012', 50, 2), ('SJB-013', 30, 1), ('SJB-014', 45, 2), ('SJB-015', 50, 1);

-- Completar RUTA (Ya hay 2, faltan 13)
INSERT INTO RUTA (NOMBRE_RUTA, FK_CIUDAD_ORIGEN, FK_CIUDAD_DESTINO, DURACION_ESTIMADA_MIN) VALUES 
('SJ-Alajuela', 1, 2, 40), ('SJ-Puntarenas', 1, 4, 120), ('SJ-Liberia', 1, 6, 240),
('SJ-San Carlos', 1, 7, 180), ('Cartago-Limón', 3, 5, 150), ('Liberia-Puntarenas', 6, 4, 110),
('SJ-Quepos', 1, 12, 160), ('Alajuela-San Carlos', 2, 7, 130), ('SJ-Pérez Zeledón', 1, 11, 190),
('SJ-Guápiles', 1, 10, 100), ('Heredia-SJ', 9, 1, 35), ('SJ-Jacó', 1, 13, 90), ('SJ-Nicoya', 1, 9, 260);

-- Completar VIAJE_PROGRAMADO (Ya hay 1, faltan 14)
INSERT INTO VIAJE_PROGRAMADO (FK_RUTA, FK_AUTOBUS, FK_CHOFER, FK_FISCAL, FECHA_SALIDA, TARIFA_BASE, ESTADO_VIAJE) VALUES 
(2, 2, 4, 3, '2026-05-10 09:00:00', 4500, 'PROGRAMADO'),
(3, 3, 5, 7, '2026-05-10 10:00:00', 1200, 'PROGRAMADO'),
(4, 4, 8, 3, '2026-05-11 06:00:00', 3500, 'PROGRAMADO'),
(5, 5, 9, 7, '2026-05-11 07:00:00', 6000, 'PROGRAMADO'),
(6, 6, 10, 13, '2026-05-12 08:30:00', 5500, 'PROGRAMADO'),
(7, 7, 14, 13, '2026-05-12 14:00:00', 4000, 'PROGRAMADO'),
(8, 8, 4, 3, '2026-05-13 05:00:00', 4500, 'PROGRAMADO'),
(9, 9, 5, 7, '2026-05-13 09:15:00', 3000, 'PROGRAMADO'),
(10, 10, 8, 13, '2026-05-14 11:00:00', 2500, 'PROGRAMADO'),
(11, 11, 9, 3, '2026-05-14 13:00:00', 5000, 'PROGRAMADO'),
(1, 12, 10, 7, '2026-05-15 08:00:00', 1000, 'PROGRAMADO'),
(2, 13, 14, 13, '2026-05-15 16:00:00', 4500, 'PROGRAMADO'),
(3, 14, 4, 3, '2026-05-16 04:00:00', 6500, 'PROGRAMADO'),
(4, 15, 5, 7, '2026-05-16 10:00:00', 3800, 'PROGRAMADO');

-- Completar RESERVACION (Ya hay 1, faltan 14)
INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, CANTIDAD_ASIENTOS) VALUES 
(2, 2, 9, 1), (3, 3, 12, 3), (4, 4, 15, 2), (5, 5, 9, 1), (6, 6, 12, 4), (7, 7, 15, 2),
(8, 8, 9, 1), (9, 9, 12, 2), (10, 10, 15, 1), (11, 11, 9, 2), (12, 12, 12, 1), (13, 13, 15, 5),
(14, 14, 9, 2), (15, 2, 12, 1);

-- Completar FACTURA (Faltan 15 - Se calculan montos ficticios para prueba)
INSERT INTO FACTURA (NUMERO_FACTURA, FK_RESERVACION, FK_METODO_PAGO, SUBTOTAL, IMPUESTOS, MONTO_TOTAL) VALUES 
('FAC-001', 1, 3, 2000, 260, 2260), ('FAC-002', 2, 2, 4500, 585, 5085),
('FAC-003', 3, 1, 3600, 468, 4068), ('FAC-004', 4, 3, 7000, 910, 7910),
('FAC-005', 5, 2, 6000, 780, 6780), ('FAC-006', 6, 1, 22000, 2860, 24860),
('FAC-007', 7, 3, 8000, 1040, 9040), ('FAC-008', 8, 2, 4500, 585, 5085),
('FAC-009', 9, 1, 6000, 780, 6780), ('FAC-010', 10, 3, 2500, 325, 2825),
('FAC-011', 11, 2, 10000, 1300, 11300), ('FAC-012', 12, 1, 1000, 130, 1130),
('FAC-013', 13, 3, 22500, 2925, 25425), ('FAC-014', 14, 2, 13000, 1690, 14690),
('FAC-015', 15, 1, 4500, 585, 5085);

-- Completar TIPO_MANTENIMIENTO (Ya hay 2, faltan 13)
INSERT INTO TIPO_MANTENIMIENTO (DESCRIPCION) VALUES 
('Cambio de Aceite'), ('Frenos'), ('Llantas'), ('Motor'), ('Caja Cambios'), 
('Aire Acondicionado'), ('Eléctrico'), ('Tapicería'), ('Pintura'), 
('Limpieza Profunda'), ('Suspensión'), ('Luces'), ('Scanner General');


-- ///////////////////////////////////////////////////////////////////// --

-- Primero ocupamos un empleado para amarrar el usuario
INSERT INTO EMPLEADO (CEDULA, NOMBRE_COMPLETO, FK_ROL, ACTIVO) 
VALUES ('V-PASS', 'Administrador Sistema', 1, 1);

-- Ahora el usuario (Usa estos datos para loguearte)
INSERT INTO USUARIO_SISTEMA (NOMBRE_USUARIO, CLAVE_HASH, FK_EMPLEADO) 
VALUES ('admin', '1234', (SELECT TOP 1 PK_ID_EMPLEADO FROM EMPLEADO WHERE CEDULA = 'V-PASS'));

-- Tabla 20: Bitácora (Requisito pág. 2)
CREATE TABLE BITACORA_SISTEMA (
    PK_ID_BITACORA INT PRIMARY KEY IDENTITY(1,1),
    FK_USUARIO INT NOT NULL,
    FECHA_ACCESO DATETIME DEFAULT GETDATE(),
    ACCION VARCHAR(100),
    CONSTRAINT FK_BITACORA_USUARIO FOREIGN KEY (FK_USUARIO) REFERENCES USUARIO_SISTEMA(PK_ID_USUARIO)
);

use SistemaGestionViajes_Final
ALTER TABLE VIAJE_PROGRAMADO
ADD CONSTRAINT CHK_EstadoViaje 
CHECK (ESTADO_VIAJE IN ('PROGRAMADO', 'EN_VIAJE', 'COMPLETADO', 'CANCELADO'));

-- Cambiamos un par de viajes a EN_VIAJE para ver el color azul en la web
UPDATE VIAJE_PROGRAMADO SET ESTADO_VIAJE = 'EN_VIAJE' WHERE PK_ID_VIAJE IN (1, 2);


-- nuevas tablas 

-- Tabla de Bitácora según requerimiento
CREATE TABLE AUDITORIA_RESERVAS (
    PK_ID_AUDITORIA INT PRIMARY KEY IDENTITY(1,1),
    TABLA_AFECTADA VARCHAR(50),
    ACCION VARCHAR(20),
    USUARIO VARCHAR(50) DEFAULT SYSTEM_USER,
    FECHA DATETIME DEFAULT GETDATE()
);
GO

-- Trigger de Auditoría para Reservaciones
CREATE TRIGGER tr_AuditoriaReservas
ON RESERVACION
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @accion VARCHAR(20) = 'INSERT';
    IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted) SET @accion = 'UPDATE';
    IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted) SET @accion = 'DELETE';

    INSERT INTO AUDITORIA_RESERVAS (TABLA_AFECTADA, ACCION)
    VALUES ('RESERVACION', @accion);
END;
GO



CREATE OR ALTER FUNCTION fn_tipo_cliente (@salario DECIMAL(10,2))
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE 
        WHEN @salario > 1500000 THEN 'VIP'
        WHEN @salario BETWEEN 500001 AND 1500000 THEN 'Regular'
        ELSE 'Económico'
    END;
END;
GO

CREATE OR ALTER PROCEDURE sp_crear_reservacion
    @id_cliente INT,
    @id_viaje INT,
    @id_admin INT,
    @cantidad INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Validar disponibilidad usando la función fn_asientos_disponibles
        DECLARE @disponibles INT = dbo.fn_asientos_disponibles(@id_viaje);

        IF @disponibles < @cantidad
        BEGIN
            RAISERROR('No hay suficientes asientos disponibles.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Insertar la reservación
        INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, CANTIDAD_ASIENTOS, ESTADO_RESERVA)
        VALUES (@id_cliente, @id_viaje, @id_admin, @cantidad, 'PENDIENTE');

        COMMIT TRANSACTION;
        PRINT 'Reservación creada con éxito.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_generar_factura
    @id_reservacion INT,
    @id_metodo_pago INT
AS
BEGIN
    BEGIN TRY
        DECLARE @tarifa DECIMAL(10,2), @asientos INT, @subtotal DECIMAL(10,2), @impuestos DECIMAL(10,2), @total DECIMAL(10,2);
        DECLARE @num_factura VARCHAR(20) = 'FAC-' + CAST(NEXT VALUE FOR seq_NumeroFactura AS VARCHAR); -- Ocupas una secuencia o un random

        -- Obtener datos del viaje y la reserva
        SELECT @tarifa = V.TARIFA_BASE, @asientos = R.CANTIDAD_ASIENTOS
        FROM RESERVACION R
        INNER JOIN VIAJE_PROGRAMADO V ON R.FK_VIAJE = V.PK_ID_VIAJE
        WHERE R.PK_ID_RESERVACION = @id_reservacion;

        -- Cálculos
        SET @subtotal = @tarifa * @asientos;
        SET @impuestos = @subtotal * 0.13; -- IVA 13%
        SET @total = @subtotal + @impuestos;

        -- Insertar Factura
        INSERT INTO FACTURA (NUMERO_FACTURA, FK_RESERVACION, FK_METODO_PAGO, SUBTOTAL, IMPUESTOS, MONTO_TOTAL)
        VALUES (ISNULL(@num_factura, NEWID()), @id_reservacion, @id_metodo_pago, @subtotal, @impuestos, @total);

        -- Actualizar estado de la reserva a PAGADA
        UPDATE RESERVACION SET ESTADO_RESERVA = 'PAGADA' WHERE PK_ID_RESERVACION = @id_reservacion;

        PRINT 'Factura generada exitosamente.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO
