//
//  ButtonFillStyle.swift
//  GPTChat
//
//  Created by Janine on 8/21/24.
//

import SwiftUI

struct ButtonFillStyle: ButtonStyle {
    
    let textColor: Color
    let backgroundColor: Color
    
    init(textColor: Color, backgroundColor: Color? = nil) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor ?? textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(backgroundColor)
            )
            .padding(.horizontal, 10)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
