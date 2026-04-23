using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("CLIENTE")]
    public class Cliente
    {
        [Key]
        [Column("PK_ID_CLIENTE")]
        public int PkIdCliente { get; set; }

        [Column("CEDULA")]
        public string Cedula { get; set; } = null!;

        [Column("NOMBRE_COMPLETO")]
        public string NombreCompleto { get; set; } = null!;

        [Column("TELEFONO")] // Si no lo tenés en SQL, borrá esta línea y la de la vista
        public string? Telefono { get; set; }

        [Column("CORREO")] // Si no lo tenés en SQL, borrá esta línea y la de la vista
        public string? Correo { get; set; }

        [Column("FK_PROFESION")]
        public int FkProfesion { get; set; }


        [Column("FK_RANGO")]
        public int FkRango { get; set; }
    }
}