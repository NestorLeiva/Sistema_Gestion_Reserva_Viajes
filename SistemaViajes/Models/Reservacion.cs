using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("RESERVACION")]
    public class Reservacion
    {
        [Key]
        [Column("PK_ID_RESERVACION")]
        public int PkIdReservacion { get; set; }

        [Column("FK_CLIENTE")]
        public int FkCliente { get; set; }

        [Column("FK_VIAJE")]
        public int FkViaje { get; set; }

        [Column("FK_ADMINISTRATIVO")]
        public int FkAdministrativo { get; set; }

        [Column("CANTIDAD_ASIENTOS")]
        public int CantidadAsientos { get; set; }

        [Column("ESTADO_RESERVA")]
        public string EstadoReserva { get; set; } = "CONFIRMADA";

        [Column("FECHA_RESERVA")]
        public DateTime FechaReserva { get; set; }

        // PROPIEDADES DE NAVEGACIÓN (Esto es lo que quita tus errores)

        [ForeignKey("FkCliente")]
        public virtual Cliente FkClienteNavigation { get; set; } = null!;

        [ForeignKey("FkViaje")]
        public virtual ViajeProgramado FkViajeNavigation { get; set; } = null!;
    }
}