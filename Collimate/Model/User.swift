//
//  User.swift
//  CollimateAuth
//
//  Created by Heming Ma on 2/18/21.
//

import Foundation
import FirebaseFirestore

struct User {
    
    // memebers
    var email: String
    var name: String
    var chats: [String]
    var createdAt: Timestamp
    
    // used to create user instance if no record in the db
    public static func createUserInstance(_ email: String, _ name: String) -> User {
        return User(email: email, name: name, chats: [], createdAt: Timestamp.init())
    }

    
//    public func storeUserInstanceLocal() -> Bool {
//
//    }
//
//    public static func getUserInstanceLocal() -> User {
//
//    }
}

