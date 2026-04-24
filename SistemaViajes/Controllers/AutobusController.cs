using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class AutobusController : Controller
    {
        private readonly AppDbContext _contexto;

        public AutobusController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        public IActionResult Index()
        {
            // Traemos los datos directamente. Sin lógica extra para que no se sobreescriban.
            var listaBuses = _contexto.Autobuses.ToList();
            return View(listaBuses);
        }

        [HttpGet]
        public IActionResult Crear() => View();

        [HttpPost]
        public IActionResult Crear(Autobus bus)
        {
            if (bus != null)
            {
                if (bus.FkTipoAutobus == 0) bus.FkTipoAutobus = 1;
                bus.EstadoUnidad = "DISPONIBLE";
                bus.Activo = true;

                _contexto.Autobuses.Add(bus);
                _contexto.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(bus);
        }

        [HttpGet]
        public IActionResult Editar(int id)
        {
            var bus = _contexto.Autobuses.Find(id);
            if (bus == null) return RedirectToAction("Index");
            return View(bus);
        }

        [HttpPost]
        public IActionResult Editar(Autobus bus)
        {
            if (bus != null)
            {
                var busEnDb = _contexto.Autobuses.Find(bus.PkIdAutobus);

                if (busEnDb != null)
                {
                    busEnDb.Placa = bus.Placa;
                    busEnDb.CapacidadAsientos = bus.CapacidadAsientos;
                    busEnDb.FkTipoAutobus = bus.FkTipoAutobus;

                    // IMPORTANTE: Aquí se guarda el valor del select de la pantalla amarilla
                    busEnDb.EstadoUnidad = bus.EstadoUnidad;

                    _contexto.SaveChanges();
                }
                // Después de guardar, obligamos a ir al Index para ver el cambio
                return RedirectToAction("Index");
            }
            return View(bus);
        }

        public IActionResult Eliminar(int id)
        {
            var bus = _contexto.Autobuses.Find(id);
            if (bus != null)
            {
                _contexto.Autobuses.Remove(bus);
                _contexto.SaveChanges();
            }
            return RedirectToAction("Index");
        }

        // Accion para registrar el mantenimiento y disparar el Trigger de SQL
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EnviarAMantenimiento(int idBus, int idTipoMantenimiento)
        {
            try
            {
                // 1. Ejecutamos el insert directamente en la tabla de Mantenimiento
                // Al caer este INSERT, el trigger tr_ActualizarEstadoBusMantenimiento cambia el estado del bus a 'EN_MANTENIMIENTO' automáticamente
                string query = "INSERT INTO MANTENIMIENTO_AUTOBUS (FK_AUTOBUS, FK_TIPO_MANTENIMIENTO, FECHA_INICIO) VALUES (@p0, @p1, GETDATE())";

                await _contexto.Database.ExecuteSqlRawAsync(query, idBus, idTipoMantenimiento);

                // 2. Guardamos cambios (aunque ExecuteSqlRaw ya lo hace, es buena práctica)
                await _contexto.SaveChangesAsync();

                // 3. ¡IMPORTANTE! Redirigimos al Index del mismo controlador
                // Esto refresca la lista y permite ver el bus con el nuevo estado que puso el trigger
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "No se pudo registrar el mantenimiento: " + ex.Message);
                return RedirectToAction(nameof(Index));
            }
        }

        public IActionResult ReporteAuditoria(int? mes)
        {
            // Consultamos la vista que creamos
            var auditoria = _contexto.AuditoriaReservas.AsQueryable();

            if (mes.HasValue && mes > 0)
            {
                auditoria = auditoria.Where(a => a.FechaAccion.Month == mes);
            }

            // Lista de meses para el dropdown
            ViewBag.Meses = new List<dynamic>
    {
        new { Id = 1, Nombre = "Enero" }, new { Id = 2, Nombre = "Febrero" },
        new { Id = 3, Nombre = "Marzo" }, new { Id = 4, Nombre = "Abril" },
        new { Id = 5, Nombre = "Mayo" }, new { Id = 6, Nombre = "Junio" }
    };

            return View(auditoria.OrderByDescending(a => a.FechaAccion).ToList());
        }

        public IActionResult VerAuditoria(int? mes, string tipo)
        {
            // Cargamos los meses para el combo box
            ViewBag.Meses = new List<dynamic> {
                new { Id = 1, Nombre = "Enero" }, new { Id = 2, Nombre = "Febrero" },
                new { Id = 3, Nombre = "Marzo" }, new { Id = 4, Nombre = "Abril" },
                new { Id = 5, Nombre = "Mayo" }, new { Id = 6, Nombre = "Junio" },
                new { Id = 7, Nombre = "Julio" }, new { Id = 8, Nombre = "Agosto" },
                new { Id = 9, Nombre = "Septiembre" }, new { Id = 10, Nombre = "Octubre" },
                new { Id = 11, Nombre = "Noviembre" }, new { Id = 12, Nombre = "Diciembre" },
    };

            var consulta = _contexto.AuditoriaReservas.AsQueryable();

            // Filtro por Mes
            if (mes.HasValue && mes > 0)
            {
                consulta = consulta.Where(a => a.FechaAccion.Month == mes);
            }

            // Filtro por Tipo de Reparación (Buscando en el texto del detalle)
            if (!string.IsNullOrEmpty(tipo))
            {
                consulta = consulta.Where(a => a.DetalleAdicional.Contains(tipo));
            }

            return View(consulta.OrderByDescending(a => a.FechaAccion).ToList());
        }

        public IActionResult PantallaReportes(int? filtroMes, string filtroTipo)
        {
            // Usamos SQL crudo para leer la VISTA que creamos
            var reporte = _contexto.Database.SqlQueryRaw<ReporteMantenimientoVM>(
                "SELECT * FROM v_ReporteMantenimientosAuditoria"
            ).ToList().AsQueryable();

            // Filtro por Mes
            if (filtroMes.HasValue && filtroMes > 0)
                reporte = reporte.Where(x => x.NumeroMes == filtroMes);

            // Filtro por Tipo de Reparación
            if (!string.IsNullOrEmpty(filtroTipo))
            {
                // Agregamos la verificación de x.TipoReparacion != null
                reporte = reporte.Where(x => x.TipoReparacion != null &&
                                             x.TipoReparacion.Contains(filtroTipo, StringComparison.OrdinalIgnoreCase));
            }

            return View(reporte.ToList());
        }

        public async Task<IActionResult> ReporteIngresos(DateTime? fechaInicio, DateTime? fechaFin)
        {
            // Por defecto, mostramos el último mes si no hay fechas
            var inicio = fechaInicio ?? DateTime.Now.AddMonths(-1);
            var fin = fechaFin ?? DateTime.Now;

            // Llamamos al SP. Asegurate de que el nombre coincida con SQL
            var resultado = await _contexto.Set<IngresoReporteVM>()
                .FromSqlRaw("EXEC sp_reporte_ingresos {0}, {1}", inicio, fin)
                .ToListAsync();

            var reporte = resultado.FirstOrDefault() ?? new IngresoReporteVM();
            reporte.FechaInicio = inicio;
            reporte.FechaFin = fin;

            return View(reporte);
        }

    }
}