//
//  ImageCacheService.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

final class ImageCacheService: ImageCacheServiceType {
    
    // MARK: - Properties
    
    private let memoryStorage: MemoryStorageType
    private let diskStorage: DiskStorageType
    
    // MARK: - Life cycle
    
    init(memoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    // MARK: - Implementation
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        /// 1. memory Storage 확인
        /// 2. disk storage 확인
        /// 3. 없으면 urlsession으로 통신하여 가져옴, memory storage와 disk storage에 각각 저장
        
        imageWithMemoryCache(for: key)
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {
                    return self.imageWithDiskCache(for: key)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    
    private func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }
        .eraseToAnyPublisher()
    }
    
    private func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                /// Never로 Error타입 정의했기 때문에 success로만 반환
                promise(.success(nil))
            }
        }
        .flatMap { image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else { return }
                        self?.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            } else {
                // TODO: - network 통신
                /// TODO: eraseToAnyPublisher 분석 -> AnyPublisher 맞춰주는 도구임(https://github.com/OpenCombine/OpenCombine/blob/master/Sources/OpenCombine/AnyPublisher.swift)
                return self.remoteImage(for: key)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    private func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

final class StubImageCacheService: ImageCacheServiceType {
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
