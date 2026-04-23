using Microsoft.EntityFrameworkCore;
using SistemaViajes.Models;

var builder = WebApplication.CreateBuilder(args);

// CONEXIÓN
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("CadenaViajes")));

builder.Services.AddControllersWithViews();
builder.Services.AddSession(); // Necesario para el login

var app = builder.Build();

app.UseSession();
app.UseStaticFiles();
app.UseRouting();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Acceso}/{action=Login}/{id?}");

app.Run();