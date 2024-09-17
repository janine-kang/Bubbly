//
//  DiskStorage.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import UIKit

protocol DiskStorageType {
    func value(for key: String) throws -> UIImage?
    func store(for key: String, image: UIImage) throws
}

final class DiskStorage: DiskStorageType {
    
    // MARK: - Properties
    
    private let fileManager: FileManager
    private let directoryURL: URL
    
    // MARK: - Life cycle
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        /// cache/ImageCache폴더 생성할 예정이므로 주소 찍어줌
        self.directoryURL = fileManager.urls(for: .cachesDirectory,
                                             in: .userDomainMask)[0].appendingPathComponent("ImageCache")
        createDirectory()
    }
    

    // MARK: - Implementation
    
    func value(for key: String) throws -> UIImage? {
        let fileURL = cacheFileURL(for: key)
        
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
    }
    
    func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
    
    // MARK: - Methods
    
    private func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }
    
    private func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
}
