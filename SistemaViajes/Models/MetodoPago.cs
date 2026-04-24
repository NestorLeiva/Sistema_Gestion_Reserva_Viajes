using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("METODO_PAGO")]
    public class MetodoPago
    {
        [Key]
        [Column("PK_ID_METODO")]
        public int PkIdMetodo { get; set; }

        [Column("NOMBRE_METODO")]
        [Required]
        public string NombreMetodo { get; set; } = null!;
    }
}