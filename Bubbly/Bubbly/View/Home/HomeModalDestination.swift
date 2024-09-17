//
//  HomeModalDestination.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int {
        hashValue
    }
}
