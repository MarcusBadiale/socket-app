//
//  Message.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 12/07/21.
//

import Foundation

struct Message: Codable, Hashable {
    
    var date: String?
    var message: String?
    var nickname: String?
}
