//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 21/06/21.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let userRoutes = routes.grouped("api", "v1", "user")
    let basicAuthMiddleware = UserAuthentication.authenticator()
    let guardAuthMiddleware = UserAuthentication.guardMiddleware()
    let protected = userRoutes.grouped(
      basicAuthMiddleware,
      guardAuthMiddleware
    )
    protected.get(use: getUser)
    
    userRoutes.post(use: createUser)
  }
  
  func createUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication.Public> {
    let user = try req.content.decode(UserAuthentication.self)
    user.password = try Bcrypt.hash(user.password)
    return user.save(on: req.db).map { user.convertToPublic() }
  }
  
  func getUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication.Public> {
    let user = try req.auth.require(UserAuthentication.self)
    return UserAuthentication.query(on: req.db)
      .filter(\.$username == user.username)
      .first()
      .map { $0?.convertToPublic() }
      .unwrap(or: Abort(.unauthorized))
  }
}
