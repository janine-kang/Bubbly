//
//  LoginLandingView.swift
//  GPTChat
//
//  Created by Janine on 8/21/24.
//

import SwiftUI

struct LoginLandingView: View {
    
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                
                Text("버블리와 함께")
                    .font(.system(size: 20, weight: .medium))
                
                Text("즐거운 대화를 나눠보세요! 💬")
                
                Spacer()
                
                Button {
                    isPresentedLoginView.toggle()
                } label: {
                    Text("시작하기")
                        .font(.system(size: 16, weight: .medium))
                }
                .buttonStyle(ButtonFillStyle(textColor: .whiteFix, backgroundColor: .heavyAccent))
            }
            .navigationDestination(isPresented: $isPresentedLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    LoginLandingView()
}
