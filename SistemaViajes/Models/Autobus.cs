using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("AUTOBUS")]
    public class Autobus
    {
        [Key]
        [Column("PK_ID_AUTOBUS")]
        public int PkIdAutobus { get; set; }

        [Column("PLACA")]
        public string Placa { get; set; } = null!;

        [Column("CAPACIDAD_ASIENTOS")]
        public int CapacidadAsientos { get; set; }
    }
}