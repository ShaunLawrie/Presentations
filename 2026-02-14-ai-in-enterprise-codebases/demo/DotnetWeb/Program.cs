using DotnetLibrary;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Configure DotnetLibrary
if (builder.Environment.IsDevelopment())
{
    var dbPath = Path.Combine(builder.Environment.ContentRootPath, "Data", "enterprise");
    Directory.CreateDirectory(Path.GetDirectoryName(dbPath)!);
    builder.Services.AddDotnetLibrary(dbPath);
}
else
{
    string sqlConnectionString = "Server=(localdb)\\mssqllocaldb;Database=SampleDb;Trusted_Connection=True;";
    builder.Services.AddRealDatabase(sqlConnectionString);
}

var app = builder.Build();

// Initialize the database
await app.Services.InitializeDotnetLibraryAsync();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

// API routes
app.MapControllerRoute(
    name: "api",
    pattern: "api/{controller}/{action=Index}/{id?}");

// Default SPA fallback
app.MapFallbackToFile("index.html");

app.Run();
