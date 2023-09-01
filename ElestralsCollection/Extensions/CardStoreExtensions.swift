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
    
    
    func getElestralsList() -> [ElestralCard] {
        return self.cards.filter { $0.cardType == "Elestral" }
    }
}
