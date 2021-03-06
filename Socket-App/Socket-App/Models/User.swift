//
//  User.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 12/07/21.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String?
    var isConnected: Bool?
    var nickname: String?
}
