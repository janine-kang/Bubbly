//
//  URLImageViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import UIKit
import Combine

final class URLImageViewModel: ObservableObject {
    
    // MARK: - Properties
    var loadingOrSuccess: Bool {
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var container: DIContainer
    private var urlString: String
    private var loading: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - life cycle
    
    init(container: DIContainer, urlString: String) {
        self.container = container
        self.urlString = urlString
    }
    
    // MARK: - Methods
    
    func start() {
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }
            .store(in: &subscriptions)
    }
}
