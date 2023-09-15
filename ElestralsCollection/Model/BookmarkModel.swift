//
//  BookmarkModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/13/23.
//

import Foundation
import SwiftUI

class BookmarkModel: Hashable, Identifiable {
    var cards: [ElestralCard] = []
    let id = UUID()
    
    @Published var name: String
    @Published var type: BookmarkType
    @Published var showOwnedIndicator: Bool
    @Published var showProgres: Bool
    
    @Published var icon: String = ""
    @Published var color: Color
    
    init(cards: [ElestralCard], name: String, type: BookmarkType, showOwnedIndicator: Bool, showProgres: Bool, icon: String, color: Color) {
        self.cards = cards
        self.name = name
        self.type = type
        self.showOwnedIndicator = showOwnedIndicator
        self.showProgres = showProgres
        self.icon = icon
        self.color = color
    }
    
    init() {
        self.cards = []
        self.name = ""
        self.type = .standard
        self.showOwnedIndicator = true
        self.showProgres = true
        self.icon = "heart.fill"
        self.color = .blue
    }
    
    static func == (lhs: BookmarkModel, rhs: BookmarkModel) -> Bool {
        return lhs.cards == rhs.cards &&
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.showOwnedIndicator == rhs.showOwnedIndicator &&
        lhs.showProgres == rhs.showProgres &&
        lhs.icon == rhs.icon &&
        lhs.color == rhs.color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cards)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(showOwnedIndicator)
        hasher.combine(showProgres)
        hasher.combine(icon)
        hasher.combine(color)
    }
    
}

enum BookmarkType: String, Decodable, Encodable {
    case standard = "Standard"
    case smart = "Smart"
    case deck = "Deck"
}

