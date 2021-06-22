//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 21/06/21.
//

import Vapor

var users: [UserAuthentication] = []

struct UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let userRoutes = routes.grouped("api", "v1", "user")
    
    userRoutes.post(use: createUser)
    userRoutes.get(use: getUser)
  }
  
  func createUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication> {
    let user = try req.content.decode(UserAuthentication.self)
    users.append(user)
    return req.eventLoop.future(user)
  }
  
  func getUser(_ req: Request) throws -> EventLoopFuture<UserAuthentication> {
    let params = try req.query.decode(UserParams.self)
    guard let foundUser = users.first(where: { $0.id ==  params.id}),
          foundUser.password == params.password else {
      throw Abort(.unauthorized)
    }
    return req.eventLoop.future(foundUser)
  }
}

struct UserParams: Content {
  var id: String
  var password: String
}
