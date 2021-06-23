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
    userRoutes.post(use: createUser)
    userRoutes.get(use: getUser)
  }
  
  func createUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication> {
    let user = try req.content.decode(UserAuthentication.self)
    return user.save(on: req.db).map {
      user.password = ""
      return user
    }
  }
  
  func getUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication> {
    let params = try req.query.decode(UserParams.self)
    return UserAuthentication.query(on: req.db)
      .filter(\.$id == params.id)
      .filter(\.$password == params.password)
      .first()
      .unwrap(or: Abort(.unauthorized))
  }
}

struct UserParams: Content {
  var id: String
  var password: String
}
