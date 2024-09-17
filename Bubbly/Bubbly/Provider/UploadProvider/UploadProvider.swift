//
//  UploadProvider.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseStorageCombineSwift

enum UploadError: Error {
    case error(Error)
}

/// interact with external service or more. repository do CRUD but not this.
protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) async throws -> URL
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError>
}

final class UploadProvider: UploadProviderType {
    
    let storageRef =  Storage.storage().reference()
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
    
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError> {
        let ref = storageRef.child(path).child(fileName)
        
        return ref.putData(data)
            .flatMap { _ in
                ref.downloadURL()
            }
            .mapError { UploadError.error($0) }
            .eraseToAnyPublisher()
    }
}
