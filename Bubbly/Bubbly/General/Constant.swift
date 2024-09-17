//
//  Constant.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

typealias DBKey = Constant.DBKey

enum Constant {  }

extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatBot = "ChatBot"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}
