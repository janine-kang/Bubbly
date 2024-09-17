//
//  SearchViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/31/24.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    
    enum Action {
        case requestQuery(String)
        case clearSearchResult
        case clearSearchText
        case goToChat(User)
    }
    
    @Published var shouldBecomeFirstResponder: Bool = false
    @Published var searchText: String = ""
    @Published var searchResults: [User] = []
    
    private let userId: String
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    init(userId: String, container: DIContainer, navigationRouter: NavigationRouter) {
        self.userId = userId
        self.container = container
        self.navigationRouter = navigationRouter
        
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.send(action: .clearSearchResult)
                } else {
                    self?.send(action: .requestQuery(text))
                }
            }.store(in: &subscriptions)
    }
    
    func send(action: Action) {
        switch action {
        case let .requestQuery(query):
            container.services.userService.filterUsers(with: query, userId: userId)
                .sink { completion in
                } receiveValue: { [weak self] users in
                    self?.searchResults = users
                }.store(in: &subscriptions)
        case .clearSearchResult:
            searchResults = []
            
        case .clearSearchText:
            searchText = ""
            shouldBecomeFirstResponder = false
            searchResults = []
            
        case let .goToChat(otherUser):
        
            container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRoom in
                    guard let `self` = self else { return }
                    
                    self.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: self.userId,
                                                         otherUserId: otherUser.id))
                }
                .store(in: &subscriptions)
        }
        
    }
    
    
}
