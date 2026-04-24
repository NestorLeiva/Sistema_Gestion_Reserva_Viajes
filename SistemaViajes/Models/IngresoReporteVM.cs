using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    public class IngresoReporteVM
    {
        // Estos nombres deben coincidir EXACTAMENTE con lo que devuelve el SP en el SELECT
        public decimal TotalFacturado { get; set; }
        public int CantidadViajes { get; set; }
        public decimal PromedioPorViaje { get; set; }

        // Agregá este atributo [NotMapped] a ambas fechas:
        [NotMapped]
        public DateTime FechaInicio { get; set; }

        [NotMapped]
        public DateTime FechaFin { get; set; }
    }
}