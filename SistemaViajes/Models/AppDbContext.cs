using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace SistemaViajes.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<UsuarioSistema> UsuarioSistemas { get; set; }
        public DbSet<Empleado> Empleados { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Autobus> Autobuses { get; set; }
        public DbSet<Viaje> Viajes { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UsuarioSistema>(entity => {
                entity.HasKey(e => e.PkIdUsuario);
                entity.ToTable("USUARIO_SISTEMA");
                entity.Property(e => e.PkIdUsuario).HasColumnName("PK_ID_USUARIO");
                entity.Property(e => e.NombreUsuario).HasColumnName("NOMBRE_USUARIO");
                entity.Property(e => e.ClaveHash).HasColumnName("CLAVE_HASH");
                entity.Property(e => e.FkEmpleado).HasColumnName("FK_EMPLEADO");
            });

            modelBuilder.Entity<Empleado>(entity => {
                entity.HasKey(e => e.PkIdEmpleado);
                entity.ToTable("EMPLEADO");
                entity.Property(e => e.PkIdEmpleado).HasColumnName("PK_ID_EMPLEADO");
                entity.Property(e => e.NombreCompleto).HasColumnName("NOMBRE_COMPLETO");
            });

            modelBuilder.Entity<Cliente>(entity => {
                entity.HasKey(e => e.PkIdCliente);
                entity.ToTable("CLIENTE");
                entity.Property(e => e.PkIdCliente).HasColumnName("PK_ID_CLIENTE");
                entity.Property(e => e.Cedula).HasColumnName("CEDULA");
                entity.Property(e => e.NombreCompleto).HasColumnName("NOMBRE_COMPLETO");
                entity.Property(e => e.Telefono).HasColumnName("TELEFONO");
                entity.Property(e => e.Correo).HasColumnName("CORREO");
            });

            modelBuilder.Entity<Autobus>(entity => {
                entity.HasKey(e => e.PkIdAutobus);
                entity.ToTable("AUTOBUS");
                entity.Property(e => e.PkIdAutobus).HasColumnName("PK_ID_AUTOBUS");
                entity.Property(e => e.Placa).HasColumnName("PLACA");
                entity.Property(e => e.CapacidadAsientos).HasColumnName("CAPACIDAD_ASIENTOS");
                entity.Property(e => e.FkTipoAutobus).HasColumnName("FK_TIPO_AUTOBUS");
            });

            modelBuilder.Entity<Viaje>(entity => {
                entity.HasKey(e => e.PkIdViaje);
                entity.ToTable("VIAJE_PROGRAMADO"); // <-- Esto le dice a C# el nombre real de la tabla
                entity.Property(e => e.PkIdViaje).HasColumnName("PK_ID_VIAJE");
                entity.Property(e => e.FechaSalida).HasColumnName("FECHA_SALIDA");
                entity.Property(e => e.Precio).HasColumnName("TARIFA_BASE");
            });


        }
    }

    public class UsuarioSistema
    {
        public int PkIdUsuario { get; set; }
        public string NombreUsuario { get; set; } = null!;
        public string ClaveHash { get; set; } = null!;
        public int FkEmpleado { get; set; }
    }

    public class Empleado
    {
        public int PkIdEmpleado { get; set; }
        public string NombreCompleto { get; set; } = null!;
    }

    public class Cliente
    {
        public int PkIdCliente { get; set; }
        public string Cedula { get; set; } = null!;
        public string NombreCompleto { get; set; } = null!;
        public string? Telefono { get; set; }
        public string? Correo { get; set; }
    }

    public class Autobus
    {
        [Key]
        public int PkIdAutobus { get; set; }
        public string Placa { get; set; } = null!;
        public int CapacidadAsientos { get; set; }
        public int FkTipoAutobus { get; set; }
    }


    public class Viaje
    {
        [Key]
        public int PkIdViaje { get; set; }
        
        public DateTime FechaSalida { get; set; }
        public decimal Precio { get; set; } // Este se mapea a TARIFA_BASE arriba
    }




}