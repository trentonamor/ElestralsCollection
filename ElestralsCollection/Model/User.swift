//
//  User.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/28/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String?
}

extension User {
    static var MOCK_USER = User(id: UUID().uuidString, fullname: "Trenton Parrotte", email: "trentonamor24@gmail.com")
}
