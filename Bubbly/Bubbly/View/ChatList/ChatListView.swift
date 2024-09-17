//
//  ChatListView.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: ChatListViewModel
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destinations) {
            ScrollView {
                NavigationLink(value: NavigationDestination.search(userId: viewModel.userId)) {
                    SearchButton()
                }
                .padding(.vertical, 14)
                //                                LazyVStack
                ForEach(viewModel.chatRooms, id: \.self) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, userId: viewModel.userId)
                }
            }
            .navigationTitle("채팅방")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
            .onAppear {
                viewModel.send(action: .load)
            }
        }
    }
}

fileprivate struct ChatRoomCell: View {
    
    let chatRoom: ChatRoom
    let userId: String
    
    var body: some View {
        NavigationLink(value: NavigationDestination.chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: userId,
                                                         otherUserId: chatRoom.otherUserId)) {
            
            HStack(spacing: 8) {
                Image("person")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(chatRoom.otherUserName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.bkText)
                    
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.greyDeep)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 17)
            
        }
    }
}

#Preview {
    ChatListView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user1_id"))
        .environmentObject(NavigationRouter())
}
