//
//  Message.swift
//  CollimateAuth
//
//  Created by Heming Ma on 2/18/21.
//

import Foundation
import FirebaseFirestore

struct Message {
    
    var text: String
    var sentAt: Timestamp
    var senderId: String
    var charId: String
    
}
