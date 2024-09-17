//
//  DBError.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}

