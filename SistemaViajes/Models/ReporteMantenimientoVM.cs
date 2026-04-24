namespace SistemaViajes.Models
{
    public class ReporteMantenimientoVM
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; } // O DateTime? si la fecha puede ser nula
        public string? Usuario { get; set; } // El ? permite nulos
        public string? Accion { get; set; }
        public string? Detalle { get; set; }
        public string? TipoReparacion { get; set; } // Este suele ser el que viene nulo
        public string? NombreMes { get; set; }
        public int NumeroMes { get; set; }
    }
}