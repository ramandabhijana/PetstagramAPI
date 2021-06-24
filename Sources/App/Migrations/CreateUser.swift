//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 23/06/21.
//

import Fluent

struct CreateUser: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users")
      .id()
      .field("username", .string, .required)
      .field("email", .string, .required)
      .field("password", .string, .required)
      .unique(on: "username")
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").delete()
  }
}
