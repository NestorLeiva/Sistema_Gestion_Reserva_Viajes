using Microsoft.AspNetCore.Mvc;
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
    }
}