using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    // Esta es la clase que controla todo lo relacionado con los Buses
    public class AutobusController : Controller
    {
        private readonly AppDbContext _contexto;

        // Aquí conectamos la base de datos
        public AutobusController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        // Este método es el que carga la página principal de buses
        public IActionResult Index()
        {
            // Traemos la lista de buses desde la tabla de la base de datos
            var listaBuses = _contexto.Autobuses.ToList();

            // Se la mandamos a la Vista (el HTML) para que la dibuje
            return View(listaBuses);
        }
    }
}