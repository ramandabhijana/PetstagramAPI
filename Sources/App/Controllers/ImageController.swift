//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 22/06/21.
//

import Foundation
import Vapor

struct ImageController: RouteCollection {
  let imageFolder = "PostPictures/"
  
  func boot(routes: RoutesBuilder) throws {
    let imageRoutes = routes.grouped("api", "v1", "images")
    imageRoutes.post(use: addPostImagePostHandler)
    imageRoutes.get(use: getPostImageHandler)
  }
  
  func addPostImagePostHandler(_ req: Request) throws -> EventLoopFuture<Response> {
    guard
      req.headers["Content-Type"].contains("image/jpeg"),
      let buffer = req.body.data,
      let fileName = req.headers.first(name: "Slug") else {
      throw Abort(.preconditionFailed, reason: "Filename not specified")
    }
    let path = req.application.directory.workingDirectory + imageFolder + fileName
    return req.fileio
      .writeFile(buffer, at: path)
      .flatMap {
        req.eventLoop.future(Response(status: .created))
      }
  }
  
  func getPostImageHandler(_ req: Request) throws -> EventLoopFuture<ImageUploadData> {
    let params = try req.query.decode(PostImageParams.self)
    let path = req.application.directory.workingDirectory + imageFolder + params.fileName
    return req.fileio
      .collectFile(at: path)
      .map { ImageUploadData(picture: .init(buffer: $0)) }
  }
}

struct ImageUploadData: Content {
  var picture: Data
  
  init(picture: Data) {
    self.picture = picture
  }
}

struct PostImageParams: Content {
  let fileName: String
}
