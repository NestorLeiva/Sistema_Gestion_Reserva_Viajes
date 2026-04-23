using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class ClienteController : Controller
    {
        private readonly AppDbContext _contexto;

        public ClienteController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        public IActionResult Index()
        {
            var lista = _contexto.Clientes.ToList();
            return View(lista);
        }

        [HttpGet]
        public IActionResult Crear()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Crear(Cliente cliente)
        {
            if (cliente != null)
            {
                // --- PARCHE PARA INTEGRIDAD DE BASE DE DATOS ---
                // Mandamos IDs que existan en tus tablas maestras para que SQL no de error
                cliente.FkProfesion = 1;
                cliente.FkRango = 1;

                _contexto.Clientes.Add(cliente);
                _contexto.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(cliente);
        }

        [HttpGet]
        public IActionResult Editar(int id)
        {
            var cliente = _contexto.Clientes.Find(id);
            if (cliente == null) return NotFound();
            return View(cliente);
        }

        [HttpPost]
        public IActionResult Editar(Cliente cliente)
        {
            if (cliente != null)
            {
                // Mantenemos los valores obligatorios para el Update también
                cliente.FkProfesion = 1;
                cliente.FkRango = 1;

                _contexto.Clientes.Update(cliente);
                _contexto.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(cliente);
        }

        public IActionResult Eliminar(int id)
        {
            var cliente = _contexto.Clientes.Find(id);
            if (cliente != null)
            {
                _contexto.Clientes.Remove(cliente);
                _contexto.SaveChanges();
            }
            return RedirectToAction("Index");
        }
    }
}