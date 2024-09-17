//
//  ChatData.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    var id: String { dateStr }
}
