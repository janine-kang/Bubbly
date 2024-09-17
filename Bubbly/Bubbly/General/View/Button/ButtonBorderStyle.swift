//
//  ButtonBorderStyle.swift
//  GPTChat
//
//  Created by Janine on 8/21/24.
//

import SwiftUI

struct ButtonBorderStyle: ButtonStyle {
    
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color? = nil) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 0.8)
            )
            .padding(.horizontal, 10)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
