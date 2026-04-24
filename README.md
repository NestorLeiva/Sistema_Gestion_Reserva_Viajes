# Sistema de Gestión de Reservas y Operaciones - Transporte - Cartago 🚌

Este proyecto es una solución integral para la gestión de una empresa de transportes, desarrollada como parte del curso de **Fundamentos de Bases de Datos** en el **Colegio Universitario de Cartago (CUC)**. El sistema permite administrar la flota de autobuses, la programación de viajes y el control de mantenimiento con auditoría integrada.

## 🚀 Características Principales
- **Gestión de Flota:** Control total de unidades, capacidades y estados (Activo, En Mantenimiento, Fuera de Servicio).
- **Venta de Asientos y Facturación:** Sistema automatizado para la reserva de espacios con generación de facturas en tiempo real.
- **Auditoría Automatizada:** Implementación de **Triggers** en SQL Server para el seguimiento obligatorio de movimientos en las tablas de `RESERVACIONES` y `FACTURAS`.
- **Panel de Control (Dashboard):** Resumen visual dinámico que muestra unidades en taller, total de clientes y viajes programados.
- **Reportes Especializados:** - Bitácora de mantenimiento generada mediante **Vistas SQL**.
  - Análisis financiero (ingresos, promedios y cantidad de viajes) mediante **Procedimientos Almacenados**.

## 🛠️ Stack Tecnológico
- **Backend:** C# con ASP.NET Core MVC 10
- **Frontend:** HTML5, CSS3 (Bootstrap 5) y Bootstrap Icons.
- **Base de Datos:** SQL Server 2022.
- **ORM:** Entity Framework Core (Enfoque Database First con mapeo manual para optimización).

## 📊 Arquitectura de Base de Datos
El sistema delega la lógica de integridad y cálculos pesados al motor de base de datos para garantizar la consistencia:
1.  **Triggers:** `tr_AuditoriaReservas` y `tr_AuditoriaFacturas` (Garantizan que cada cambio quede registrado para fines contables).
2.  **Vistas:** `v_ReporteMantenimientosAuditoria` (Consolidación de datos entre auditoría y tipos de reparación).
3.  **Procedimientos Almacenados:** `sp_reporte_ingresos` (Centralización de la lógica de cálculo de ingresos por rango de fechas).

## 🔧 Configuración e Instalación
1.  **Base de Datos:**
    - Ejecutar el script SQL proporcionado en la carpeta del proyecto para crear las tablas, relaciones y objetos de programación (SP/Triggers/Vistas).
2.  **Aplicación:**
    - Abrir la solución en **Visual Studio 2022**.
    - Configurar el `Connection String` en el archivo `appsettings.json`:
      ```json
      "ConnectionStrings": {
        "DefaultConnection": "Server=TU_SERVIDOR;Database=SistemaViajes;Trusted_Connection=True;TrustServerCertificate=True"
      }
      ```
    - Restaurar los paquetes NuGet y ejecutar el proyecto (F5).

## ✒️ Autores
- **Nestor Leiva** - Estudiante de Tecnologias de la Informaicion, CUC.
- **Rodrigo Elias** - Estudiante de Tecnologias de la Informaicion, CUC.

---
*Proyecto académico correspondiente al I Cuatrimestre, 2026. Cartago, Costa Rica.*