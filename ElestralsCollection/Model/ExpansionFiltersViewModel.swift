//
//  ExpansionFiltersViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/16/23.
//

import Foundation

class ExpansionFiltersViewModel: ObservableObject {
    @Published var filters: Set<ExpansionFilterType> = Set([.Descending])
    
    func isDefault() -> Bool {
        return self.filters == Set([.Descending])
    }
}
enum ExpansionFilterType {
    case Ascending
    case Descending
}
