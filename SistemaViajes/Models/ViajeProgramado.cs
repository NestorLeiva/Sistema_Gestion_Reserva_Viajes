using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("VIAJE_PROGRAMADO")]
    public partial class ViajeProgramado
    {
        [Key]
        [Column("PK_ID_VIAJE")]
        public int PkIdViaje { get; set; }

        [Column("FK_RUTA")]
        public int FkRuta { get; set; }

        [Column("FK_AUTOBUS")]
        public int FkAutobus { get; set; }

        [Column("FK_CHOFER")]
        public int FkChofer { get; set; }

        [Column("FK_FISCAL")]
        public int FkFiscal { get; set; }

        [Column("FECHA_SALIDA")]
        public DateTime FechaSalida { get; set; }

        [Column("TARIFA_BASE")]
        public decimal TarifaBase { get; set; }

        [Column("ESTADO_VIAJE")]
        public string EstadoViaje { get; set; } = "PROGRAMADO";

        // PROPIEDADES DE NAVEGACIÓN (Esto quita los errores de "Navigation")
        [ForeignKey("FkAutobus")]
        public virtual Autobus? FkAutobusNavigation { get; set; }

        [ForeignKey("FkChofer")]
        public virtual Empleado? FkChoferNavigation { get; set; }

        [ForeignKey("FkRuta")]
        public virtual Ruta? FkRutaNavigation { get; set; }
    }
}