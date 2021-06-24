//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 21/06/21.
//

import Vapor
import Fluent

struct PostController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {
    let postRoutes = routes.grouped("api", "v1", "posts")
    let basicAuthMiddleware = UserAuthentication.authenticator()
    let guardAuthMiddleware = UserAuthentication.guardMiddleware()
    let basicAuthGroup = postRoutes.grouped(
      basicAuthMiddleware,
      guardAuthMiddleware
    )
    basicAuthGroup.post(use: createPost)
    basicAuthGroup.get(use: getPosts)
  }
  
  func getPosts(_ req: Request) throws -> EventLoopFuture<[Post]> {
    _ = try req.auth.require(UserAuthentication.self)
    return Post.query(on: req.db).all()
  }
  
  func createPost(_ req: Request) throws -> EventLoopFuture<Post> {
    let post = try req.content.decode(Post.self)
    let user = try req.auth.require(UserAuthentication.self)
    if post.createdByUser != user.username {
      throw Abort(.forbidden)
    }
    if post.id == nil {
      post.id = UUID()
    }
    return post.save(on: req.db).map { post }
  }
}
