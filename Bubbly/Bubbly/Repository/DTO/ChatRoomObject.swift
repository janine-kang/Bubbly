//
//  ChatRoomObject.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

struct ChatRoomObject: Codable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUserId: String
}

extension ChatRoomObject {
    
    func toEntity() -> ChatRoom {
        
        .init(chatRoomId: self.chatRoomId,
              lastMessage: self.lastMessage,
              otherUserName: self.otherUserName,
              otherUserId: self.otherUserId
        )
        
    }
}
