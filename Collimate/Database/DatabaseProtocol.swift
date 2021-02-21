//
//  DatabaseProtocol.swift
//  Collimate
//
//  Created by Zesheng Xing on 2/18/21.
//

import Foundation

protocol DatabaseManagerProtocal {
    
    // User level operations
    func getUser(identifier email: String, completion: @escaping( (User?) -> Void )) // somewhat thread kills
    
    func createUser(with user: User)
    
    func doesUserExists(identifier email: String, completion: @escaping( (Bool?) -> Void ))
    
    func getUserChats(identifier email: String, completion: @escaping( ([Chat]?) -> Void )) // somewhat thread kills
    
    func joinChat(identifier email: String, chatId: String, completion: @escaping( (Bool) -> Void )) // works well
    
    func leaveChat(identifier email: String, chatId: String, completion: @escaping( (Bool) -> Void )) // works well
    
    // Chat operations
    func getChat(chatId: String, completion: @escaping( (Chat?) -> Void )) // works well
    
    func sendText(identifier email: String, chatId: String, text: String, completion: @escaping( (Bool) -> Void )) // sendText doesn't add message into chat
    
//    func getHistory(timestamp until: Date, chatId: String, completion: @escaping( ([Message]?) -> Void ))
//
//    func getHistory(numOfMessages until: Int, chatId: String, completion: @escaping( ([Message]?) -> Void ))
    
    func getUsersInChat(chatId: String, completion: @escaping( ([User]?) -> Void )) // works well
    
    func searchChat(search_token: String, completion: @escaping( ([Chat]?) -> Void )) // bad results
    
    // Message operations
    func getMessage(messageId: String, completion: @escaping( (Message?) -> Void )) // returend an error
    
}
