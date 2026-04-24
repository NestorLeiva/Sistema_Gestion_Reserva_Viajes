using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore; // IMPORTANTE: Necesario para el .Include()
using SistemaViajes.Models;

namespace SistemaViajes.Controllers
{
    public class AccesoController : Controller
    {
        private readonly AppDbContext _context;
        public AccesoController(AppDbContext context) { _context = context; }

        public IActionResult Login() => View();

        [HttpPost]
        public async Task<IActionResult> Login(string usuario, string clave)
        {
            // Buscamos el usuario e incluimos la información del empleado asociado
            var user = await _context.UsuarioSistemas
                .Include(u => u.EmpleadoNavigation)
                .FirstOrDefaultAsync(u => u.NombreUsuario == usuario && u.ClaveHash == clave);

            if (user != null)
            {
                // VALIDACIÓN DE ESTADO ACTIVO
                // Si el empleado existe y su estado es 'false' (Inactivo), bloqueamos el acceso
                if (user.EmpleadoNavigation != null && !user.EmpleadoNavigation.Activo)
                {
                    ViewBag.Error = "Su cuenta está inactiva. Por favor, contacte al administrador.";
                    return View();
                }

                // Si está activo, procedemos con la sesión
                HttpContext.Session.SetString("User", user.NombreUsuario);
                return RedirectToAction("Index", "Home");
            }

            ViewBag.Error = "Usuario o clave incorrectos";
            return View();
        }

        public IActionResult Salir()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Acceso");
        }
    }
}