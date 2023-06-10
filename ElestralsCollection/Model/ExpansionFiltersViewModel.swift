//
//  ExpansionFiltersViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/16/23.
//

import Foundation

class ExpansionFiltersViewModel: ObservableObject {
    @Published var filters: Set<ExpansionFilterType> = Set([.descending])
    
    func isDefault() -> Bool {
        return self.filters == Set([.descending])
    }
}
enum ExpansionFilterType {
    case ascending
    case descending
}
