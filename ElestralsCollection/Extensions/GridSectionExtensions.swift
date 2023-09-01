//
//  GridSectionExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation

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
