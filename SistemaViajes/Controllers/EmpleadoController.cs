using Microsoft.AspNetCore.Mvc;
using SistemaViajes.Models;

public class EmpleadoController : Controller
{
    private readonly AppDbContext _context;
    public EmpleadoController(AppDbContext context) { _context = context; }

    public IActionResult Index() => View(_context.Empleados.ToList());

    public IActionResult Crear() => View();

    [HttpPost]
    public IActionResult Crear(Empleado empleado)
    {
        _context.Empleados.Add(empleado);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}