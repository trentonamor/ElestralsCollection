//
//  CollectionFiltersModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/10/23.
//

import Foundation

class CollectionFiltersViewModel: ObservableObject {
    @Published var filters: Set<CollectionFilterType> = Set([.ascending, .name, .both, .earth, .fire, .thunder, .water, .wind, .elestral, .spirit, .rune, .fullArt, .common, .rare, .uncommon, .holoRare, .stellarRare])
    
    func isDefault() -> Bool {
        return self.filters == Set([.ascending, .name, .both, .earth, .fire, .thunder, .water, .wind, .elestral, .spirit, .rune, .fullArt, .common, .rare, .uncommon, .holoRare, .stellarRare])
    }
}
enum CollectionFilterType {
    //Sort Order
    case ascending
    case descending
    
    //Sort By
    case releaseDate
    case name
    case artist
    
    //Card State
    case both
    case ownedOnly
    case moreThan1OwnedOnly
    case unowned
    
    //Card Type
    case elestral
    case spirit
    case rune
    
    //Elestral Element
    case earth
    case fire
    case thunder
    case water
    case wind
    
    //Rarity
    case fullArt
    case common
    case rare
    case uncommon
    case holoRare
    case stellarRare
    
    
}
