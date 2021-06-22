import Fluent
import Vapor

func routes(_ app: Application) throws {
  
  try app.register(collection: PostController())
  try app.register(collection: UserController())
}
