/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Fluent
import Vapor

final class UserAuthentication: Model {
  
  static var schema: String = "users"
  
  init() {}
  
  init(username: String,
       email: String,
       password: String) {
    self.username = username
    self.email = email
    self.password = password
  }
  
  @ID
  var id: UUID?
  
  @Field(key: "username")
  var username: String
  
  @Field(key: "email")
  var email: String
  
  @Field(key: "password")
  var password: String
  
  final class Public: Content {
    var username: String
    var email: String

    init(username: String, email: String) {
      self.username = username
      self.email = email
    }
  }
  
}

extension UserAuthentication: Content { }

extension UserAuthentication: ModelAuthenticatable {
  static let usernameKey = \UserAuthentication.$username
  static let passwordHashKey = \UserAuthentication.$password
  
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}

extension UserAuthentication {
  func convertToPublic() -> UserAuthentication.Public {
    
    return UserAuthentication.Public(username: username,
                                     email: email)
  }
}


extension EventLoopFuture where Value: UserAuthentication {
  func convertToPublic() -> EventLoopFuture<UserAuthentication.Public> {
    return self.map { user in
      return user.convertToPublic()
    }
  }
}


extension Collection where Element: UserAuthentication {
  func convertToPublic() -> [UserAuthentication.Public] {
    return self.map { $0.convertToPublic() }
  }
}

extension EventLoopFuture where Value == Array<UserAuthentication> {
  func convertToPublic() -> EventLoopFuture<[UserAuthentication.Public]> {
    return self.map { $0.convertToPublic() }
  }
}

