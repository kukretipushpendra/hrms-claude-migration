/*
 * HRMS (Human Resource Management System) API
 * Entry point for the application that configures services and middleware
 * Version: 1.0
 */

using HRMS.API.Extensions;
using HRMS.Domain;
using HRMS.Domain.Exceptions;
using HRMS.Models.Models.Auth;

// Create the application builder instance
var builder = WebApplication.CreateBuilder(args);

// Load and validate application settings
var configuration = builder.Configuration.Get<AppSettings>()
    ?? throw ProgramException.AppsettingNotSetException();
    
// Register configuration as singleton for dependency injection
builder.Services.AddSingleton(configuration); 

// Configure rate limiting options from appsettings
builder.Services.Configure<RateLimitingOptions>(
    builder.Configuration.GetSection("RateLimiting"));

// Add memory cache service
builder.Services.AddMemoryCache();

// Configure services and middleware pipeline
var app = await builder.ConfigureServices(configuration).ConfigurePipelineAsync(configuration);

// Start the application
await app.RunAsync();
