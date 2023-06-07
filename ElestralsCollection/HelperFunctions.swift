//
//  HelperFunctions.swift
//
//
//  Created by Trenton Parrotte on 11/29/22.
//

import Foundation
import UIKit


extension GridSection {
    func getTitle(for element: Element) -> String {
        switch element {
        case .earth:
            return "Earth"
        case .fire:
            return "Fire"
        case .thunder:
            return "Thunder"
        case .water:
            return "Water"
        case .wind:
            return "Wind"
        default:
            return "Rainbow"
        }
    }
    
    func getNumberOwned(for element: Element) -> Int {
        let list = self.data.elestralsList.filter {
                $0.element == element &&
                $0.isOwned
            }
            return list.count
        }
    
    func getElementalElestrals(for element: Element) -> [String]{
        var filterType: FilterType = .unknown
        switch element {
        case .earth:
            filterType = .earth
        case .fire:
            filterType = .fire
        case .thunder:
            filterType = .thunder
        case .water:
            filterType = .water
        case .wind:
            filterType = .wind
        default:
            filterType = .unknown
        }
        guard filters.contains(filterType) else {
            return []
        }
        let earth = data.elestralsList.filter {
            if filters.contains(.none) {
                return $0.element == element
            } else if filters.contains(.owned) {
                return $0.element == element && $0.isOwned
            } else if filters.contains(.unowned) {
               return $0.element == element && $0.isOwned == false
            } else {
                return false
            }
        }
        let lcElestrals = earth.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
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
    func updateOwned(for elestral: Elestral) {
        let index = self.data.elestralsList.firstIndex(where: { $0.name == elestral.name })
        self.data.elestralsList[index!].isOwned = elestral.isOwned
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension ProgressCard {
    func getNumberCollected(for elestral: Elestral?) -> Int{
        if let elestral = elestral {
            //TODO: Calculate the total owned for that elestral
            return 0
        } else {
            // Calculate the total owned out of all elestrals
            var count = 0
            for creature in self.cardViewModel.cardList {
                if creature.isOwned {
                    count += 1
                }
            }
            return count
        }
    }
    
    func getNumberCardsOwned(for elestral: Elestral?) -> Int {
        if let elestral = elestral {
            //TODO: Calculate the total owned for that elestral
            return 0
        } else {
            // Calculate the total owned out of all elestrals
            var count = 0
            for creature in self.cardViewModel.cardList {
                if creature.isOwned {
                    count += 1
                }
            }
            return count
        }
    }
    
    func getPercentage(for elestral: Elestral? = nil) -> Float{
        let total = self.cardViewModel.cardList.count
        let collected = self.getNumberCollected(for: elestral)
        
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
