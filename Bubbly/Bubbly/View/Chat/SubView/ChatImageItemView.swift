//
//  ChatImageItemView.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI

struct ChatImageItemView: View {
    let urlString: String
    let direction: ChatItemDirection
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            
            URLImageView(urlString: urlString)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatImageItemView(urlString: "", direction: .right)
}
