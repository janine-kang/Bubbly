//
//  SearchDataController.swift
//  GPTChat
//
//  Created by Janine on 9/9/24.
//

import Foundation
import CoreData

final class SearchDataController: ObservableObject {
    
    let persistantContainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantContainer.loadPersistentStores { description, error in
            if let error {
                print("Core data couldn't be loaded: ", error)
            }
        }
    }
    
}
