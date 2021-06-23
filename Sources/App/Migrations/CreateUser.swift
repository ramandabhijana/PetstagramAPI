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
      .field("id", .string, .identifier(auto: false))
      .field("email", .string, .required)
      .field("password", .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").delete()
  }
}
