using SistemaViajes.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("USUARIO_SISTEMA")]
public class UsuarioSistema
{
    [Key]
    [Column("PK_ID_USUARIO")]
    public int PkIdUsuario { get; set; }

    [Column("NOMBRE_USUARIO")]
    public string NombreUsuario { get; set; } = null!;

    [Column("CLAVE_HASH")]
    public string ClaveHash { get; set; } = null!;

    [Column("FK_EMPLEADO")] // El nombre real en tu SQL
    public int FkEmpleado { get; set; }

    // Aquí está el truco: le decimos que use FkEmpleado para la relación
    [ForeignKey("FkEmpleado")]
    public virtual Empleado? EmpleadoNavigation { get; set; }
}