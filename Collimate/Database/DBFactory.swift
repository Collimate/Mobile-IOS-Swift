//
//  DBFactory.swift
//  Collimate
//
//  Created by Zesheng Xing on 2/18/21.
//

import Foundation

struct DatabaseFactory {

    static func generateDatabase(_ type: String) -> DatabaseManagerProtocal {
        switch type {
        case "firestore":
            return FirestoreManager.shared
        default:
            return FirestoreManager.shared
        }
    }
    
}
