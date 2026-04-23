using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class ViajeController : Controller
    {
        private readonly AppDbContext _contexto;
        public ViajeController(AppDbContext contexto) { _contexto = contexto; }

        public IActionResult Index()
        {
            var listaViajes = _contexto.Viajes.ToList();
            return View(listaViajes);
        }
    }
}