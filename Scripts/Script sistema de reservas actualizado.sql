-- =====================================================
-- PROYECTO FINAL: Sistema Reservas Viajes Terrestres (CUC)
-- CURSO: TI-142 Fundamentos de Bases de Datos
-- ALUMNO: Rodrigo, Nestor
-- =====================================================

USE master;
GO

IF DB_ID('SistemaGestionViajes_Final') IS NOT NULL
BEGIN
    ALTER DATABASE SistemaGestionViajes_Final SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SistemaGestionViajes_Final;
END
GO

CREATE DATABASE SistemaGestionViajes_Final;
GO

USE SistemaGestionViajes_Final;
GO

-- =====================================================
-- 1. TABLAS BASE
-- =====================================================

CREATE TABLE ZONA (
    PK_ID_ZONA INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_ZONA VARCHAR(30) NOT NULL
);

CREATE TABLE CIUDAD (
    PK_ID_CIUDAD INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_CIUDAD VARCHAR(60) NOT NULL,
    FK_ZONA INT NOT NULL,
    CONSTRAINT FK_CIUDAD_ZONA FOREIGN KEY (FK_ZONA) REFERENCES ZONA(PK_ID_ZONA)
);

CREATE TABLE DIRECCION (
    PK_ID_DIRECCION INT IDENTITY(1,1) PRIMARY KEY,
    PROVINCIA VARCHAR(20) NOT NULL,
    CANTON VARCHAR(50) NOT NULL,
    DISTRITO VARCHAR(20) NOT NULL,
    DESCRIPCION VARCHAR(150)
);

CREATE TABLE PROFESION (
    PK_ID_PROFESION INT IDENTITY(1,1) PRIMARY KEY,
    DETALLE VARCHAR(50) NOT NULL
);

CREATE TABLE RANGO_SALARIAL (
    PK_ID_RANGO INT IDENTITY(1,1) PRIMARY KEY,
    DESCRIPCION VARCHAR(50) NOT NULL,
    SALARIO_MIN DECIMAL(10,2) NULL,
    SALARIO_MAX DECIMAL(10,2) NULL
);

CREATE TABLE EMPRESA_CLIENTE (
    PK_ID_EMPRESA INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE VARCHAR(80) NOT NULL,
    TELEFONO VARCHAR(16),
    CORREO VARCHAR(100),
    FK_DIRECCION INT NULL,
    CONSTRAINT FK_EMPRESA_DIRECCION FOREIGN KEY (FK_DIRECCION) REFERENCES DIRECCION(PK_ID_DIRECCION)
);

CREATE TABLE ROL_EMPLEADO (
    PK_ID_ROL INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_ROL VARCHAR(30) NOT NULL
);

CREATE TABLE EMPLEADO (
    PK_ID_EMPLEADO INT IDENTITY(1,1) PRIMARY KEY,
    CEDULA VARCHAR(20) UNIQUE NOT NULL,
    NOMBRE_COMPLETO VARCHAR(100) NOT NULL,
    FK_ROL INT NOT NULL,
    ACTIVO BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_EMPLEADO_ROL FOREIGN KEY (FK_ROL) REFERENCES ROL_EMPLEADO(PK_ID_ROL)
);

CREATE TABLE CLIENTE (
    PK_ID_CLIENTE INT IDENTITY(1,1) PRIMARY KEY,
    CEDULA VARCHAR(20) UNIQUE NOT NULL,
    NOMBRE_COMPLETO VARCHAR(100) NOT NULL,
    TELEFONO VARCHAR(16),
    CORREO VARCHAR(100),
    FK_PROFESION INT NOT NULL,
    FK_EMPRESA INT NULL,
    FK_RANGO INT NOT NULL,
    FECHA_REGISTRO DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CLIENTE_PROFESION FOREIGN KEY (FK_PROFESION) REFERENCES PROFESION(PK_ID_PROFESION),
    CONSTRAINT FK_CLIENTE_EMPRESA FOREIGN KEY (FK_EMPRESA) REFERENCES EMPRESA_CLIENTE(PK_ID_EMPRESA),
    CONSTRAINT FK_CLIENTE_RANGO FOREIGN KEY (FK_RANGO) REFERENCES RANGO_SALARIAL(PK_ID_RANGO)
);

CREATE TABLE TIPO_AUTOBUS (
    PK_ID_TIPO INT IDENTITY(1,1) PRIMARY KEY,
    DESCRIPCION VARCHAR(40) NOT NULL
);

CREATE TABLE AUTOBUS (
    PK_ID_AUTOBUS INT IDENTITY(1,1) PRIMARY KEY,
    PLACA VARCHAR(10) UNIQUE NOT NULL,
    CAPACIDAD_ASIENTOS INT NOT NULL,
    FK_TIPO_AUTOBUS INT NOT NULL,
    ESTADO_UNIDAD VARCHAR(30) NOT NULL DEFAULT 'DISPONIBLE',
    ACTIVO BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_AUTOBUS_TIPO FOREIGN KEY (FK_TIPO_AUTOBUS) REFERENCES TIPO_AUTOBUS(PK_ID_TIPO)
);

CREATE TABLE TIPO_MANTENIMIENTO (
    PK_ID_TIPO_MANT INT IDENTITY(1,1) PRIMARY KEY,
    DESCRIPCION VARCHAR(50) NOT NULL
);

CREATE TABLE MANTENIMIENTO_AUTOBUS (
    PK_ID_MANTENIMIENTO INT IDENTITY(1,1) PRIMARY KEY,
    FK_AUTOBUS INT NOT NULL,
    FK_TIPO_MANTENIMIENTO INT NOT NULL,
    FECHA_INICIO DATETIME NOT NULL DEFAULT GETDATE(),
    FECHA_FIN DATETIME NULL,
    COSTO DECIMAL(10,2) NULL,
    CONSTRAINT FK_MANT_BUS FOREIGN KEY (FK_AUTOBUS) REFERENCES AUTOBUS(PK_ID_AUTOBUS),
    CONSTRAINT FK_MANT_TIPO FOREIGN KEY (FK_TIPO_MANTENIMIENTO) REFERENCES TIPO_MANTENIMIENTO(PK_ID_TIPO_MANT)
);

CREATE TABLE RUTA (
    PK_ID_RUTA INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_RUTA VARCHAR(80) NOT NULL,
    FK_CIUDAD_ORIGEN INT NOT NULL,
    FK_CIUDAD_DESTINO INT NOT NULL,
    DURACION_ESTIMADA_MIN INT NULL,
    CONSTRAINT FK_RUTA_ORIGEN FOREIGN KEY (FK_CIUDAD_ORIGEN) REFERENCES CIUDAD(PK_ID_CIUDAD),
    CONSTRAINT FK_RUTA_DESTINO FOREIGN KEY (FK_CIUDAD_DESTINO) REFERENCES CIUDAD(PK_ID_CIUDAD)
);

CREATE TABLE VIAJE_PROGRAMADO (
    PK_ID_VIAJE INT IDENTITY(1,1) PRIMARY KEY,
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

CREATE TABLE METODO_PAGO (
    PK_ID_METODO INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_METODO VARCHAR(40) NOT NULL
);

CREATE TABLE RESERVACION (
    PK_ID_RESERVACION INT IDENTITY(1,1) PRIMARY KEY,
    FK_CLIENTE INT NOT NULL,
    FK_VIAJE INT NOT NULL,
    FK_ADMINISTRATIVO INT NOT NULL,
    FECHA_RESERVA DATETIME NOT NULL DEFAULT GETDATE(),
    CANTIDAD_ASIENTOS INT NOT NULL,
    ESTADO_RESERVA VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    CONSTRAINT FK_RESERVA_CLIENTE FOREIGN KEY (FK_CLIENTE) REFERENCES CLIENTE(PK_ID_CLIENTE),
    CONSTRAINT FK_RESERVA_VIAJE FOREIGN KEY (FK_VIAJE) REFERENCES VIAJE_PROGRAMADO(PK_ID_VIAJE),
    CONSTRAINT FK_RESERVA_ADMIN FOREIGN KEY (FK_ADMINISTRATIVO) REFERENCES EMPLEADO(PK_ID_EMPLEADO)
);

CREATE TABLE FACTURA (
    PK_ID_FACTURA INT IDENTITY(1,1) PRIMARY KEY,
    NUMERO_FACTURA VARCHAR(20) UNIQUE NOT NULL,
    FK_RESERVACION INT NOT NULL,
    FK_METODO_PAGO INT NOT NULL,
    FECHA_FACTURA DATETIME NOT NULL DEFAULT GETDATE(),
    SUBTOTAL DECIMAL(10,2) NOT NULL,
    IMPUESTOS DECIMAL(10,2) NOT NULL,
    DESCUENTOS DECIMAL(10,2) NOT NULL DEFAULT 0,
    MONTO_TOTAL DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_FACTURA_RESERVA FOREIGN KEY (FK_RESERVACION) REFERENCES RESERVACION(PK_ID_RESERVACION),
    CONSTRAINT FK_FACTURA_METODO FOREIGN KEY (FK_METODO_PAGO) REFERENCES METODO_PAGO(PK_ID_METODO)
);

CREATE TABLE USUARIO_SISTEMA (
    PK_ID_USUARIO INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_USUARIO VARCHAR(40) UNIQUE NOT NULL,
    CLAVE_HASH VARCHAR(200) NOT NULL,
    FK_EMPLEADO INT NOT NULL,
    CONSTRAINT FK_USUARIO_EMP FOREIGN KEY (FK_EMPLEADO) REFERENCES EMPLEADO(PK_ID_EMPLEADO)
);

CREATE TABLE AUDITORIA_RESERVAS (
    PK_ID_AUDITORIA INT IDENTITY(1,1) PRIMARY KEY,
    TABLA_AFECTADA VARCHAR(50) NOT NULL,
    ACCION VARCHAR(20) NOT NULL,
    USUARIO VARCHAR(50) NOT NULL DEFAULT SYSTEM_USER,
    FECHA DATETIME NOT NULL DEFAULT GETDATE(),
    DETALLE_ADICIONAL VARCHAR(150) NULL,
    FK_ID_AFECTADO INT NULL
);

CREATE TABLE BITACORA_SISTEMA (
    PK_ID_BITACORA INT IDENTITY(1,1) PRIMARY KEY,
    FK_USUARIO INT NOT NULL,
    FECHA_ACCESO DATETIME NOT NULL DEFAULT GETDATE(),
    ACCION VARCHAR(100),
    CONSTRAINT FK_BITACORA_USUARIO FOREIGN KEY (FK_USUARIO) REFERENCES USUARIO_SISTEMA(PK_ID_USUARIO)
);
GO

-- =====================================================
-- 2. RESTRICCIÓN EXTRA
-- =====================================================

ALTER TABLE VIAJE_PROGRAMADO
ADD CONSTRAINT CHK_EstadoViaje
CHECK (ESTADO_VIAJE IN ('PROGRAMADO', 'EN_VIAJE', 'COMPLETADO', 'CANCELADO'));
GO

-- =====================================================
-- 3. FUNCIONES
-- =====================================================

CREATE OR ALTER FUNCTION fn_asientos_disponibles (@id_viaje INT)
RETURNS INT
AS
BEGIN
    DECLARE @capacidad INT, @reservados INT;

    SELECT @capacidad = A.CAPACIDAD_ASIENTOS
    FROM AUTOBUS A
    INNER JOIN VIAJE_PROGRAMADO V ON A.PK_ID_AUTOBUS = V.FK_AUTOBUS
    WHERE V.PK_ID_VIAJE = @id_viaje;

    SELECT @reservados = ISNULL(SUM(CANTIDAD_ASIENTOS), 0)
    FROM RESERVACION
    WHERE FK_VIAJE = @id_viaje
      AND ESTADO_RESERVA <> 'CANCELADA';

    RETURN ISNULL(@capacidad, 0) - ISNULL(@reservados, 0);
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

-- =====================================================
-- 4. PROCEDIMIENTOS
-- =====================================================

CREATE OR ALTER PROCEDURE sp_asignar_unidad_ruta
    @id_viaje INT,
    @id_bus INT,
    @id_chofer INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM AUTOBUS
        WHERE PK_ID_AUTOBUS = @id_bus
          AND ESTADO_UNIDAD = 'DISPONIBLE'
    )
    BEGIN
        RAISERROR('El autobús no está disponible.', 16, 1);
        RETURN;
    END

    DECLARE @fecha DATETIME;
    SELECT @fecha = FECHA_SALIDA
    FROM VIAJE_PROGRAMADO
    WHERE PK_ID_VIAJE = @id_viaje;

    IF EXISTS (
        SELECT 1
        FROM VIAJE_PROGRAMADO
        WHERE FK_CHOFER = @id_chofer
          AND FECHA_SALIDA = @fecha
          AND PK_ID_VIAJE <> @id_viaje
    )
    BEGIN
        RAISERROR('El conductor ya tiene un viaje asignado a esa hora.', 16, 1);
        RETURN;
    END

    UPDATE VIAJE_PROGRAMADO
    SET FK_AUTOBUS = @id_bus,
        FK_CHOFER = @id_chofer
    WHERE PK_ID_VIAJE = @id_viaje;
END;
GO

CREATE OR ALTER PROCEDURE sp_crear_reservacion
    @id_cliente INT,
    @id_viaje INT,
    @id_admin INT,
    @cantidad INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @disponibles INT = dbo.fn_asientos_disponibles(@id_viaje);

        IF @disponibles < @cantidad
        BEGIN
            RAISERROR('No hay suficientes asientos disponibles.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, CANTIDAD_ASIENTOS, ESTADO_RESERVA)
        VALUES (@id_cliente, @id_viaje, @id_admin, @cantidad, 'PENDIENTE');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_generar_factura
    @id_reservacion INT,
    @id_metodo_pago INT
AS
BEGIN
    BEGIN TRY
        DECLARE @tarifa DECIMAL(10,2),
                @asientos INT,
                @subtotal DECIMAL(10,2),
                @impuestos DECIMAL(10,2),
                @total DECIMAL(10,2),
                @num_factura VARCHAR(20);

        SELECT @tarifa = V.TARIFA_BASE,
               @asientos = R.CANTIDAD_ASIENTOS
        FROM RESERVACION R
        INNER JOIN VIAJE_PROGRAMADO V ON R.FK_VIAJE = V.PK_ID_VIAJE
        WHERE R.PK_ID_RESERVACION = @id_reservacion;

        SET @subtotal = @tarifa * @asientos;
        SET @impuestos = @subtotal * 0.13;
        SET @total = @subtotal + @impuestos;
        SET @num_factura = 'FAC-' + RIGHT('000' + CAST(@id_reservacion AS VARCHAR(10)), 3);

        INSERT INTO FACTURA (NUMERO_FACTURA, FK_RESERVACION, FK_METODO_PAGO, SUBTOTAL, IMPUESTOS, MONTO_TOTAL)
        VALUES (@num_factura, @id_reservacion, @id_metodo_pago, @subtotal, @impuestos, @total);

        UPDATE RESERVACION
        SET ESTADO_RESERVA = 'PAGADA'
        WHERE PK_ID_RESERVACION = @id_reservacion;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_reporte_ingresos
    @fecha_inicio DATETIME,
    @fecha_fin DATETIME
AS
BEGIN
    SELECT
        SUM(F.MONTO_TOTAL) AS TotalFacturado,
        COUNT(DISTINCT R.FK_VIAJE) AS CantidadViajes,
        AVG(F.MONTO_TOTAL) AS PromedioPorFactura
    FROM FACTURA F
    INNER JOIN RESERVACION R ON F.FK_RESERVACION = R.PK_ID_RESERVACION
    WHERE F.FECHA_FACTURA BETWEEN @fecha_inicio AND @fecha_fin;
END;
GO

-- =====================================================
-- 5. VISTAS
-- =====================================================

CREATE OR ALTER VIEW vista_manifiesto_viajes AS
SELECT
    V.PK_ID_VIAJE AS ID,
    R.NOMBRE_RUTA AS Ruta,
    B.PLACA AS Bus,
    E.NOMBRE_COMPLETO AS Chofer,
    V.FECHA_SALIDA AS Salida,
    V.ESTADO_VIAJE AS Estado
FROM VIAJE_PROGRAMADO V
INNER JOIN RUTA R ON V.FK_RUTA = R.PK_ID_RUTA
INNER JOIN AUTOBUS B ON V.FK_AUTOBUS = B.PK_ID_AUTOBUS
INNER JOIN EMPLEADO E ON V.FK_CHOFER = E.PK_ID_EMPLEADO;
GO

CREATE OR ALTER VIEW vista_detalle_facturacion AS
SELECT
    F.NUMERO_FACTURA AS Factura,
    C.NOMBRE_COMPLETO AS Cliente,
    C.CEDULA AS Identificacion,
    R.CANTIDAD_ASIENTOS AS Asientos,
    F.MONTO_TOTAL AS Total,
    F.FECHA_FACTURA AS Fecha
FROM FACTURA F
INNER JOIN RESERVACION R ON F.FK_RESERVACION = R.PK_ID_RESERVACION
INNER JOIN CLIENTE C ON R.FK_CLIENTE = C.PK_ID_CLIENTE;
GO

CREATE OR ALTER VIEW vista_resumen_viajes AS
SELECT
    R.NOMBRE_RUTA,
    A.PLACA,
    V.FECHA_SALIDA,
    V.ESTADO_VIAJE
FROM VIAJE_PROGRAMADO V
INNER JOIN RUTA R ON V.FK_RUTA = R.PK_ID_RUTA
INNER JOIN AUTOBUS A ON V.FK_AUTOBUS = A.PK_ID_AUTOBUS;
GO

CREATE OR ALTER VIEW vista_reporte_clientes AS
SELECT
    C.NOMBRE_COMPLETO,
    F.NUMERO_FACTURA,
    F.MONTO_TOTAL
FROM FACTURA F
INNER JOIN RESERVACION R ON F.FK_RESERVACION = R.PK_ID_RESERVACION
INNER JOIN CLIENTE C ON R.FK_CLIENTE = C.PK_ID_CLIENTE;
GO

CREATE OR ALTER VIEW v_ReporteMantenimientosAuditoria AS
SELECT
    A.PK_ID_AUDITORIA AS Id,
    A.FECHA AS Fecha,
    A.USUARIO AS Usuario,
    A.ACCION AS Accion,
    A.DETALLE_ADICIONAL AS Detalle,
    T.DESCRIPCION AS TipoReparacion,
    DATENAME(MONTH, A.FECHA) AS NombreMes,
    MONTH(A.FECHA) AS NumeroMes
FROM AUDITORIA_RESERVAS A
LEFT JOIN MANTENIMIENTO_AUTOBUS M ON A.FK_ID_AFECTADO = M.PK_ID_MANTENIMIENTO
LEFT JOIN TIPO_MANTENIMIENTO T ON M.FK_TIPO_MANTENIMIENTO = T.PK_ID_TIPO_MANT;
GO

-- =====================================================
-- 6. TRIGGERS
-- =====================================================

CREATE OR ALTER TRIGGER tr_ActualizarEstadoBusMantenimiento
ON MANTENIMIENTO_AUTOBUS
AFTER INSERT
AS
BEGIN
    UPDATE AUTOBUS
    SET ESTADO_UNIDAD = 'EN_MANTENIMIENTO'
    FROM AUTOBUS
    INNER JOIN inserted ON AUTOBUS.PK_ID_AUTOBUS = inserted.FK_AUTOBUS;

    INSERT INTO AUDITORIA_RESERVAS (TABLA_AFECTADA, ACCION, DETALLE_ADICIONAL, FK_ID_AFECTADO)
    SELECT 'MANTENIMIENTO_AUTOBUS', 'INSERT', 'Unidad enviada a taller', PK_ID_MANTENIMIENTO
    FROM inserted;
END;
GO

CREATE OR ALTER TRIGGER tr_FinalizarMantenimientoBus
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

CREATE OR ALTER TRIGGER tr_AuditoriaReservas
ON RESERVACION
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @accion VARCHAR(20);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @accion = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @accion = 'INSERT';
    ELSE
        SET @accion = 'DELETE';

    INSERT INTO AUDITORIA_RESERVAS (TABLA_AFECTADA, ACCION, DETALLE_ADICIONAL)
    VALUES ('RESERVACION', @accion, 'Movimiento en tabla de reservas');
END;
GO

CREATE OR ALTER TRIGGER tr_AuditoriaFacturas
ON FACTURA
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @accion VARCHAR(20);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @accion = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @accion = 'INSERT';
    ELSE
        SET @accion = 'DELETE';

    INSERT INTO AUDITORIA_RESERVAS (TABLA_AFECTADA, ACCION, DETALLE_ADICIONAL)
    VALUES ('FACTURA', @accion, 'Movimiento en tabla de facturas');
END;
GO

-- =====================================================
-- 7. DATOS DE PRUEBA
-- =====================================================

INSERT INTO ZONA (NOMBRE_ZONA) VALUES
('Valle Central'), ('Pacífico'), ('Caribe'), ('Zona Norte'),
('Pacífico Central'), ('Chorotega'), ('Huetar Norte'), ('Huetar Caribe'),
('Brunca'), ('Sur-Sur'), ('Península'), ('Frontera Norte'),
('Los Santos'), ('Occidente'), ('Sarapiquí');

INSERT INTO CIUDAD (NOMBRE_CIUDAD, FK_ZONA) VALUES
('San José', 1), ('Alajuela', 1), ('Cartago', 1), ('Puntarenas', 2),
('Limón', 3), ('Liberia', 2), ('Ciudad Quesada', 4), ('Esparza', 5),
('Nicoya', 6), ('Guápiles', 7), ('Pérez Zeledón', 9), ('Quepos', 8),
('Jacó', 5), ('San Ramón', 14), ('Grecia', 14);

INSERT INTO DIRECCION (PROVINCIA, CANTON, DISTRITO, DESCRIPCION) VALUES
('Cartago', 'Central', 'Occidental', 'Cerca del CUC'),
('San José', 'Central', 'Carmen', 'San Pedro'),
('Alajuela', 'Central', 'Agonía', 'Costado Norte Plaza'),
('Heredia', 'Central', 'Mercedes', 'Calle 4'),
('Guanacaste', 'Liberia', 'Mayorga', 'Barrio Lajas'),
('Limón', 'Pococí', 'Guápiles', 'Frente a la terminal'),
('Puntarenas', 'Garabito', 'Jacó', 'Av. Pastor Diaz'),
('San José', 'Escazú', 'San Rafael', 'Centro Comercial'),
('Cartago', 'Paraíso', 'Llanos', 'Frente a Escuela'),
('Heredia', 'Belén', 'San Antonio', 'Cerca de Intel'),
('Alajuela', 'San Carlos', 'Quesada', 'Barrio El Carmen'),
('Puntarenas', 'Quepos', 'Savegre', 'Finca 2'),
('San José', 'Desamparados', 'San Miguel', 'Calle principal'),
('Guanacaste', 'Nicoya', 'Mansión', '50m Este Iglesia'),
('Cartago', 'La Unión', 'Tres Ríos', 'Terramall');

INSERT INTO PROFESION (DETALLE) VALUES
('Software Dev'), ('Médico'), ('Contador'), ('Docente'),
('Ingeniero Civil'), ('Arquitecto'), ('Enfermero'), ('Abogado'),
('Psicólogo'), ('Chef'), ('Mecánico'), ('Estudiante'),
('Vendedor'), ('Policía'), ('Periodista');

INSERT INTO RANGO_SALARIAL (DESCRIPCION, SALARIO_MIN, SALARIO_MAX) VALUES
('Económico', 0, 500000),
('Regular', 500001, 1500000),
('VIP', 1500001, 9999999);

INSERT INTO ROL_EMPLEADO (NOMBRE_ROL) VALUES
('Administrativo'), ('Chofer'), ('Fiscal');

INSERT INTO EMPRESA_CLIENTE (NOMBRE, TELEFONO, CORREO, FK_DIRECCION) VALUES
('Empresa A', '2222-1111', 'a@mail.com', 1),
('Tech Solutions', '2255-0000', 'info@tech.com', 2),
('ConsulTico', '2288-1111', 'hr@consultico.com', 3),
('AgroNorte', '2460-2222', 'ventas@agronorte.com', 4),
('Constructora X', '2551-3333', 'proyectos@cx.com', 5),
('Hotel Playa', '2661-4444', 'reservas@hplaya.com', 6),
('Tienda Mia', '2233-5555', 'admin@mia.com', 7),
('Taller ABC', '2552-6666', 'jefe@abc.com', 8),
('Clinica Salud', '2244-7777', 'citas@salud.com', 9),
('Banco Local', '2211-8888', 'soporte@banco.com', 10),
('Super Mercado', '2440-9999', 'contabilidad@super.com', 11),
('Escuela ABC', '2222-1010', 'dir@escuela.com', 12),
('Pura Vida S.A', '2230-1112', 'info@puravida.com', 13),
('Logística CR', '2430-1213', 'ops@logistica.com', 14),
('Exportaciones Sol', '2771-1415', 'ceo@sol.com', 15);

INSERT INTO CLIENTE (CEDULA, NOMBRE_COMPLETO, TELEFONO, CORREO, FK_PROFESION, FK_EMPRESA, FK_RANGO, FECHA_REGISTRO) VALUES
('1-1111', 'Rodrigo Alvarado', '8888-1111', 'rodri@mail.com', 1, 1, 3, GETDATE()),
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
('3-5678', 'Diana Solano', '8800-5566', 'dsolano@mail.com', 12, 12, 3, '2026-04-21'),
('4-7890', 'Marco Ruiz', '8800-7788', 'mruiz@mail.com', 13, 13, 2, '2026-04-22'),
('5-9012', 'Valeria Mora', '8800-9900', 'vmora@mail.com', 14, 14, 1, '2026-04-23'),
('6-1234', 'Esteban Jara', '8811-2233', 'ejara@mail.com', 15, 15, 2, '2026-04-23');

INSERT INTO EMPLEADO (CEDULA, NOMBRE_COMPLETO, FK_ROL, ACTIVO) VALUES
('1-0999', 'Juan Retana', 2, 1),
('1-0888', 'Ana Méndez', 1, 1),
('1-0777', 'Luis Fiscal', 3, 1),
('1-0666', 'Mario Bros', 2, 1),
('1-0555', 'Luigi Bros', 2, 1),
('1-0444', 'Peach Toad', 1, 1),
('1-0333', 'Yoshi Dino', 3, 1),
('1-0222', 'Wario Gold', 2, 1),
('1-0111', 'Daisy Flower', 1, 1),
('2-0999', 'Kevin Alpizar', 2, 1),
('2-0888', 'Felipe Castro', 2, 1),
('2-0777', 'Jimena Mata', 1, 1),
('3-0999', 'Oscar Duarte', 3, 1),
('3-0888', 'Nancy Ortiz', 2, 1),
('3-0777', 'Gabriel Umaña', 1, 1),
('V-PASS', 'Administrador Sistema', 1, 1);

INSERT INTO TIPO_AUTOBUS (DESCRIPCION) VALUES
('Premium'), ('Regular');

INSERT INTO AUTOBUS (PLACA, CAPACIDAD_ASIENTOS, FK_TIPO_AUTOBUS) VALUES
('SJB-001', 50, 1), ('SJB-002', 45, 2), ('SJB-003', 50, 1), ('SJB-004', 40, 2),
('SJB-005', 45, 1), ('SJB-006', 50, 2), ('SJB-007', 30, 1), ('SJB-008', 45, 2),
('SJB-009', 50, 1), ('SJB-010', 40, 2), ('SJB-011', 45, 1), ('SJB-012', 50, 2),
('SJB-013', 30, 1), ('SJB-014', 45, 2), ('SJB-015', 50, 1);

INSERT INTO RUTA (NOMBRE_RUTA, FK_CIUDAD_ORIGEN, FK_CIUDAD_DESTINO, DURACION_ESTIMADA_MIN) VALUES
('SJ-Cartago', 1, 3, 45),
('SJ-Limón', 1, 5, 180),
('SJ-Alajuela', 1, 2, 40),
('SJ-Puntarenas', 1, 4, 120),
('SJ-Liberia', 1, 6, 240),
('SJ-San Carlos', 1, 7, 180),
('Cartago-Limón', 3, 5, 150),
('Liberia-Puntarenas', 6, 4, 110),
('SJ-Quepos', 1, 12, 160),
('Alajuela-San Carlos', 2, 7, 130),
('SJ-Pérez Zeledón', 1, 11, 190),
('SJ-Guápiles', 1, 10, 100),
('Heredia-SJ', 9, 1, 35),
('SJ-Jacó', 1, 13, 90),
('SJ-Nicoya', 1, 9, 260);

INSERT INTO VIAJE_PROGRAMADO (FK_RUTA, FK_AUTOBUS, FK_CHOFER, FK_FISCAL, FECHA_SALIDA, TARIFA_BASE, ESTADO_VIAJE) VALUES
(1, 1, 4, 3, '2026-05-10 08:00:00', 1000, 'PROGRAMADO'),
(2, 2, 5, 7, '2026-05-10 09:00:00', 4500, 'PROGRAMADO'),
(3, 3, 6, 3, '2026-05-10 10:00:00', 1200, 'PROGRAMADO'),
(4, 4, 7, 8, '2026-05-11 06:00:00', 3500, 'PROGRAMADO'),
(5, 5, 9, 7, '2026-05-11 07:00:00', 6000, 'PROGRAMADO'),
(6, 6, 10, 13, '2026-05-12 08:30:00', 5500, 'PROGRAMADO'),
(7, 7, 11, 13, '2026-05-12 14:00:00', 4000, 'PROGRAMADO'),
(8, 8, 12, 3, '2026-05-13 05:00:00', 4500, 'PROGRAMADO'),
(9, 9, 13, 7, '2026-05-13 09:15:00', 3000, 'PROGRAMADO'),
(10, 10, 14, 13, '2026-05-14 11:00:00', 2500, 'PROGRAMADO'),
(11, 11, 4, 3, '2026-05-14 13:00:00', 5000, 'PROGRAMADO'),
(12, 12, 5, 7, '2026-05-15 08:00:00', 1000, 'PROGRAMADO'),
(13, 13, 6, 13, '2026-05-15 16:00:00', 4500, 'PROGRAMADO'),
(14, 14, 7, 3, '2026-05-16 04:00:00', 6500, 'PROGRAMADO'),
(15, 15, 8, 7, '2026-05-16 10:00:00', 3800, 'PROGRAMADO');

INSERT INTO METODO_PAGO (NOMBRE_METODO) VALUES
('Efectivo'), ('SINPE'), ('Tarjeta');

INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, CANTIDAD_ASIENTOS, ESTADO_RESERVA) VALUES
(1, 1, 2, 2, 'PENDIENTE'),
(2, 2, 9, 1, 'PENDIENTE'),
(3, 3, 12, 3, 'PENDIENTE'),
(4, 4, 15, 2, 'PENDIENTE'),
(5, 5, 9, 1, 'PENDIENTE'),
(6, 6, 12, 4, 'PENDIENTE'),
(7, 7, 15, 2, 'PENDIENTE'),
(8, 8, 9, 1, 'PENDIENTE'),
(9, 9, 12, 2, 'PENDIENTE'),
(10, 10, 15, 1, 'PENDIENTE'),
(11, 11, 9, 2, 'PENDIENTE'),
(12, 12, 12, 1, 'PENDIENTE'),
(13, 13, 15, 5, 'PENDIENTE'),
(14, 14, 9, 2, 'PENDIENTE'),
(15, 2, 12, 1, 'PENDIENTE');

INSERT INTO FACTURA (NUMERO_FACTURA, FK_RESERVACION, FK_METODO_PAGO, SUBTOTAL, IMPUESTOS, MONTO_TOTAL) VALUES
('FAC-001', 1, 3, 2000, 260, 2260),
('FAC-002', 2, 2, 4500, 585, 5085),
('FAC-003', 3, 1, 3600, 468, 4068),
('FAC-004', 4, 3, 7000, 910, 7910),
('FAC-005', 5, 2, 6000, 780, 6780),
('FAC-006', 6, 1, 22000, 2860, 24860),
('FAC-007', 7, 3, 8000, 1040, 9040),
('FAC-008', 8, 2, 4500, 585, 5085),
('FAC-009', 9, 1, 6000, 780, 6780),
('FAC-010', 10, 3, 2500, 325, 2825),
('FAC-011', 11, 2, 10000, 1300, 11300),
('FAC-012', 12, 1, 1000, 130, 1130),
('FAC-013', 13, 3, 22500, 2925, 25425),
('FAC-014', 14, 2, 13000, 1690, 14690),
('FAC-015', 15, 1, 4500, 585, 5085);

INSERT INTO TIPO_MANTENIMIENTO (DESCRIPCION) VALUES
('Preventivo'), ('Correctivo'), ('Cambio de Aceite'), ('Frenos'), ('Llantas'),
('Motor'), ('Caja Cambios'), ('Aire Acondicionado'), ('Eléctrico'),
('Tapicería'), ('Pintura'), ('Limpieza Profunda'), ('Suspensión'),
('Luces'), ('Scanner General');
GO

-- =====================================================
-- 8. USUARIO Y PRUEBAS
-- =====================================================

INSERT INTO USUARIO_SISTEMA (NOMBRE_USUARIO, CLAVE_HASH, FK_EMPLEADO)
VALUES ('admin', '1234', (SELECT TOP 1 PK_ID_EMPLEADO FROM EMPLEADO WHERE CEDULA = 'V-PASS'));
GO

UPDATE VIAJE_PROGRAMADO
SET ESTADO_VIAJE = 'EN_VIAJE'
WHERE PK_ID_VIAJE IN (1, 2);
GO