import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
  // uncomment to serve files from /Public folder
  app.routes.defaultMaxBodySize = "10mb"
  
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
  app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? "vapor_database"
  ), as: .psql)
  
  app.http.server.configuration.hostname = "10.10.255.228"
  app.http.server.configuration.port = 8080
  
  // register routes
  try routes(app)
}
