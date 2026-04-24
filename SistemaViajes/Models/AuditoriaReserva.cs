using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("AUDITORIA_RESERVAS")] // Esto le dice a EF que la tabla en SQL se llama así
    public class AuditoriaReserva
    {
        [Key]
        [Column("PK_ID_AUDITORIA")]
        public int PkIdAuditoria { get; set; }

        [Column("FECHA_ACCION")]
        public DateTime FechaAccion { get; set; }

        [Column("USUARIO")]
        public string Usuario { get; set; }

        [Column("ACCION")]
        public string Accion { get; set; }

        [Column("DETALLE_ADICIONAL")]
        public string DetalleAdicional { get; set; }

        [Column("FK_ID_AFECTADO")]
        public int? FkIdAfectado { get; set; }
    }
}