//
//  OtherProfileView.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChatbotProfileViewModel
    
    var goToChat: (User) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_others")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image("close")
                        })
                }
            }
            .task {
                await viewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        URLImageView(urlString: viewModel.userInfo?.profileURL)
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .padding(.bottom, 16)
    }
    
    // data stream으로 내려오기 때문에 두번 돌게 됨
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "noName")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.bgWh)
    }
    
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            ForEach(ChatbotProfileMenuType.allCases, id: \.self) { menu in
                Button {
                    if menu == .chat, let userInfo = viewModel.userInfo {
                        dismiss()
                        goToChat(userInfo)
                    }
                    
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundColor(.bgWh)
                    }
                }
            }
        }
    }
}

#Preview {
    OtherProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user2_id")) { _ in
        
    }
}
