//
//  PhotoPickerService.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI
import PhotosUI
import Combine

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data,ServiceError>
}

final class PhotoPickerService: PhotoPickerServiceType {
    
    // MARK: - Implementation
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        
        return image.data
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Future { promise in
            imageSelection.loadTransferable(type: PhotoImage.self) { result in
                switch result {
                case let .success(image):
                    guard let data = image?.data else {
                        promise(.failure(PhotoPickerError.importFailed))
                        return
                    }
                    promise(.success(data))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
}

final class StubPhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        Data()
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
