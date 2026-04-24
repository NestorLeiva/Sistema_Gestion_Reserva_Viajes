using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("FACTURA")]
    public class Factura
    {
        [Key]
        [Column("PK_ID_FACTURA")]
        public int PkIdFactura { get; set; }
        [Column("NUMERO_FACTURA")]
        public string NumeroFactura { get; set; } = null!;
        [Column("FK_RESERVACION")]
        public int FkReservacion { get; set; }
        [Column("FK_METODO_PAGO")]
        public int FkMetodoPago { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Impuestos { get; set; }
        [Column("MONTO_TOTAL")]
        public decimal MontoTotal { get; set; }
        [Column("FECHA_FACTURA")]
        public DateTime FechaFactura { get; set; }

        [ForeignKey("FkReservacion")]
        public virtual Reservacion FkReservacionNavigation { get; set; } = null!;
    }
}