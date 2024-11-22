//
//  User.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI
import ParseSwift

//create a custom ParseUser object
struct User: ParseUser {
    //required by ParseObject
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    //required by ParseUser
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    //custom properties
    var firstName: String?
    var lastName: String?
    
    //required by ParseObject
    static var className: String { // swiftlint:disable:this implicit_getter
        "_User"
    }
}

//custom init 
extension User {
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}
