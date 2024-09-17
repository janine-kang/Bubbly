//
//  ChatItemDirection.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI

enum ChatItemDirection {
    case left
    case right
    
    var backgroundColor: Color {
        switch self {
        case .left:
            return Color.chatColorOther
        case .right:
            return Color.chatColorMe
        }
    }
    
    var textColor: Color {
        switch self {
        case .left:
            return Color.bkText
        case .right:
            return Color.whiteFix
        }
    }
    
    var overlayAlignment: Alignment {
        switch self {
        case .left:
            return .topLeading
        case .right:
            return .topTrailing
        }
    }
    
    var overlayImage: Image {
        switch self {
        case .left:
            return Image("bubble_tail-left")
        case .right:
            return Image("bubble_tail-right")
        }
    }
}

