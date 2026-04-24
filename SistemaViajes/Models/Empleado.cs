using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("EMPLEADO")] // Define el nombre exacto de la tabla en tu SQL
    public class Empleado
    {
        [Key]
        [Column("PK_ID_EMPLEADO")]
        public int PkIdEmpleado { get; set; }

        [Required]
        [Column("CEDULA")]
        public string Cedula { get; set; } = null!;

        [Required]
        [Column("NOMBRE_COMPLETO")]
        public string NombreCompleto { get; set; } = null!;

        [Column("FK_ROL")]
        public int FkRol { get; set; }

        [Column("ACTIVO")]
        public bool Activo { get; set; }

        // Propiedad de navegación para jalar el nombre del puesto (ROL)
        [ForeignKey("FkRol")]
        public virtual RolEmpleado? RolNavigation { get; set; }

        // Propiedad para conectar con la tabla de Usuarios
        public virtual ICollection<UsuarioSistema> UsuarioSistemas { get; set; } = new List<UsuarioSistema>();
    }
}