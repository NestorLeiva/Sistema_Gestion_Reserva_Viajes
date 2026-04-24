using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;

namespace SistemaViajes.Controllers
{
    public class EmpleadoController : Controller
    {
        private readonly AppDbContext _contexto;

        public EmpleadoController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        // LISTADO
        public async Task<IActionResult> Index()
        {
            var empleados = await _contexto.Empleados
                .Include(e => e.RolNavigation)
                .Include(e => e.UsuarioSistemas) // Ahora sí va a reconocer este nombre
                .ToListAsync();

            return View(empleados);
        }

        // CREAR (GET)
        public IActionResult Crear()
        {
            ViewBag.Roles = new SelectList(_contexto.RolEmpleados, "PkIdRol", "NombreRol");
            return View();
        }

        // CREAR 
        [HttpPost]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Empleado empleado, string NombreUsuario, string Clave)
        {
            if (ModelState.IsValid)
            {
                // 1. Guardamos el empleado primero para generar su ID
                _contexto.Add(empleado);
                await _contexto.SaveChangesAsync();

                // 2. Si el usuario llenó los campos de cuenta, creamos el registro en USUARIO_SISTEMA
                if (!string.IsNullOrEmpty(NombreUsuario) && !string.IsNullOrEmpty(Clave))
                {
                    var nuevoUsuario = new UsuarioSistema
                    {
                        NombreUsuario = NombreUsuario,
                        ClaveHash = Clave, // Texto plano para pruebas del CUC
                        FkEmpleado = empleado.PkIdEmpleado // Relacionamos con el empleado recién creado
                    };
                    _contexto.UsuarioSistemas.Add(nuevoUsuario);
                    await _contexto.SaveChangesAsync();
                }

                return RedirectToAction(nameof(Index));
            }
            ViewBag.Roles = new SelectList(_contexto.RolEmpleados, "PkIdRol", "NombreRol", empleado.FkRol);
            return View(empleado);
        }


        // GET: Empleado/Editar/5
        public async Task<IActionResult> Editar(int? id)
        {
            if (id == null) return NotFound();

            var empleado = await _contexto.Empleados.FindAsync(id);
            if (empleado == null) return NotFound();

            ViewBag.Roles = new SelectList(_contexto.RolEmpleados, "PkIdRol", "NombreRol", empleado.FkRol);
            return View(empleado);
        }

        // POST: Empleado/Editar/5

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(int id, Empleado empleado, string NombreUsuario, string Clave)
        {
            if (id != empleado.PkIdEmpleado) return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    // 1. Actualizamos los datos del empleado
                    _contexto.Update(empleado);

                    // 2. Manejo del Usuario de Sistema
                    var usuarioExistente = await _contexto.UsuarioSistemas
                        .FirstOrDefaultAsync(u => u.FkEmpleado == id);

                    if (!string.IsNullOrEmpty(NombreUsuario))
                    {
                        if (usuarioExistente != null)
                        {
                            // Actualizamos usuario existente
                            usuarioExistente.NombreUsuario = NombreUsuario;
                            if (!string.IsNullOrEmpty(Clave)) usuarioExistente.ClaveHash = Clave;
                            _contexto.Update(usuarioExistente);
                        }
                        else
                        {
                            // Creamos usuario nuevo para este empleado
                            var nuevoUsuario = new UsuarioSistema
                            {
                                NombreUsuario = NombreUsuario,
                                ClaveHash = Clave,
                                FkEmpleado = id
                            };
                            _contexto.UsuarioSistemas.Add(nuevoUsuario);
                        }
                    }

                    await _contexto.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_contexto.Empleados.Any(e => e.PkIdEmpleado == empleado.PkIdEmpleado)) return NotFound();
                    else throw;
                }
                return RedirectToAction(nameof(Index));
            }
            ViewBag.Roles = new SelectList(_contexto.RolEmpleados, "PkIdRol", "NombreRol", empleado.FkRol);
            return View(empleado);
        }
    }
}