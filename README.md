# Sistema_Gestion_Reserva_Viajes
Proyecto de Curso Fundamentos de Bases de Datos


Descripción del Proyecto
Sistema de Gestión de Reservas de Viajes Terrestres es un proyecto académico para el curso TI-142 Fundamentos de Bases de Datos del Colegio Universitario de Cartago, I Cuatrimestre 2026. Este sistema modela una agencia de viajes terrestres (autobuses) con una base de datos relacional que integra al menos 20 tablas para gestionar clientes, autobuses, reservas, empleados, facturación y más. La base de datos está normalizada hasta 3NF y soporta consultas complejas, validaciones como Dekra/marchamo vigentes y operaciones CRUD.

Objetivos Principales
Diseñar e implementar un modelo lógico y físico de base de datos relacional con mínimo 20 entidades interconectadas.

Garantizar normalización 3NF para eliminar redundancias y mantener integridad referencial mediante PK, FK, constraints y triggers.

Desarrollar scripts SQL completos para creación, inserción de datos (mínimo 15 tuplas por tabla) y demostración de funcionalidad.
​

Objetivos Secundarios
Crear una aplicación en Python o C# para operaciones CRUD en tablas clave (Reservaciones y Autobuses).

Implementar bitácora de accesos, métodos de pago locales (SINPE, transferencias) y restricciones operativas (ej. no reservar buses sin permisos vigentes).

Optimizar rendimiento con índices y consultas complejas para reportes de agencia.
​

Habilidades y Tecnologías
Categoría	Detalles
Modelado BD	ER lógico/físico, Diccionario de datos, Normalización 3NF 
​
SQL	DDL (CREATE TABLE), DML (INSERT, SELECT), Constraints (PK/FK/CHECK/UNIQUE), Índices, Triggers 
​
Programación	Python/C# para CRUD, Conexión a BD (ej. MySQL/SQL Server)
Herramientas	MySQL Workbench/SQL Server Management Studio, Git/GitHub para control de versiones
Validaciones	Fechas vigentes Dekra/Marchamo, Rango salarial clientes, Fiscalización rutas
Estructura del Proyecto
text
projeto-sistema-reservas-viajes/
├── docs/
│   ├── Diagrama_ER.png              # Modelo Entidad-Relación lógico
│   ├── Modelo_Relacional.pdf        # Representación física tablas
│   └── Diccionario_Datos.xlsx       # Atributos, tipos, constraints por tabla
├── sql/
│   ├── 01_create_tables.sql         # Scripts DDL todas las tablas (60 pts)
│   ├── 02_insert_data.sql           # 15+ tuplas por tabla (20 pts)
│   ├── 03_select_demos.sql          # Consultas de verificación
│   └── 04_triggers_procedures.sql   # Lógica adicional (checks Dekra, etc.)
├── app/
│   ├── crud_reservas_autobuses.py   # Aplicación Python/C# CRUD (15 pts)
│   └── config_db.py                 # Conexión a BD
├── README.md                        # Este archivo
└── .gitignore
Tablas Clave Implementadas (basado en requisitos):

Clientes, Autobuses, Reservaciones, Empleados (choferes/admin/fiscales)

Facturas, MetodosPago, Rutas, Zonas, Mantenimiento, Bitacora
​

Estado de Avance
Entregable 1 (Completado)
✅ Diagrama ER, Modelo Relacional, Diccionario de Datos (normalizado 3NF).

Entregado: 6 de marzo 2026.
​

Entregable 2 (En Desarrollo)
🔄 Scripts SQL DDL/DML en progreso (tablas con constraints completas).

🔄 Inserciones de datos de prueba listas para lab (creación "en caliente").

🔄 CRUD Python básico para Reservaciones/Autobuses (conexión exitosa).

Próxima entrega: 20 de marzo 2026, 18:00H.
​

Instalación y Uso
Requisitos: MySQL 8.0+ o SQL Server, Python 3.10+ (si aplica), Git.

Clonar Repo: git clone <url> && cd proyecto-sistema-reservas-viajes

Crear BD: Ejecutar sql/01_create_tables.sql en workbench/lab.

Poblar Datos: sql/02_insert_data.sql

Probar Consultas: sql/03_select_demos.sql

Ejecutar CRUD: python app/crud_reservas_autobuses.py

Ejemplo Consulta Compleja:

sql
SELECT c.nombre, r.fecha_viaje, a.placa
FROM Reservaciones r
JOIN Clientes c ON r.cliente_id = c.id
JOIN Autobuses a ON r.autobus_id = a.id
WHERE a.dekra_vigente >= CURDATE() AND r.estado = 'confirmada';
Aprendizajes Esperados
Modelado avanzado de BD relacionales con entidades complejas.

Optimización y seguridad de datos en entornos reales.

Integración BD-aplicación con validaciones empresariales.

Buenas prácticas: Documentación, versionado, testing.

Autores y Contribuidores
Nestor Leiva 
Rodrigo Elias
