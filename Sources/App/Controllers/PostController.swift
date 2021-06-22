//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 21/06/21.
//

import Vapor

var posts: [Post] = [
  Post(id: UUID(), caption: "Test Post1", createdAt: Date(), createdBy: "UserName"),
  Post(id: UUID(), caption: "Test Post2", createdAt: Date() - (60*60*4), createdBy: "Another User")
]

struct PostController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {
    let postRoutes = routes.grouped("api", "v1", "posts")
    
    postRoutes.get(use: getPosts)
    postRoutes.post(use: createPost)
  }
  
  func getPosts(_ req: Request) -> EventLoopFuture<[Post]> {
    return req.eventLoop.future(posts)
  }
  
  func createPost(_ req: Request) throws -> EventLoopFuture<Post> {
    var post = try req.content.decode(Post.self)
    if post.id == nil {
      post.id = UUID()
    }
    posts.append(post)
    print("Posts: \(posts)")
    return req.eventLoop.future(post)
  }
}
