//
//  GameVaultUser.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation
import ParseSwift

struct GameVaultUser: ParseUser {
    //required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    //required by ParseUser
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    var firstName: String?
    var lastName: String?

    //required by ParseObject
    init() { }
}

extension GameVaultUser {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        emailVerified = try container.decodeIfPresent(Bool.self, forKey: .emailVerified)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        authData = try container.decodeIfPresent([String: [String: String]?].self, forKey: .authData)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
    }
}

extension GameVaultUser: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(ACL, forKey: .ACL)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(emailVerified, forKey: .emailVerified)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(authData, forKey: .authData)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
    }
}

extension GameVaultUser: Equatable {
    static func == (lhs: GameVaultUser, rhs: GameVaultUser) -> Bool {
        return lhs.objectId == rhs.objectId &&
               lhs.username == rhs.username &&
               lhs.email == rhs.email &&
               lhs.emailVerified == rhs.emailVerified &&
               lhs.createdAt == rhs.createdAt &&
               lhs.updatedAt == rhs.updatedAt &&
               lhs.firstName == rhs.firstName &&
               lhs.lastName == rhs.lastName
    }
}

extension GameVaultUser {
    enum CodingKeys: String, CodingKey {
        case objectId
        case createdAt
        case updatedAt
        case ACL
        case originalData
        case username
        case email
        case emailVerified
        case password
        case authData
        case firstName
        case lastName
    }
}
