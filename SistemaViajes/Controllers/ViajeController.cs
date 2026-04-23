using Microsoft.AspNetCore.Mvc;
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

        public IActionResult Index()
        {
            // Usamos .VIAJE que es como se llama el DbSet en el AppDbContext
            var listaViajes = _contexto.VIAJE.ToList();
            return View(listaViajes);
        }
    }
}