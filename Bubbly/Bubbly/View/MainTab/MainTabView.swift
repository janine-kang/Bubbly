//
//  MainTabView.swift
//  GPTChat
//
//  Created by Janine on 8/20/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthenticatedViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: .init(container: container,
                                                  navigationRouter: navigationRouter,
                                                  userId: authViewModel.userID ?? ""))
                    case .chat:
                        ChatListView(viewModel: .init(container: container,
                                                      userId: authViewModel.userID ?? ""))
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
    }
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static let container = DIContainer(services: StubService())
    static let navigationRouter: NavigationRouter = .init()
    
    static var previews: some View {
        MainTabView()
            .environmentObject(Self.container)
            .environmentObject(Self.navigationRouter)
            .environmentObject(AuthenticatedViewModel(container: Self.container))
    }
}
