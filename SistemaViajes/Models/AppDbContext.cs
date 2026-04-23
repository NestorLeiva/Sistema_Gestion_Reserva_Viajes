using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;

namespace SistemaViajes.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Empleado> Empleados { get; set; }
        public DbSet<RolEmpleado> RolesEmpleados { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Autobus> Autobuses { get; set; }
        // Lo dejamos como VIAJE para que coincida con tu controlador
        public DbSet<Viaje> VIAJE { get; set; }
        public DbSet<UsuarioSistema> UsuarioSistemas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // CONFIGURACIÓN DE EMPLEADO
            modelBuilder.Entity<Empleado>(entity =>
            {
                entity.ToTable("EMPLEADO");
                entity.HasKey(e => e.PkIdEmpleado);
                entity.Property(e => e.PkIdEmpleado).HasColumnName("PK_ID_EMPLEADO");
                entity.Property(e => e.NombreCompleto).HasColumnName("NOMBRE_COMPLETO");
                entity.Property(e => e.FkRol).HasColumnName("FK_ROL");
                entity.HasOne(d => d.RolNavigation).WithMany().HasForeignKey(d => d.FkRol);
            });

            // CONFIGURACIÓN DE ROL_EMPLEADO
            modelBuilder.Entity<RolEmpleado>(entity =>
            {
                entity.ToTable("ROL_EMPLEADO");
                entity.HasKey(e => e.PkIdRol);
                entity.Property(e => e.PkIdRol).HasColumnName("PK_ID_ROL");
                entity.Property(e => e.NombreRol).HasColumnName("NOMBRE_ROL");
            });

            // CONFIGURACIÓN DE CLIENTE
            modelBuilder.Entity<Cliente>(entity =>
            {
                entity.ToTable("CLIENTE");
                entity.HasKey(e => e.PkIdCliente);
                entity.Property(e => e.PkIdCliente).HasColumnName("PK_ID_CLIENTE");
                entity.Property(e => e.Cedula).HasColumnName("CEDULA");
                entity.Property(e => e.NombreCompleto).HasColumnName("NOMBRE_COMPLETO");
            });

            // CONFIGURACIÓN DE AUTOBUS
            modelBuilder.Entity<Autobus>(entity =>
            {
                entity.ToTable("AUTOBUS");
                entity.HasKey(e => e.PkIdAutobus);
                entity.Property(e => e.PkIdAutobus).HasColumnName("PK_ID_AUTOBUS");
                entity.Property(e => e.Placa).HasColumnName("PLACA");
            });

            // CONFIGURACIÓN DE VIAJE (SIN "dbo" PARA EVITAR EL ERROR)
            modelBuilder.Entity<Viaje>(entity =>
            {
                entity.ToTable("VIAJE"); // Sin esquema, directo como en el script
                entity.HasKey(e => e.PkIdViaje);
                entity.Property(e => e.PkIdViaje).HasColumnName("PK_ID_VIAJE");
                entity.Property(e => e.Destino).HasColumnName("DESTINO");
                entity.Property(e => e.FechaSalida).HasColumnName("FECHA_SALIDA");
                entity.Property(e => e.FkAutobus).HasColumnName("FK_AUTOBUS");
                entity.Property(e => e.FkChofer).HasColumnName("FK_CHOFER");
                entity.Property(e => e.Precio).HasColumnName("PRECIO");
            });

            // CONFIGURACIÓN DE USUARIO_SISTEMA
            modelBuilder.Entity<UsuarioSistema>(entity =>
            {
                entity.ToTable("USUARIO_SISTEMA");
                entity.HasKey(e => e.PkIdUsuario);
                entity.Property(e => e.PkIdUsuario).HasColumnName("PK_ID_USUARIO");
                entity.Property(e => e.NombreUsuario).HasColumnName("NOMBRE_USUARIO");
                entity.Property(e => e.ClaveHash).HasColumnName("CLAVE_HASH");
            });
        }
    }
}