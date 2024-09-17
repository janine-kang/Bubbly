//
//  ChatListViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine

final class ChatListViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    // MARK: - Properties
    
    @Published var chatRooms: [ChatRoom] = []
    
    let userId: String
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    // MARK: - Methods
    
    func send(action: Action) {
        switch action {
        case .load:
            container.services.chatRoomService.loadChatRoom(myUserId: userId)
                .sink { completion in
                } receiveValue: { [weak self] chatRooms in
                    self?.chatRooms = chatRooms
                }
                .store(in: &subscriptions)
        }
    }
    
}

