USE SISTEMA_RESERVA_VIAJES;
GO

-- 1. CATALOGOS BASICOS (SIN DEPENDENCIAS)
INSERT INTO ZONA (NOMBRE_ZONA) VALUES 
('Valle Central'), ('Pacifico'), ('Caribe'), ('Guanacaste'), ('Zona Norte'), 
('Puntarenas'), ('Limon'), ('Heredia'), ('Alajuela'), ('Cartago'),
('Zona de los Santos'), ('Pacifico Sur'), ('Chirripo'), ('Vara Blanca'), ('Sarapiqui');

INSERT INTO PROFESION (DETALLE) VALUES 
('Ingeniero'), ('Estudiante'), ('Comerciante'), ('Medico'), ('Abogado'), 
('Docente'), ('Arquitecto'), ('Contador'), ('Psicologo'), ('Administrador'),
('Enfermero'), ('Chef'), ('Mecanico Dental'), ('Periodista'), ('Guia Turistico');

INSERT INTO RANGO_SALARIAL (DESCRIPCION, SALARIO_MIN, SALARIO_MAX) VALUES 
('Minimo', 0, 350000), ('Bajo', 350001, 500000), ('Medio', 500001, 800000),
('Medio Alto', 800001, 1200000), ('Alto', 1200001, 2000000), ('Gerencial', 2000001, 3000000),
('Ejecutivo', 3000001, 4500000), ('Senior', 4500001, 6000000), ('Especialista', 6000001, 8000000),
('Maximo', 8000001, 15000000),
('Pasante', 100000, 250000), ('Tecnico', 400000, 600000), 
('Senior II', 5500000, 6500000), ('Consultor', 7000000, 8500000), ('Director', 10000000, 20000000);

INSERT INTO ROL_EMPLEADO (NOMBRE_ROL) VALUES 
('Administrativo'), ('Chofer'), ('Fiscal'), ('Mecanico'), ('Limpieza'),
('Seguridad'), ('Gerente'), ('Recursos Humanos'), ('Atencion Cliente'), ('Despachador'),
('Supervisor'), ('Bodeguero'), ('Mensajero'), ('Analista'), ('Contralor');

INSERT INTO TIPO_AUTOBUS (DESCRIPCION) VALUES 
('Pullman Lujo'), ('Regular'), ('Buseta'), ('Microbus'), ('Express'),
('Escolar'), ('Turismo'), ('Doble Piso'), ('Electrico'), ('Articulado'),
('Van Ejecutiva'), ('Bus Urbano'), ('Semiautobus'), ('Interurbano Lujo'), ('Bus Rural');

INSERT INTO METODO_PAGO (NOMBRE_METODO) VALUES 
('Efectivo'), ('Tarjeta'), ('SINPE Movil'), ('Transferencia'), ('App'),
('Monedero'), ('Vale'), ('PayPal'), ('Bitcoin'), ('Cheque'),
('Apple Pay'), ('Google Pay'), ('Cupon'), ('Canje'), ('Puntos');

INSERT INTO TIPO_MANTENIMIENTO (DESCRIPCION) VALUES 
('Aceite'), ('Frenos'), ('Llantas'), ('Motor'), ('Caja'), 
('Electrico'), ('Aire'), ('Carroceria'), ('Suspension'), ('Limpieza'),
('Escobillas'), ('Bateria'), ('Radiador'), ('Transmision'), ('Inyectores');

-- 2. TABLAS CON DEPENDENCIAS NIVEL 1
INSERT INTO CIUDAD (NOMBRE_CIUDAD, FK_ZONA) VALUES 
('San Jose', 1), ('Perez Zeledon', 1), ('Alajuela', 9), ('San Carlos', 5), 
('Cartago', 10), ('Turrialba', 10), ('Heredia', 8), ('Liberia', 4), 
('Nicoya', 4), ('Puntarenas', 6),
('San Vito', 9), ('Golfito', 9), ('San Marcos', 11), ('Frailes', 11), ('Puerto Viejo', 7);

INSERT INTO EMPRESA_CLIENTE (NOMBRE, TELEFONO, CORREO, DIRECCION) VALUES 
('GTS', '25510000', 'info@gts.cr', 'Cartago'), ('Intel', '22981000', 'info@intel.com', 'Heredia'),
('Amazon', '25223000', 'info@amazon.com', 'San Jose'), ('FIFCO', '24370000', 'info@fifco.com', 'Alajuela'),
('CUC', '25506150', 'info@cuc.ac.cr', 'Cartago'), ('Microsoft', '22050000', 'info@ms.com', 'Escazu'),
('BNCR', '22122000', 'info@bncr.fi.cr', 'San Jose'), ('CCSS', '25390000', 'info@ccss.sa.cr', 'San Jose'),
('ICE', '20007000', 'info@ice.go.cr', 'Sabana'), ('Walmart', '8008000', 'info@walmart.com', 'Heredia'),
('Hacienda Pinilla', '26814400', 'info@pinilla.com', 'Guanacaste'),
('Boston Scientific', '22115500', 'info@bsc.com', 'Coyol'),
('Procter y Gamble', '22045500', 'info@pg.com', 'Santa Ana'),
('Dos Pinos', '24373000', 'info@dospinos.com', 'Alajuela'),
('Coyol Free Zone', '24358800', 'info@coyol.com', 'Alajuela');

INSERT INTO EMPLEADO (CEDULA, NOMBRE_COMPLETO, TELEFONO, CORREO, FK_ROL, ACTIVO) VALUES 
('305550111', 'Juan Perez', '88881111', 'juan@bus.cr', 2, 1),
('102220333', 'Maria Lopez', '88882222', 'maria@bus.cr', 3, 1),
('204440666', 'Pedro Chaves', '88883333', 'pedro@bus.cr', 1, 1),
('408880999', 'Ana Solano', '88884444', 'ana@bus.cr', 2, 1),
('501110222', 'Luis Vargas', '88885555', 'luis@bus.cr', 4, 1),
('603330444', 'Elena Castro', '88886666', 'elena@bus.cr', 3, 1),
('705550666', 'Jorge Mora', '88887777', 'jorge@bus.cr', 2, 1),
('109990888', 'Sofia Mendez', '88888888', 'sofia@bus.cr', 9, 1),
('302220111', 'Mario Ortiz', '88889999', 'mario@bus.cr', 7, 1),
('207770555', 'Karla Brenes', '87771111', 'karla@bus.cr', 2, 1),
('101110222', 'Raul Gomez Solano', '88112233', 'raul@bus.cr', 2, 1),
('202220333', 'Silvia Mata Cruz', '88223344', 'silvia@bus.cr', 3, 1),
('303330444', 'Esteban Rojas Paz', '88334455', 'esteban@bus.cr', 1, 1),
('404440555', 'Monica Ruiz Vila', '88445566', 'monica@bus.cr', 2, 1),
('505550666', 'Victor Mora Sanz', '88556677', 'victor@bus.cr', 3, 1);

-- 3. TABLAS CON DEPENDENCIAS NIVEL 2
INSERT INTO CLIENTE (CEDULA, NOMBRE_COMPLETO, TELEFONO, CORREO, FK_PROFESION, FK_EMPRESA, FK_RANGO, FECHA_REGISTRO) VALUES 
('301230456', 'Andres Jimenez', '83451212', 'aj@mail.com', 1, 1, 4, GETDATE()),
('109870654', 'Lucia Fernandez', '60123456', 'lf@mail.com', 2, 5, 1, GETDATE()),
('205550444', 'Roberto Quesada', '88119900', 'rq@mail.com', 3, 4, 3, GETDATE()),
('402220333', 'Beatriz Alfaro', '70112233', 'ba@mail.com', 4, NULL, 2, GETDATE()),
('501110999', 'Gabriel Torres', '85223344', 'gt@mail.com', 5, 2, 5, GETDATE()),
('603330888', 'Fabiola Sanchez', '86334455', 'fs@mail.com', 6, NULL, 3, GETDATE()),
('704440777', 'Ignacio Campos', '89445566', 'ic@mail.com', 7, 3, 6, GETDATE()),
('115550222', 'Valeria Duarte', '84556677', 'vd@mail.com', 8, 7, 4, GETDATE()),
('206660111', 'Oscar Murillo', '87667788', 'om@mail.com', 9, NULL, 5, GETDATE()),
('307770000', 'Laura Quiros', '88778899', 'lq@mail.com', 10, 6, 7, GETDATE()),
('112220333', 'Diana Meza', '88001122', 'dm@mail.com', 1, 2, 5, GETDATE()),
('223330444', 'Felipe Soto', '88112233', 'fs@mail.com', 2, 5, 1, GETDATE()),
('334440555', 'Karina Oreamuno', '88223344', 'ko@mail.com', 3, 1, 4, GETDATE()),
('445550666', 'Hugo Herrera', '88334455', 'hh@mail.com', 4, NULL, 2, GETDATE()),
('556660777', 'Sandra Villalta', '88445566', 'sv@mail.com', 5, 3, 6, GETDATE());

INSERT INTO AUTOBUS (PLACA, CAPACIDAD_ASIENTOS, FK_TIPO_AUTOBUS, ANNO_FABRICACION, ACTIVO) VALUES 
('SJB1001', 54, 1, 2025, 1), ('SJB2002', 50, 2, 2023, 1),
('AB3003', 30, 3, 2024, 1), ('CB4004', 15, 4, 2022, 1),
('HB5005', 54, 1, 2025, 1), ('GB6006', 50, 2, 2021, 1),
('PB7007', 45, 5, 2023, 1), ('LB8008', 54, 1, 2024, 1),
('SJB9009', 60, 8, 2025, 1), ('CB1011', 15, 4, 2024, 1),
('SJB2025', 54, 1, 2025, 1), ('AB2024', 45, 2, 2024, 1),
('CB2023', 15, 3, 2023, 1), ('HB2025', 54, 1, 2025, 1),
('LB2024', 50, 2, 2024, 1);

INSERT INTO RUTA (NOMBRE_RUTA, FK_CIUDAD_ORIGEN, FK_CIUDAD_DESTINO, DURACION_ESTIMADA_MIN) VALUES 
('San Jose - Liberia', 1, 8, 300), ('Cartago - San Jose', 5, 1, 45),
('Puntarenas - San Jose', 10, 1, 120), ('Alajuela - San Carlos', 3, 4, 150),
('San Jose - Cartago', 1, 5, 45), ('San Jose - Perez Zeledon', 1, 2, 210),
('Turrialba - Cartago', 6, 5, 90), ('Heredia - San Jose', 7, 1, 40),
('Liberia - Nicoya', 8, 9, 120), ('Nicoya - San Jose', 9, 1, 240),
('San Jose - Golfito', 1, 12, 420), ('Cartago - Frailes', 5, 14, 60),
('Liberia - San Vito', 8, 11, 480), ('San Marcos - San Jose', 13, 1, 120),
('Alajuela - Puerto Viejo', 3, 15, 240);

-- 4. TABLAS TRANSACCIONALES FINALES
INSERT INTO VIAJE_PROGRAMADO (FK_RUTA, FK_AUTOBUS, FK_CHOFER, FK_FISCAL, FECHA_SALIDA, HORA_SALIDA, TARIFA_BASE, ESTADO) VALUES 
(1, 1, 1, 2, '2026-04-01', '06:00:00', 8500, 'Programado'),
(2, 2, 4, 6, '2026-04-01', '08:00:00', 3000, 'Programado'),
(3, 3, 7, 2, '2026-04-01', '10:00:00', 4500, 'Programado'),
(4, 4, 10, 6, '2026-04-02', '05:30:00', 5000, 'Programado'),
(5, 5, 1, 2, '2026-04-02', '13:00:00', 6500, 'Programado'),
(6, 6, 4, 6, '2026-04-02', '15:00:00', 7000, 'Programado'),
(7, 7, 7, 2, '2026-04-03', '07:00:00', 2500, 'Programado'),
(8, 8, 10, 6, '2026-04-03', '09:00:00', 1500, 'Programado'),
(9, 9, 1, 2, '2026-04-04', '04:00:00', 4000, 'Programado'),
(10, 10, 4, 6, '2026-04-04', '14:00:00', 5500, 'Programado'),
(11, 11, 1, 2, '2026-04-10', '05:00:00', 9500, 'Programado'),
(12, 12, 4, 6, '2026-04-10', '07:30:00', 3500, 'Programado'),
(13, 13, 7, 2, '2026-04-11', '13:00:00', 12000, 'Programado'),
(14, 14, 10, 6, '2026-04-11', '15:00:00', 2500, 'Programado'),
(15, 15, 11, 12, '2026-04-12', '06:00:00', 8000, 'Programado');

INSERT INTO RESERVACION (FK_CLIENTE, FK_VIAJE, FK_ADMINISTRATIVO, FECHA_RESERVA, HORA_RESERVA, CANTIDAD_ASIENTOS, ESTADO) VALUES 
(1, 1, 3, '2026-03-15', '10:00:00', 2, 'Confirmada'),
(2, 2, 3, '2026-03-15', '11:30:00', 1, 'Confirmada'),
(3, 3, 3, '2026-03-16', '09:00:00', 1, 'Confirmada'),
(4, 4, 3, '2026-03-16', '14:20:00', 3, 'Confirmada'),
(5, 5, 3, '2026-03-17', '08:45:00', 1, 'Confirmada'),
(6, 6, 3, '2026-03-17', '16:10:00', 2, 'Confirmada'),
(7, 7, 3, '2026-03-18', '12:00:00', 1, 'Confirmada'),
(8, 8, 3, '2026-03-18', '10:30:00', 4, 'Confirmada'),
(9, 9, 3, '2026-03-19', '11:00:00', 1, 'Confirmada'),
(10, 10, 3, '2026-03-19', '15:00:00', 2, 'Confirmada'),
(11, 11, 3, GETDATE(), '08:00:00', 1, 'Confirmada'),
(12, 12, 3, GETDATE(), '09:30:00', 2, 'Confirmada'),
(13, 13, 3, GETDATE(), '10:15:00', 1, 'Confirmada'),
(14, 14, 3, GETDATE(), '14:00:00', 1, 'Confirmada'),
(15, 15, 3, GETDATE(), '16:45:00', 3, 'Confirmada');

INSERT INTO FACTURA (NUMERO_FACTURA, FK_RESERVACION, FK_METODO_PAGO, FECHA_FACTURA, MONTO_TOTAL) VALUES 
('FAC001', 1, 3, GETDATE(), 17000), ('FAC002', 2, 2, GETDATE(), 3000),
('FAC003', 3, 1, GETDATE(), 4500), ('FAC004', 4, 3, GETDATE(), 15000),
('FAC005', 5, 2, GETDATE(), 6500), ('FAC006', 6, 3, GETDATE(), 14000),
('FAC007', 7, 1, GETDATE(), 2500), ('FAC008', 8, 2, GETDATE(), 6000),
('FAC009', 9, 3, GETDATE(), 4000), ('FAC010', 10, 1, GETDATE(), 11000),
('FAC011', 11, 1, GETDATE(), 9500), ('FAC012', 12, 2, GETDATE(), 7000),
('FAC013', 13, 3, GETDATE(), 12000), ('FAC014', 14, 1, GETDATE(), 2500),
('FAC015', 15, 2, GETDATE(), 24000);

INSERT INTO DETALLE_FACTURA (FK_FACTURA, DESCRIPCION, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL) VALUES 
(1, 'Tiquete San Jose - Liberia', 2, 8500.00, 17000.00),
(2, 'Tiquete Cartago - San Jose', 1, 3000.00, 3000.00),
(3, 'Tiquete Puntarenas - San Jose', 1, 4500.00, 4500.00),
(4, 'Tiquete Alajuela - San Carlos', 3, 5000.00, 15000.00),
(5, 'Tiquete San Jose - Cartago', 1, 6500.00, 6500.00),
(6, 'Tiquete San Jose - Perez Zeledon', 2, 7000.00, 14000.00),
(7, 'Tiquete Turrialba - Cartago', 1, 2500.00, 2500.00),
(8, 'Tiquete Heredia - San Jose', 4, 1500.00, 6000.00),
(9, 'Tiquete Liberia - Nicoya', 1, 4000.00, 4000.00),
(10, 'Tiquete Nicoya - San Jose', 2, 5500.00, 11000.00),
(11, 'Tiquete SJ-Golfito', 1, 9500, 9500),
(12, 'Tiquete Cartago-Frailes', 2, 3500, 7000),
(13, 'Tiquete Liberia-San Vito', 1, 12000, 12000),
(14, 'Tiquete San Marcos-SJ', 1, 2500, 2500),
(15, 'Tiquete Alajuela-PV', 3, 8000, 24000);

-- 5. OTRAS TABLAS AUXILIARES
INSERT INTO DEKRA (FK_AUTOBUS, FECHA_EMISION, FECHA_VENCIMIENTO, RESULTADO, OBSERVACIONES) VALUES 
(1, '2025-01-10', '2026-01-10', 'Aprobado', 'Sin defectos'),
(2, '2025-02-15', '2025-03-15', 'Rechazado', 'Fallas en sistema de frenos'),
(3, '2024-11-20', '2025-11-20', 'Aprobado', 'Llantas nuevas'),
(4, '2025-03-01', '2026-03-01', 'Aprobado', 'Emisiones gases OK'),
(5, '2025-01-05', '2025-02-05', 'Rechazado', 'Fuga de aceite motor'),
(6, '2024-12-12', '2025-12-12', 'Aprobado', 'Luces ajustadas'),
(7, '2025-02-28', '2026-02-28', 'Aprobado', 'Todo en orden'),
(8, '2025-01-20', '2025-02-20', 'Rechazado', 'Desequilibrio en ejes'),
(9, '2025-03-10', '2026-03-10', 'Aprobado', 'Unidad nueva'),
(10, '2024-10-15', '2025-10-15', 'Aprobado', 'Revision semestral'),
(11, '2025-01-12', '2025-02-12', 'Rechazado', 'Escobillas en mal estado'),
(12, '2025-02-01', '2026-02-01', 'Aprobado', 'Excelente estado'),
(13, '2024-09-30', '2025-09-30', 'Aprobado', 'Sin observaciones'),
(14, '2025-03-15', '2025-04-15', 'Rechazado', 'Exceso de opacidad'),
(15, '2025-02-20', '2026-02-20', 'Aprobado', 'Frenos recien cambiados');

INSERT INTO MARCHAMO (FK_AUTOBUS, ANNO, FECHA_PAGO, FECHA_VENCIMIENTO, MONTO, ESTADO) VALUES 
(1, 2026, '2025-12-15', '2026-12-31', 450000, 'Pagado'),
(2, 2026, '2025-12-20', '2026-12-31', 380000, 'Pagado'),
(3, 2024, '2022-01-01', '2024-12-31', 320000, 'No Pagado'), 
(4, 2026, '2025-12-28', '2026-12-31', 150000, 'Pagado'),
(5, 2026, '2025-12-05', '2026-12-31', 450000, 'Pagado'),
(6, 2026, '2025-12-18', '2026-12-31', 385000, 'Pagado'),
(7, 2023, '2020-01-01', '2023-12-31', 290000, 'No Pagado'),
(8, 2026, '2025-12-30', '2026-12-31', 450000, 'Pagado'),
(9, 2026, '2026-01-02', '2026-12-31', 520000, 'Pagado'),
(10, 2025, '2023-01-01', '2025-12-31', 155000, 'No Pagado'),
(11, 2026, '2025-12-27', '2026-12-31', 450000, 'Pagado'),
(12, 2026, '2025-11-30', '2026-12-31', 310000, 'Pagado'),
(13, 2022, '2020-01-01', '2022-12-31', 280000, 'No Pagado'),
(14, 2026, '2025-12-12', '2026-12-31', 120000, 'Pagado'),
(15, 2026, '2025-12-20', '2026-12-31', 400000, 'Pagado');

INSERT INTO MANTENIMIENTO_AUTOBUS (FK_AUTOBUS, FK_TIPO_MANTENIMIENTO, FECHA_MANTENIMIENTO, COSTO, DESCRIPCION_TRABAJO) VALUES 
(1, 1, '2026-02-01', 75000, 'Cambio de aceite sintetico'),
(2, 2, '2026-02-05', 120000, 'Cambio de fibras delanteras'),
(3, 3, '2026-02-10', 450000, 'Juego de llantas nuevas'),
(4, 6, '2026-02-15', 55000, 'Reparacion de luces traseras'),
(5, 7, '2026-02-20', 90000, 'Recarga de aire acondicionado'),
(6, 4, '2026-02-25', 1500000, 'Overhaul completo de motor'),
(7, 9, '2026-03-01', 210000, 'Cambio de compensadores'),
(8, 5, '2026-03-05', 320000, 'Reparacion de caja de cambios'),
(9, 10, '2026-03-10', 35000, 'Lavado de tapiceria'),
(10, 8, '2026-03-12', 45000, 'Pintura de defensa frontal'),
(11, 1, '2026-01-15', 60000, 'Cambio de aceite y filtros'),
(12, 2, '2026-01-20', 110000, 'Revision de sistema de frenado'),
(13, 11, '2026-02-18', 25000, 'Cambio de escobillas limpiaparabrisas'),
(14, 12, '2026-02-22', 85000, 'Cambio de bateria 12V'),
(15, 13, '2026-03-01', 120000, 'Limpieza profunda de radiador');

INSERT INTO USUARIO_SISTEMA (NOMBRE_USUARIO, CLAVE_HASH, FK_EMPLEADO) VALUES 
('admin_pedro', 'hash1', 3), ('sofia_m', 'hash2', 8), ('mario_o', 'hash3', 9),
('juan_p', 'hash4', 1), ('maria_l', 'hash5', 2), ('ana_s', 'hash6', 4),
('luis_v', 'hash7', 5), ('elena_c', 'hash8', 6), ('jorge_m', 'hash9', 7),
('karla_b', 'hash10', 10), ('raul_g', 'hash11', 11), ('silvia_m', 'hash12', 12),
('esteban_r', 'hash13', 13), ('monica_r', 'hash14', 14), ('victor_m', 'hash15', 15);