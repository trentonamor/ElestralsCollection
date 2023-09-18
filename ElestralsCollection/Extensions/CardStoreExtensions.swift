//
//  CardStoreExtension.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/17/23.
//

import Foundation

extension CardStore {
    func getExpansionList() -> [ExpansionId] {
        let uniqueSets =  Set(self.cards.map { $0.cardSet })
        return Array(uniqueSets)
    }
    
    func getCards(for cardName: String) -> [ElestralCard] {
        return self.cards.filter { $0.name == cardName }
    }
    
    func getCards(for expansion: ExpansionId) -> [ElestralCard] {
        return self.cards.filter { $0.cardSet == expansion }
    }
    
    func getCards(for isOwned: Bool) -> [ElestralCard] {
        if isOwned {
            return self.cards.filter { $0.numberOwned > 0 }
        } else {
            return self.cards.filter { $0.numberOwned == 0 }
        }
    }
    
    func getCards(for cardIds: Set<String>) -> [ElestralCard] {
        return self.cards.filter { cardIds.contains($0.id) }
    }
    
    func getTotalOwned(for cardName: String) -> Int {
        let cards = self.cards.filter {$0.name == cardName}
        let cardTotal = cards.reduce(0) { (result, card) in
            return result + card.numberOwned
        }
        return cardTotal
    }
    
    func getUniqueElestralsOwned(for element: String) -> Int {
        let cards = self.cards.filter { $0.elements.contains(element.lowercased()) && $0.cardType.lowercased() == "elestral"}
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
    
    func getAverageReleaseDate(for expansion: ExpansionId) -> Date{
        let cards = self.getCards(for: expansion)
        
        let totalTimeInterval = cards.reduce(0) { (result, card) in
            return result + card.publishedDate.timeIntervalSince1970
        }
        
        let averageTimeInterval = totalTimeInterval / Double(cards.count)
        return Date(timeIntervalSince1970: averageTimeInterval)
    }
    
    func getElestralsList() -> [ElestralCard] {
        return self.cards.filter { $0.cardType == "Elestral" }
    }
    
    func cardUpdated(_ card: ElestralCard) {
        self.lastUpdatedCard = card
    }
}
