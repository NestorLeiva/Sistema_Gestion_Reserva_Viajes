using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("VIAJE_PROGRAMADO")]
public class ViajeProgramado
{
    [Key]
    [Column("PK_ID_VIAJE")]
    public int PkIdViaje { get; set; }

    [Column("FK_AUTOBUS")]
    public int FkAutobus { get; set; }

    [Column("ESTADO_VIAJE")]
    public string EstadoViaje { get; set; } = null!; // Ejemplo: "PROGRAMADO"
}