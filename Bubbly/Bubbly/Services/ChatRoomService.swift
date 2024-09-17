//
//  ChatRoomService.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine

protocol ChatRoomServiceType {
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError>
    func loadChatRoom(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError>
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError>
}

final class ChatRoomService: ChatRoomServiceType {
    
    // MARK: - Properties
    
    private let dbRepository: ChatRoomDBRepositoryType
    
    init(dbRepository: ChatRoomDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    // MARK: - implementation
    
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
        dbRepository.getChatRoom(myUserId: myUserId, otherUserId: otherUserId)
            .mapError { ServiceError.error($0) }
            .flatMap { object in
                if let object {
                    return Just(object.toEntity())
                        .setFailureType(to: ServiceError.self)
                        .eraseToAnyPublisher()
                } else {
                    let newChatRoom: ChatRoom = .init(chatRoomId: UUID().uuidString, otherUserName: otherUserName, otherUserId: otherUserId)
                    return self.addChatRoom(newChatRoom, to: myUserId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func loadChatRoom(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError> {
        dbRepository.loadChatRoom(myUserId: myUserId)
            .map { $0.map { $0.toEntity() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError> {
        dbRepository.updateChatRoomLastMessage(chatRoomId: chatRoomId,
                                               myUserId: myUserId,
                                               myUserName: myUserName,
                                               otherUserId: otherUserId,
                                               lastMessage: lastMessage)
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    
    private func addChatRoom(_ chatRoom: ChatRoom, to myUserId: String) -> AnyPublisher<ChatRoom, ServiceError> {
        dbRepository.addChatRoom(chatRoom.toObject(), myUserId: myUserId)
            .map { chatRoom }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubChatRoomService: ChatRoomServiceType {
    
    func createChatRoomIfNeeded(myUserId: String, otherUserId: String, otherUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func loadChatRoom(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError> {
        Just([.stub1, .stub2, .stub3]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
