//
//  AuthenticatedViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/20/24.
//

import Foundation
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

final class AuthenticatedViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin
        case logout
    }
    
    // MARK: - properties
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userID: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - Actions
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userID = container.services.authService.checkAuthenticationState() {
                self.userID = userID
                self.authenticationState = .authenticated
            }
            
        case .googleLogin:
            isLoading = true
            container.services.authService.signInWithGoogle()
                .flatMap { user in
                    self.container.services.userService.addUser(user)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] user in
                    self?.isLoading = false
                    self?.userID = user.id
                    self?.authenticationState = .authenticated
                }.store(in: &subscriptions)

            return
            
        case .appleLogin:
            // TODO: - login
            return
            
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userID = nil
                }.store(in: &subscriptions)

            return
        }
    }
}
