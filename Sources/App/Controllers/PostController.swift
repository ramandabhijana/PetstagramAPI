//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 21/06/21.
//

import Fluent
import Vapor

struct PostController: RouteCollection {
  var posts: [Post] = [
    Post(id: UUID(), caption: "Test Post1", createdAt: Date(), createdBy: "UserName"),
    Post(id: UUID(), caption: "Test Post2", createdAt: Date() - (60*60*4), createdBy: "Another User")
  ]
  
  func boot(routes: RoutesBuilder) throws {
    let postRoutes = routes.grouped("api", "v1", "posts")
    
    postRoutes.get(use: getPosts)
  }
  
  func getPosts(_ req: Request) -> EventLoopFuture<[Post]> {
    return req.eventLoop.future(posts)
  }
  
  
}
