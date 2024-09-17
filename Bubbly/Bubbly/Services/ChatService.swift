//
//  ChatService.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine

protocol ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError>
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never>
}

final class ChatService: ChatServiceType {
    
    // MARK: - Properties
    
    private let dbRepository: ChatDBRepositoryType
    
    init(dbRepository: ChatDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    // MARK: - Implementation
    
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        
        var chat = chat
        chat.chatId = dbRepository.childByAutoId(chatRoomId: chatRoomId)
        
        return dbRepository.addChat(chat.toObject(), to: chatRoomId)
            .map { chat }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        dbRepository.observeChat(chatRoomId: chatRoomId)
            .map { $0?.toEntity() }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

final class StubChatService: ChatServiceType {
    
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
 
