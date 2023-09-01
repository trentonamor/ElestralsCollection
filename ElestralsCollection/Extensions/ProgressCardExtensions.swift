//
//  ProgressCardExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation

extension ProgressCard {
    func getNumberCollected(for cardName: String?) -> Int{
        if let cardName = cardName {
            //TODO: Calculate the total owned for that elestral
            return 0
        } else {
            // Calculate the total owned out of all elestrals
            var count = 0
            for card in self.cardViewModel.cardList {
                if card.numberOwned > 0 {
                    count += 1
                }
            }
            return count
        }
    }
    
    func getNumberCardsOwned(for cardName: String?) -> Int {
        if let cardName = cardName {
            //TODO: Calculate the total owned for that elestral
            return 0
        } else {
            // Calculate the total owned out of all elestrals
            var count = 0
            for creature in self.cardViewModel.cardList {
                count += creature.numberOwned
            }
            return count
        }
    }
    
    private func getUniqueNumberOfCardsCollection(for cardName: String?) -> Int {
        if let cardName = cardName {
            //TODO: Calculate the total owned for that elestral
            return 0
        } else {
            // Calculate the total owned out of all elestrals
            var count = 0
            for creature in self.cardViewModel.cardList {
                if creature.numberOwned > 0 {
                    count += 1
                }
            }
            return count
        }
    }
    
    func getPercentage(for card: String? = nil) -> Float{
        let total = self.cardViewModel.getUniqueNumberOfElestrals()
        let collected = self.getNumberCollected(for: card)
        
        return Float(collected) / Float(total)
    }
}
