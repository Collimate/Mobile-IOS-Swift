//
//  ViewController.swift
//  Collimate
//
//  Created by Zesheng Xing on 2/18/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let manager = DatabaseFactory.generateDatabase("firestore")
        
        // get the newly added messages
        
        
        // local databases
        // get all messages when updated
        // update the entrie messages data
        
        
        let chatId = "05DEiiUSTQ9T2IKmfRHZ"
        let userId = "hmma-ucdavis-edu"
        
        manager.messagesInChat(chatId: "05DEiiUSTQ9T2IKmfRHZ") { (ms) in
            print(ms)
        }
        
        for i in 1...5 {
            manager.sendText("hahahah", chatId: "05DEiiUSTQ9T2IKmfRHZ", text: String(i) + " message") { (b) in
                print(b)
            }
        }
        
        
        //        manager.getUser(identifier: userId) { res in
//            print(res?.name)
//        }
        
        
        
//        manager.joinChat(identifier: userId, chatId: chatId) { res in
//            return
//        }
        
        var userName: String = ""
//        manager.getChat(chatId: chatId) { res in
//            print(res?.name)
//        }
        
//        manager.getUsersInChat(chatId: chatId) { res in
//            print(res?.count)
//        }
        let messageId = "qMAw5XhITBEwmPSU6M85"
//        manager.getMessage(messageId: messageId) { res in
//            print(res?.text)
//        }
        
//        print(userName)
        
//        manager.sendText(identifier: userId, chatId: chatId, text: "I am happy to meet you all") { res in
//            return
//        }
        
//        manager.leaveChat(identifier: userId, chatId: chatId) { res in
//            return
//        }
        
        
    }


}

