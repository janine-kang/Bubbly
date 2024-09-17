//
//  ChatRoom.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

struct ChatRoom: Hashable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUserId: String
}

extension ChatRoom {
    
    func toObject() -> ChatRoomObject {
        .init(chatRoomId: self.chatRoomId,
              lastMessage: self.lastMessage,
              otherUserName: self.otherUserName,
              otherUserId: self.otherUserId)
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "chatRoom1_id", otherUserName: "GPT Cat", otherUserId: "user1_id")
    }
    
    static var stub2: ChatRoom {
        .init(chatRoomId: "chatRoom2_id", otherUserName: "GPT Dog", otherUserId: "user2_id")
    }
    
    static var stub3: ChatRoom {
        .init(chatRoomId: "chatRoom3_id", otherUserName: "GPT Joy", otherUserId: "user3_id")
    }
}
