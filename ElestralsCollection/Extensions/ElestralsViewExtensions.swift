//
//  ElestralsViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation

extension ElestralsView {
    
    func getState(for filterType: FilterType) -> Bool {
        return self.filtersViewModel.filters.contains(filterType)
    }
}
