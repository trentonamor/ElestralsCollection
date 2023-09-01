//
//  ExpansionViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation

extension ExpansionsView {
    
    func getState(for filterType: ExpansionFilterType) -> Bool {
        return self.filtersViewModel.filters.contains(filterType)
    }
    
}
