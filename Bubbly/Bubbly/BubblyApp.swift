//
//  BubblyApp.swift
//  GPTChat
//
//  Created by Janine on 8/20/24.
//

import SwiftUI

@main
struct BubblyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container),
                              navigationRouter: .init(),
                              searchDataController: .init())
                .environmentObject(container)
        }
    }
}
