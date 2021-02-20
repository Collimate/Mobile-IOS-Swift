//
//  DatabaseManager.swift
//  CollimateAuth
//
//  Created by user190420 on 2/16/21.
//

import Foundation
import GoogleSignIn
import FirebaseFirestore

final class FirestoreManager: DatabaseManagerProtocal {
    

    // why using this? for safer transcation?
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    // User
    // get user instance
    public func getUser(identifier email: String, completion: @escaping( (User) -> Void )) {
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            
            if let userDocument = querySnapshot?.documents[0] {
                let user: User = User(
                    email: (userDocument.get("email") as? String) ?? "error",
                    name: (userDocument.get("name") as? String) ?? "error",
                    chats: (userDocument.get("chat") as? [String]) ?? [],
                    createdAt: (userDocument.get("createdAt") as? Date) ?? Date.init()
                )
                completion(user)
            }
        }
    }

    // insert user information into firestore
    public func createUser(with user: User) {
        db.collection("user").addDocument(data: [
            "email": user.email,
            "name": user.name,
            "createdAt": user.createdAt,
            "chat": user.chats
        ])
    }

    // check if there exist records where field "email" is equal to email,
    // if exist,return true
    public func doesUserExists(identifier email: String, completion: @escaping((Bool) -> Void)) {
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            let res = !(querySnapshot?.isEmpty ?? true)
            completion(res)
        }
    }
    
    // getAllChats(userID) -> [chat]
    func getUserChats(identifier email: String, completion: @escaping (([Chat]) -> Void)) {
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            let chats = (querySnapshot?.documents[0].get("chat") as? [String]) ?? []
            self.db.collection("chat").whereField("__name__", in: chats)
        }
    }
    
    func joinChat(identifier email: String, chatId: String, completion: @escaping( (Bool) -> Void )) {
        
    }
}
