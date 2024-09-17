//
//  LoginView.swift
//  GPTChat
//
//  Created by Janine on 8/20/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticatedViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                authViewModel.send(action: .googleLogin)
            } label: {
                Text("Google로 로그인")
                    .font(.system(size: 16, weight: .medium))
            }.buttonStyle(ButtonBorderStyle(textColor: .blue))
            
            Button {
                
            } label: {
                Text("Apple로 로그인")
                    .font(.system(size: 16, weight: .medium))
            }.buttonStyle(ButtonFillStyle(textColor: .whiteFix,
                                          backgroundColor: .blackFix))
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("back")
                }
                
            }
        }
        .overlay {
            if authViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoginView()
}
