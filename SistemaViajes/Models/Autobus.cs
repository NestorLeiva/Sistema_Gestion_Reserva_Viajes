using System;
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
        [Required]
        public string Placa { get; set; } = null!;

        [Column("CAPACIDAD_ASIENTOS")]
        public int CapacidadAsientos { get; set; }

        [Column("FK_TIPO_AUTOBUS")]
        public int FkTipoAutobus { get; set; }

        [Column("ESTADO_UNIDAD")]
        public string EstadoUnidad { get; set; } 

        [Column("ACTIVO")]
        public bool Activo { get; set; } = true;

        // ESTAS LÍNEAS SE VAN PORQUE NO ESTÁN EN EL SCRIPT
        // public DateTime? FechaVencDekra { get; set; }
        // public DateTime? FechaVencMarchamo { get; set; }
    }
}