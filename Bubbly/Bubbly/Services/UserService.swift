//
//  UserService.swift
//  GPTChat
//
//  Created by Janine on 8/22/24.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func updateUserDescription(userId: String, description: String) async throws
    func updateProfileURL(userId: String, urlString: String) async throws
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError>
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError>
}

final class UserService: UserServiceType {
    
    // MARK: - Properties
    
    private var dbRepository: UserDBRepositoryType
    
    
    // MARK: - Life Cycle
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    // MARK: - Implementation
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map { user }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserAfterContact(users: users.map { $0.toObject() })
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toEntity() }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }

    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toEntity()
    }
    
    func updateUserDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description)
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString)
    }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toEntity() }
                .filter { $0.id != id }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.filterUsers(with: queryString)
            .map {$0
                .map { $0.toEntity() }
                .filter { $0.id != userId }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubUserService: UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        .stub1
    }
    
    func updateUserDescription(userId: String, description: String) async throws { }
    
    func updateProfileURL(userId: String, urlString: String) async throws { }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2, .stub3, .stub4, .stub5]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
