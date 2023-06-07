//
//  FilterType.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import Foundation

class FiltersViewModel: ObservableObject {
    @Published var filters: Set<FilterType> = Set([.none, .fire, .wind, .water, .thunder, .earth])
    
    func isDefault() -> Bool {
        return self.filters == Set([.none, .fire, .wind, .water, .thunder, .earth])
    }
}
enum FilterType {
    case unknown
    case none
    //State cases
    case owned
    case unowned
    
    //Type Filters
    case earth
    case fire
    case thunder
    case water
    case wind
}
