//
//  ElestralCardData.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/20/23.
//

import Foundation
import SwiftUI

class ElestralCard : ObservableObject, Hashable, Identifiable {
    @Published var id: String
    @Published var name: String
    @Published var effect: String
    @Published var elements: [String]
    @Published var subclasses: [String]
    @Published var attack: Int?
    @Published var defense: Int?
    @Published var artist: String
    @Published var cardSet: ExpansionId
    @Published var cardNumber: String
    @Published var rarity: String
    @Published var cardType: String
    @Published var runeType: String?
    @Published var publishedDate: Date
    var art: String {
        guard UIImage(named: cardNumber) != nil else { return "" }
        return cardNumber
    }
    
    @Published var numberOwned: Int = 0
    
    func getBackgroundColor() -> Color {
        if self.numberOwned == 0 {
            return .white
        }
        switch self.elements.first?.lowercased() {
            case "earth":
                return Color("EarthGreen")
            case "fire":
                return Color("FireRed")
            case "thunder":
                return Color("ThunderYellow")
            case "water":
                return Color("WaterBlue")
            case "wind":
                return Color("AirWhite")
            default:
            print("Error cannot find elements: \(self.elements.first ?? "")")
                return .white
        }
    }
    
    func getSprite() -> String {
        guard UIImage(named: self.name) != nil else {
            return self.elements.first ?? "StoneSquare"
        }
        return self.name
    }
    
    init(id: String, name: String, effect: String, elements: [String], subclasses: [String], attack: Int?, defense: Int?, artist: String, cardSet: ExpansionId, cardNumber: String, rarity: String, cardType: String, runeType: String?, date: Date) {
        self.id = id
        self.name = name
        self.effect = effect
        self.elements = elements
        self.subclasses = subclasses
        self.attack = attack
        self.defense = defense
        self.artist = artist
        self.cardSet = cardSet
        self.cardNumber = cardNumber
        self.rarity = rarity
        self.cardType = cardType
        self.runeType = runeType
        self.publishedDate = date
    }
    
    static func == (lhs: ElestralCard, rhs: ElestralCard) -> Bool {
        return lhs.name == rhs.name &&
            lhs.effect == rhs.effect &&
            lhs.elements == rhs.elements &&
            lhs.subclasses == rhs.subclasses &&
            lhs.attack == rhs.attack &&
            lhs.defense == rhs.defense &&
            lhs.artist == rhs.artist &&
            lhs.cardSet == rhs.cardSet &&
            lhs.cardNumber == rhs.cardNumber &&
            lhs.rarity == rhs.rarity &&
            lhs.publishedDate == rhs.publishedDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(effect)
        hasher.combine(elements)
        hasher.combine(subclasses)
        hasher.combine(attack)
        hasher.combine(defense)
        hasher.combine(artist)
        hasher.combine(cardSet)
        hasher.combine(cardNumber)
        hasher.combine(rarity)
        hasher.combine(publishedDate)
    }
}
