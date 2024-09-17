//
//  DIContainer.swift
//  GPTChat
//
//  Created by Janine on 8/20/24.
//

import Foundation

final class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
