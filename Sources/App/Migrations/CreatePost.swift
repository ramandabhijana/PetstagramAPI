//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 23/06/21.
//

import Fluent

struct CreatePost: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("posts")
      .id()
      .field("caption", .string, .required)
      .field("created_at", .date, .required)
      .field("created_by", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("posts").delete()
  }
}
