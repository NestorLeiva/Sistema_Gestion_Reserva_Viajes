using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaViajes.Models
{
    [Table("RUTA")]
    public partial class Ruta
    {
        [Key]
        [Column("PK_ID_RUTA")]
        public int PkIdRuta { get; set; }

        [Column("NOMBRE_RUTA")]
        public string NombreRuta { get; set; } = null!;

        [Column("FK_CIUDAD_ORIGEN")]
        public int FkCiudadOrigen { get; set; }

        [Column("FK_CIUDAD_DESTINO")]
        public int FkCiudadDestino { get; set; }

        [Column("DURACION_ESTIMADA_MIN")]
        public int? DuracionEstimadaMin { get; set; }
    }
}