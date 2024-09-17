//
//  MemoryStorage.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}

final class MemoryStorage: MemoryStorageType {
    
    // MARK: - Properties
    
    var cache = NSCache<NSString, UIImage>() // ns계열이라 둘 다 class 타입이여야하기 때문
    
    // MARK: - Implementation
    
    func value(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        // cost parameter: 용량 정의. Byte 단위. NSCache는 자체적으로 메모리 관리 정책 있으므로 할당해주는 편이 좋음
        cache.setObject(image, forKey: NSString(string: key))
    }
}
