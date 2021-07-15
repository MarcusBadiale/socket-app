//
//  MuralViewViewModel.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 15/07/21.
//

import Foundation
import SwiftUI

final class MuralViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var users: [User] = []
    @Published private(set) var nickname: String
    
    var isWriter: Bool
    
    init(userNickname: String, isWriter: Bool) {
        self.nickname = userNickname
        self.isWriter = isWriter
        
        getMessagesFromServer()
        fetchParticipantList()
    }
    
    func getMessagesFromServer() {
        SocketHelper.shared.getMessage { [weak self] message in
            guard let self = self,
                  let msgInfo = message else {
                return
            }
            
            self.messages.append(msgInfo)
        }
    }
    
    func fetchParticipantList() {
        SocketHelper.shared.participantList {[weak self] (result: [User]?) in
            
            guard let self = self,
                let users = result else{
                    return
            }
            
            var filterUsers: [User] = users
            
            // Removed login user from list
            if let index = filterUsers.firstIndex(where: {$0.nickname == self.nickname}) {
                filterUsers.remove(at: index)
            }
            
            self.users = filterUsers
        }
    }
}
