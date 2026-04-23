using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("ROL_EMPLEADO")]
    public class RolEmpleado
    {
        [Key]
        [Column("PK_ID_ROL")]
        public int PkIdRol { get; set; }

        [Column("NOMBRE_ROL")]
        public string NombreRol { get; set; } = null!;
    }
}