using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;
using System;
using System.Linq;

namespace SistemaViajes.Controllers
{
    public class VentaController : Controller
    {
        private readonly AppDbContext _contexto;

        public VentaController(AppDbContext contexto)
        {
            _contexto = contexto;
        }

        // GET: Muestra el formulario de venta
        [HttpGet]
        public IActionResult Vender(int id)
        {
            var viaje = _contexto.ViajesProgramados
                .Include(v => v.FkRutaNavigation)
                .FirstOrDefault(v => v.PkIdViaje == id);

            if (viaje == null) return RedirectToAction("Index", "Viaje");

            // Cargar datos para los selectores
            ViewBag.Clientes = new SelectList(_contexto.Clientes, "PkIdCliente", "NombreCompleto");
            ViewBag.Metodos = new SelectList(_contexto.MetodosPago, "PkIdMetodo", "NombreMetodo");

            return View(viaje);
        }

        // POST: Procesa la base de datos
        [HttpPost]
        public IActionResult ProcesarVenta(int idViaje, int idCliente, int cantidad, int idMetodoPago)
        {
            try
            {
                // 1. Crear Reservación
                var nuevaReserva = new Reservacion
                {
                    FkCliente = idCliente,
                    FkViaje = idViaje,
                    FkAdministrativo = 2, // Ana Méndez
                    CantidadAsientos = cantidad,
                    EstadoReserva = "CONFIRMADA",
                    FechaReserva = DateTime.Now
                };

                _contexto.Reservaciones.Add(nuevaReserva);
                _contexto.SaveChanges();

                // 2. Calcular montos
                var viaje = _contexto.ViajesProgramados.Find(idViaje);
                decimal subtotal = (viaje?.TarifaBase ?? 0) * cantidad;
                decimal impuestos = subtotal * 0.13m;

                // 3. Crear Factura
                var nuevaFactura = new Factura
                {
                    NumeroFactura = "FAC-" + Guid.NewGuid().ToString().Substring(0, 8).ToUpper(),
                    FkReservacion = nuevaReserva.PkIdReservacion,
                    FkMetodoPago = idMetodoPago,
                    Subtotal = subtotal,
                    Impuestos = impuestos,
                    MontoTotal = subtotal + impuestos,
                    FechaFactura = DateTime.Now
                };

                _contexto.Facturas.Add(nuevaFactura);
                _contexto.SaveChanges();

                return RedirectToAction("Confirmacion", new { id = nuevaFactura.PkIdFactura });
            }
            catch (Exception ex)
            {
                return BadRequest("Error crítico: " + ex.Message);
            }
        }

        // GET: Muestra el resultado final
        public IActionResult Confirmacion(int id)
        {
            var factura = _contexto.Facturas
                .Include(f => f.FkReservacionNavigation)
                    .ThenInclude(r => r.FkViajeNavigation)
                        .ThenInclude(v => v.FkRutaNavigation)
                .Include(f => f.FkReservacionNavigation)
                    .ThenInclude(r => r.FkClienteNavigation)
                .FirstOrDefault(f => f.PkIdFactura == id);

            if (factura == null) return RedirectToAction("Index", "Viaje");

            return View(factura);
        }
    }
}