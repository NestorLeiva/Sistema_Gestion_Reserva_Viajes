using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("USUARIO_SISTEMA")] // El nombre de tu tabla en SQL
    public class UsuarioSistema
    {
        [Key]
        [Column("PK_ID_USUARIO")]
        public int PkIdUsuario { get; set; }

        [Column("NOMBRE_USUARIO")]
        public string NombreUsuario { get; set; } = null!;

        [Column("CLAVE_HASH")]
        public string ClaveHash { get; set; } = null!;
    }
}