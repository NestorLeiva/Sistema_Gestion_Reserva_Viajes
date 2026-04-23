using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("MANTENIMIENTO_AUTOBUS")]
public class Mantenimiento
{
    [Key]
    [Column("PK_ID_MANTENIMIENTO")]
    public int PkIdMantenimiento { get; set; }

    [Column("FK_AUTOBUS")]
    public int FkAutobus { get; set; }

    [Column("FECHA_INICIO")]
    public DateTime FechaInicio { get; set; }

    [Column("FECHA_FIN")]
    public DateTime? FechaFin { get; set; } // Puede ser null si sigue en el taller
}