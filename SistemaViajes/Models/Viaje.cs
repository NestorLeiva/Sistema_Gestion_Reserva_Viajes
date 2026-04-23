using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    public class Viaje
    {
        [Key]
        public int PkIdViaje { get; set; }
        public string Destino { get; set; } = null!;
        public DateTime FechaSalida { get; set; }
        public int FkAutobus { get; set; }
        public int FkChofer { get; set; }
        public decimal? Precio { get; set; }
    }
}