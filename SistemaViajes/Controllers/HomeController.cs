using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _contexto;

        public HomeController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        public IActionResult Index()
        {
            // 1. Cargamos los buses en mantenimiento
            var busesEnTaller = _contexto.Autobuses
                .Where(b => b.EstadoUnidad == "EN_MANTENIMIENTO")
                .ToList();

            // 2. Usamos el nombre EXACTO que vimos en tu AppDbContext
            //ViewBag.TotalViajes = _contexto.VIAJE.Count(); // 
            ViewBag.TotalClientes = _contexto.Clientes.Count();

            return View(busesEnTaller);
        }
    }
}
