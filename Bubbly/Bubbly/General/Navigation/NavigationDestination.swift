//
//  NavigationDestination.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search(userId: String)
}
