//
//  HomeViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
        case presentMyProfileView
        case presentOtherProfileView(String)
        case requestContacts
        case goToChat(User)
    }
    
    // MARK: - Properties
    
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    init(container: DIContainer, navigationRouter: NavigationRouter, userId: String) {
        self.container = container
        self.navigationRouter = navigationRouter
        self.userId = userId
    }
    
    // MARK: - Methods
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(id: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)
            
        case .presentMyProfileView:
            modalDestination = .myProfile
            
        case let .presentOtherProfileView(userId):
            modalDestination = .otherProfile(userId)
            
            // TODO: - change this to adding profile 
        case .requestContacts:
            container.services.contactService.fetchContacts()
                .flatMap { users in // TODO: - 왜 weak self하면 에러가 나는지? weak self 없애니까 왜 에러가 안나는지??
                    self.container.services.userService.addUserAfterContact(users: users)
                }
                .flatMap { _ in
                    self.container.services.userService.loadUsers(id: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success
                    self?.users = users
                }.store(in: &subscriptions)

        case let .goToChat(otherUser):
            // TODO: -
            container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
                .sink { completion in
                    // TODO: -
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
