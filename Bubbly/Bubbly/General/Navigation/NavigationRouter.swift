//
//  NavigationRouter.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

final class NavigationRouter: ObservableObject {
    
    // MARK: - Properties
    @Published var destinations: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
       _ = destinations.popLast()
    }
    
    func popToRootView() {
        destinations = []
    }
}
