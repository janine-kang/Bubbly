//
//  User.swift
//  GPTChat
//
//  Created by Janine on 8/22/24.
//

import Foundation

struct User: Identifiable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension User {
    func toObject() -> UserObject {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}

extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "GPT Cat")
    }
    static var stub2: User {
        .init(id: "user2_id", name: "GPT Dog")
    }
    static var stub3: User {
        .init(id: "user3_id", name: "GPT Joy")
    }
    static var stub4: User {
        .init(id: "user4_id", name: "GPT Sad")
    }
    static var stub5: User {
        .init(id: "user5_id", name: "GPT Envy")
    }
}
import Foundation
