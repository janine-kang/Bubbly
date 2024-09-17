//
//  UploadService.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine

protocol UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError>
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL
}

final class UploadService: UploadServiceType {
    
    // MARK: - Properties
    
    private let provider: UploadProviderType
    
    // MARK: - Life cycle
    
    init(provider: UploadProviderType) {
        self.provider = provider
    }
    
    // MARK: - Implementation
    
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        try await provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
    }
    
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubUploadService: UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        return URL(string: "")!
    }
    
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
