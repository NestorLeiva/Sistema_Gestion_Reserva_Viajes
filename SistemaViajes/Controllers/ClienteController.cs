using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class ClienteController : Controller
    {
        private readonly AppDbContext _contexto;
        public ClienteController(AppDbContext contexto) { _contexto = contexto; }

        public IActionResult Index()
        {
            var clientes = _contexto.Clientes.ToList();
            return View(clientes);
        }
    }
}