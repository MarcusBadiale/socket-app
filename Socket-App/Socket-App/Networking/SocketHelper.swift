//
//  SocketHelper.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 12/07/21.
//

import UIKit
import SocketIO

let kHost = "http://10.0.0.126:3001"
let kConnectUser = "connectUser"
let kUserList = "userList"
let kExitUser = "exitUser"

final class SocketHelper {
    
    // Singleton
    static let shared = SocketHelper()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    init() {
        configureSocketClient()
    }
}

extension SocketHelper {
    // MARK: - Private Methods
    private func configureSocketClient() {
        guard let url = URL(string: kHost) else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        
        guard let manager = manager else {
            return
        }
        
        socket = manager.socket(forNamespace: "/**********")
    }
    
    // MARK: - Internal Methods
    func establishConnection() {
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.connect()
    }
    
    func closeConnection() {
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.disconnect()
    }
    
    /// This “nickName” is a user name with users want to join the chat room.
    func joinChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit(kConnectUser, nickname)
        completion()
    }
    
    /// This “nickName” is a user name with users want to leave the chat room.
    func leaveChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.emit(kExitUser, nickname)
        completion()
    }
    
    /// Get all the connected users
    func participantList(completion: @escaping (_ userList: [User]?) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        // This will return an array of results and an acknowledgment.
        socket.on(kUserList) { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                  let _ = self,
                  let user = result.first as? [[String: Any]],
                  let data = UIApplication.jsonData(from: user) else {
                return
            }
            
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completion(userModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
    
    // This will be used by writter
    func sendMessage(message: String, withNickname nickname: String) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit("chatMessage", nickname, message)
    }
    
    // This will be used by reader
    func getMessage(completion: @escaping (_ messageInfo: Message?) -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            
            var messageInfo = [String: Any]()
            
            guard let nickName = dataArray[0] as? String,
                  let message  = dataArray[1] as? String,
                  let date     = dataArray[2] as? String else{
                return
            }
            
            messageInfo["nickname"] = nickName
            messageInfo["message"] = message
            messageInfo["date"] = date
            
            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }
            
            do {
                let messageModel = try JSONDecoder().decode(Message.self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
}
