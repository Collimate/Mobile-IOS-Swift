//
//  DatabaseProtocol.swift
//  Collimate
//
//  Created by Zesheng Xing on 2/18/21.
//

import Foundation

protocol DatabaseManagerProtocal {
    
    // User level operations
    func getUser(_ email: String, completion: @escaping( (User?) -> Void ))
    
    func createUser(with user: User)
    
    func doesUserExists(_ email: String, completion: @escaping( (Bool?) -> Void ))
    
    func getUserChats(_ email: String, completion: @escaping( ([Chat]?) -> Void ))
    
    func joinChat(_ email: String, chatId: String, completion: @escaping( (Bool) -> Void ))
    
    func leaveChat(_ email: String, chatId: String, completion: @escaping( (Bool) -> Void ))
    
    // Chat operations
    func getChat(chatId: String, completion: @escaping( (Chat?) -> Void )) // works well
    
    func sendText(_ email: String, chatId: String, text: String, completion: @escaping( (Bool) -> Void ))
    
//    func getHistory(timestamp until: Date, chatId: String, completion: @escaping( ([Message]?) -> Void ))
//
//    func getHistory(numOfMessages until: Int, chatId: String, completion: @escaping( ([Message]?) -> Void ))
    
    func getUsersInChat(chatId: String, completion: @escaping( ([User]?) -> Void ))
    
    func searchChat(search_token: String, completion: @escaping( ([Chat]?) -> Void ))
    
    // Message operations
    func getMessage(messageId: String, completion: @escaping( (Message?) -> Void ))
    
}
