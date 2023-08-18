//
//  HelperFunctions.swift
//
//
//  Created by Trenton Parrotte on 11/29/22.
//

import Foundation
import UIKit


extension GridSection {
    
    func getNumberOwned(for element: String) -> Int {
        let list = self.data.getElestralsList().filter {
            $0.elements.contains(element) &&
            $0.numberOwned > 0
        }
        return list.count
    }
    
    func getElementalElestrals(for element: String) -> [String] {
        let element = element.lowercased()
        var filterType: FilterType = .unknown
        switch element {
        case "earth":
            filterType = .earth
        case "fire":
            filterType = .fire
        case "thunder":
            filterType = .thunder
        case "water":
            filterType = .water
        case "wind":
            filterType = .wind
        default:
            filterType = .unknown
        }
        guard filters.contains(filterType) else {
            return []
        }
        
        let elementals = data.getElestralsList().filter {
            if filters.contains(.none) {
                return $0.elements.contains(element)
            } else if filters.contains(.owned) {
                return $0.elements.contains(element) && $0.numberOwned > 0
            } else if filters.contains(.unowned) {
                return $0.elements.contains(element) && $0.numberOwned == 0
            } else {
                return false
            }
        }
        
        var uniqueNames = Set<String>()
        for elemental in elementals {
            uniqueNames.insert(elemental.name.lowercased())
        }
        
        var resultNames = Array(uniqueNames).sorted()
        
        if !searchText.isEmpty {
            resultNames = resultNames.filter {
                $0.contains(searchText.lowercased())
            }
        }
        
        return resultNames
    }
}


extension ElestralsView {
    
    func getState(for filterType: FilterType) -> Bool {
        return self.filtersViewModel.filters.contains(filterType)
    }
}

extension ExpansionsView {
    
    func getState(for filterType: ExpansionFilterType) -> Bool {
        return self.filtersViewModel.filters.contains(filterType)
    }
    
}

extension ElestralsGridItem {
//    func updateOwned(for elestral: Elestral) {
//        let index = self.data.elestralsList.firstIndex(where: { $0.name == elestral.name })
//        self.data.elestralsList[index!].isOwned = elestral.isOwned
//    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

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

extension String {
    func toDate(format: String = "MM/dd/yyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}
