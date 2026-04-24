using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering; // Necesario para los SelectList
using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class ViajeController : Controller
    {
        private readonly AppDbContext _contexto;

        public ViajeController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        // 1. LISTADO (Ya lo tenías excelente)
        public IActionResult Index()
        {
            var viajes = _contexto.ViajesProgramados
                .Include(v => v.FkRutaNavigation)
                .Include(v => v.FkAutobusNavigation)
                .Include(v => v.FkChoferNavigation)
                .ToList();
            return View(viajes);
        }

        // 2. CREAR (GET) - Carga los combos
        [HttpGet]
        public IActionResult Crear()
        {
            CargarCombos();
            return View();
        }

        // 3. CREAR (POST)
        [HttpPost]
        public IActionResult Crear(ViajeProgramado viaje)
        {
            if (viaje != null)
            {
                // Forzamos el fiscal por defecto si no se selecciona (según tu DB)
                if (viaje.FkFiscal == 0) viaje.FkFiscal = 3;

                viaje.EstadoViaje = "PROGRAMADO"; // Estado inicial

                _contexto.ViajesProgramados.Add(viaje);
                _contexto.SaveChanges();
                return RedirectToAction(nameof(Index));
            }
            CargarCombos();
            return View(viaje);
        }

        // 4. EDITAR (GET)
        [HttpGet]
        public IActionResult Editar(int id)
        {
            var viaje = _contexto.ViajesProgramados.Find(id);
            if (viaje == null) return RedirectToAction(nameof(Index));

            CargarCombos();
            return View(viaje);
        }

        // 5. EDITAR (POST)
        [HttpPost]
        public IActionResult Editar(ViajeProgramado viaje)
        {
            if (viaje != null)
            {
                // Validación de seguridad: si el fiscal llega en 0, le asignamos el ID 3
                // Esto evita el conflicto de Llave Foránea (FK)
                if (viaje.FkFiscal == 0)
                {
                    viaje.FkFiscal = 3;
                }

                try
                {
                    _contexto.Entry(viaje).State = EntityState.Modified;
                    _contexto.SaveChanges();
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    // Si hay un error de SQL, lo capturamos para que no se cierre la App
                    var message = ex.InnerException?.Message ?? ex.Message;
                    ModelState.AddModelError("", "Error al guardar: Verifique que todos los IDs sean válidos. " + message);
                }
            }

            CargarCombos();
            return View(viaje);
        }

        // Método auxiliar para no repetir código de los SelectLists
        private void CargarCombos()
        {
            ViewBag.Rutas = new SelectList(_contexto.Rutas, "PkIdRuta", "NombreRuta");

            // Quitamos el filtro de "DISPONIBLE" solo para probar si es eso lo que bloquea el update
            ViewBag.Buses = new SelectList(_contexto.Autobuses, "PkIdAutobus", "Placa");

            ViewBag.Choferes = new SelectList(_contexto.Empleados.Where(e => e.FkRol == 2), "PkIdEmpleado", "NombreCompleto");
        }


        public IActionResult Detalles(int id)
        {
            var viaje = _contexto.ViajesProgramados
                .Include(v => v.FkRutaNavigation)
                .Include(v => v.FkAutobusNavigation)
                .Include(v => v.FkChoferNavigation)
                .FirstOrDefault(v => v.PkIdViaje == id);

            if (viaje == null) return RedirectToAction("Index");
            return View(viaje);
        }
    }
}