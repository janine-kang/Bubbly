//
//  OtherProfileMenuType.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

enum ChatbotProfileMenuType: Hashable, CaseIterable {
    case chat
    
    var description: String {
        switch self {
        case .chat:
            return "대화"
        }
    }
    
    var imageName: String {
        switch self {
        case .chat:
            return "sms"
        }
    }
}

