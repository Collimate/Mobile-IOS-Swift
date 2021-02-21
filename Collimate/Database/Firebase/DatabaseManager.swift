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

    private let db = Firestore.firestore()

    // User
    // get user instance
    func getUser(identifier email: String, completion: @escaping( (User?) -> Void )) {
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            
            if let userDocument = querySnapshot?.documents[0] {
                let user: User = User(
                    email: (userDocument.get("email") as? String) ?? "error",
                    name: (userDocument.get("name") as? String) ?? "error",
                    chats: (userDocument.get("chats") as? [String]) ?? [],
                    createdAt: (userDocument.get("createdAt") as? Date) ?? Date.init()
                )
                completion(user)
            } else {
                completion(nil)
            }
        }
    }

    // insert user information into firestore
    func createUser(with user: User) {
        db.collection("user").document(user.email).setData([
            "email": user.email,
            "name": user.name,
            "createdAt": user.createdAt,
            "chats": user.chats
        ])
    }

    // check if there exist records where field "email" is equal to email,
    // if exist,return true
    func doesUserExists(identifier email: String, completion: @escaping ((Bool?) -> Void)) {
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            let res = !(querySnapshot?.isEmpty ?? true)
            completion(res)
        }
    }
    
    // getAllChats(userID) -> [chat]
    func getUserChats(identifier email: String, completion: @escaping (([Chat]?) -> Void)) {
        // find all chat ids from users then find all chat objects
        db.collection("user").whereField("email", isEqualTo: email).getDocuments() {
            (querySnapshot, err) in
            let chats = (querySnapshot?.documents[0].get("chats") as? [String]) ?? []
            self.db.collection("chat").whereField("__name__", in: chats).getDocuments {
                querySnapshot, err in
                if err != nil {
                    completion(nil)
                }
                completion(
                    querySnapshot?.documents.map({ (queryDocumentSnapshot) -> Chat in
                        return Chat(
                            users: (queryDocumentSnapshot.get("users") as? [String]) ?? [],
                            name: (queryDocumentSnapshot.get("name") as? String) ?? "",
                            quarter: (queryDocumentSnapshot.get("quarter") as? String) ?? "",
                            messages: (queryDocumentSnapshot.get("messages") as? [String]) ?? []
                        )
                    })
                )
            }
        }
    }
    
    // let user join in
    func joinChat(identifier email: String, chatId: String, completion: @escaping( (Bool) -> Void )) {
        // add chat id in user
        // TODO: test if this func has return value
        db.collection("user").document(email).updateData([
            "chats": FieldValue.arrayUnion([chatId])
        ])
        // add user id in chat
        // TODO: test if this func has return value
        db.collection("chat").document(chatId).updateData([
            "users": FieldValue.arrayUnion([email])
        ])
        
        // TODO: add completion
    }
    
    // user leaves the chat
    func leaveChat(identifier email: String, chatId: String, completion: @escaping( (Bool) -> Void )) {
        // remove chat id in user
        // TODO: test if this func has return value
        db.collection("user").document(email).updateData([
            "chats": FieldValue.arrayRemove([chatId])
        ])
        // remove user id in chat
        // TODO: test if this func has return value
        db.collection("chat").document(chatId).updateData([
            "users": FieldValue.arrayRemove([email])
        ])
        
        // TODO: add completion
    }
    
    // Chat operations
    func getChat(chatId: String, completion: @escaping( (Chat?) -> Void )) {
        db.collection("chat").document(chatId).getDocument() {
            (document, err) in
            
            if let chatDocument = document, ((document?.exists) != nil) {
                let chat: Chat = Chat(
                    users: (chatDocument.get("users") as? [String]) ?? [],
                    name: (chatDocument.get("name") as? String) ?? "error",
                    quarter: (chatDocument.get("quarter") as? String) ?? "error",
                    messages: (chatDocument.get("message") as? [String] ?? [] ))
                completion(chat)
            } else {
                completion(nil)
            }
        }
    }
    
    // send a message
    func sendText(identifier email: String, chatId: String, text: String, completion: @escaping( (Bool) -> Void )) {
        // add message
        let messageRef = db.collection("message").document()
        messageRef.setData([
            "text": text,
            "sender": email,
            "sentAt": Date.init(),
            "chat": chatId
        ])
        
        messageRef.getDocument() {
            (document, err) in
            
            guard let messageId = document!.get("__name__") as? String else {
                completion(false)
                return
            }
            
            self.db.collection("chat").document(chatId).updateData([
                "messages": FieldValue.arrayUnion([messageId])
            ])
            completion(true)
        }

    }
    
    func getHistory(timestamp until: Date, chatId: String, completion: @escaping (([Message]?) -> Void)) {
        <#code#>
    }
    
    func getHistory(numOfMessages until: Int, chatId: String, completion: @escaping (([Message]?) -> Void)) {
        <#code#>
    }
    
    func getUsersInChat(chatId: String, completion: @escaping (([User]?) -> Void)) {
        let chatRef = db.collection("chat").document(chatId)
        chatRef.getDocument() {
            query, err in
            if err != nil {
                completion(nil)
                return
            }
            let usersId = (query?.get("users") as? [String]) ?? []
            let usersRef = self.db.collection("user").whereField("__name__", in: usersId)
            
            usersRef.getDocuments {
                query, err in
                if err != nil {
                    completion(nil)
                    return
                }
                let users: [User]? = query?.documents.map({ (queryDocumentSnapshot) ->
                    User in return User(
                        email: (queryDocumentSnapshot.get("email") as? String) ?? "error",
                        name: (queryDocumentSnapshot.get("name") as? String) ?? "error",
                        chats: (queryDocumentSnapshot.get("chats") as? [String]) ?? [],
                        createdAt: (queryDocumentSnapshot.get("createdAt") as? Date) ?? Date.init()
                    )
                })
                completion(users)
            }
        }
    }
    
    func searchChat(search_token: String, completion: @escaping (([Chat]?) -> Void)) {
        if search_token.count < 3 {
            completion(nil)
        }
        
        let courseCate = search_token.prefix(3).uppercased()
        var courseNumber: Int = 0
        
        var i = 3
        while i < search_token.count {
            let curr = search_token[search_token.index(search_token.startIndex, offsetBy: 3)]
            if curr.isNumber {
                courseNumber = courseNumber * 10 + (Int(String(curr)) ?? 0)
            }
            i += 1
        }
        
        let query = courseCate + " " + (courseNumber < 100 ? "0" + String(courseNumber) : String(courseNumber))
        let queryRef = db.collection("chat").whereField("name", isGreaterThanOrEqualTo: query).whereField("name", isLessThanOrEqualTo: (query + "~"))
        queryRef.getDocuments {
            querySnapshot, err in
            if err != nil {
                completion(nil)
            }
            completion(querySnapshot?.documents.map({ (queryDocumentSnapshot) -> Chat in
                return Chat(
                    users: (queryDocumentSnapshot.get("users") as? [String]) ?? [],
                    name: (queryDocumentSnapshot.get("name") as? String) ?? "error",
                    quarter: (queryDocumentSnapshot.get("quarter") as? String) ?? "error",
                    messages: (queryDocumentSnapshot.get("message") as? [String] ?? [] ))
            }))
        }
    }
    
    func getMessage(messageId: String, completion: @escaping ((Message?) -> Void)) {
        db.collection("message").document(messageId).getDocument() {
            (document, err) in
            
            if let msgDocument = document, ((document?.exists) != nil) {
                let msg: Message = Message(
                    text: (msgDocument.get("chat_id") as? String) ?? "error",
                    sentAt: (msgDocument.get("sent_at") as? Date) ?? Date.init(),
                    sendBy: (msgDocument.get("text") as? String) ?? "error",
                    charId: (msgDocument.get("send_by") as? String ?? "error" ))
                completion(msg)
            } else {
                completion(nil)
            }
        }
    }
    
}

