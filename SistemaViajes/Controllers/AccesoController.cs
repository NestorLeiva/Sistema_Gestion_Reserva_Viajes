using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;

namespace SistemaViajes.Controllers
{
    public class AccesoController : Controller
    {
        private readonly AppDbContext _context;
        public AccesoController(AppDbContext context) { _context = context; }

        public IActionResult Login() => View();

        [HttpPost]
        public IActionResult Login(string usuario, string clave)
        {
            var user = _context.UsuarioSistemas
                .FirstOrDefault(u => u.NombreUsuario == usuario && u.ClaveHash == clave);

            if (user != null)
            {
                HttpContext.Session.SetString("User", user.NombreUsuario);
                return RedirectToAction("Index", "Home");
            }
            ViewBag.Error = "Usuario o clave incorrectos";
            return View();
        }


        public IActionResult Salir()
        {
            // Limpiamos la sesión para que el usuario salga del sistema
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Acceso");
        }



    }
}