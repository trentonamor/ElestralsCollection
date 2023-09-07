//
//  CardModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/1/22.
//

import Foundation

class CardModel: ObservableObject {
    @Published var cardType: CardType = .unknown
    @Published var cardList: [ElestralCard] = []
    
    init(cardType: CardType, cardList: [ElestralCard] = []) {
        self.cardType = cardType
        self.cardList = cardList
    }
    
    func getUniqueNumberOfElestrals() -> Int {
        let uniqueNames = Set(cardList.map { $0.name })
        return uniqueNames.count
    }
    
    func getUniqueOwned(for cardType: String) -> Int {
        let cards = self.cardList.filter { $0.cardType.lowercased() == cardType.lowercased() }
        var totalOwned = 0
        var cardsAdded: Set<String> = Set()
        for card in cards {
            if !cardsAdded.contains(card.name) && card.numberOwned > 0 {
                totalOwned += 1
                cardsAdded.insert(card.name)
            }
        }
        return totalOwned
    }
    
}

enum CardType: Codable {
    case unknown
    case progress
    case distribution
    case info
}
