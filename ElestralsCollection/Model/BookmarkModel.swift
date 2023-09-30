//
//  BookmarkModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/13/23.
//

import Foundation
import SwiftUI

class BookmarkModel: ObservableObject, Hashable, Identifiable, CustomStringConvertible {
    var cards: [ElestralCard] = []
    var id: UUID
    
    @Published var name: String
    @Published var type: BookmarkType
    @Published var showOwnedIndicator: Bool
    @Published var showProgres: Bool
    
    @Published var icon: String = ""
    @Published var color: Color = Color(.dynamicBlue)
    
    var description: String {
        return """
        BookmarkModel:
        - ID: \(id)
        - Name: \(name)
        - Type: \(type.rawValue)
        - Show Owned Indicator: \(showOwnedIndicator)
        - Show Progress: \(showProgres)
        - Icon: \(icon)
        - Color: \(color.name)
        - Cards: \(cards.map { $0.description }.joined(separator: "\n"))
        """
    }

    
    init(cards: [ElestralCard], name: String, type: BookmarkType, showOwnedIndicator: Bool, showProgres: Bool, icon: String, color: Color, id: UUID) {
        self.id = id
        self.cards = cards
        self.name = name
        self.type = type
        self.showOwnedIndicator = showOwnedIndicator
        self.showProgres = showProgres
        self.icon = icon
        self.color = color
    }
    
    init(from entity: Bookmark, cardStore: CardStore) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        
        if let cardEntitiesSet = entity.cards as? Set<Card> {
            let cardIdsSet: [String] = cardEntitiesSet.compactMap { $0.id }
            self.cards = cardStore.getCards(for: cardIdsSet)
        } else {
            self.cards = []
        }
        
        self.type = BookmarkType(rawValue: entity.type ?? BookmarkType.standard.rawValue) ?? .standard
        self.showOwnedIndicator = entity.showOwnedIndicator
        self.showProgres = entity.showProgress
        self.icon = entity.icon ?? ""
        self.color = Color(entity.color ?? "dynamicBlue")
    }
    
    init() {
        self.cards = []
        self.name = ""
        self.type = .standard
        self.showOwnedIndicator = true
        self.showProgres = true
        self.icon = "heart.fill"
        self.color = Color(.dynamicBlue)
        self.id = UUID()
    }
    
    convenience init(copying original: BookmarkModel) {
        self.init()
        self.id = original.id
        self.name = original.name
        self.cards = original.cards
        self.type = original.type
        self.showOwnedIndicator = original.showOwnedIndicator
        self.showProgres = original.showProgres
        self.icon = original.icon
        self.showProgres = original.showProgres
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
    //case smart = "Smart"
    case deck = "Deck"
}

