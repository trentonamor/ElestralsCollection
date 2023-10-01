//
//  CollectionFiltersModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/10/23.
//

import Foundation

class CollectionFiltersViewModel: ObservableObject {
    public let defaultsFilters: Set<CollectionFilterType> = Set([.ascending, .name, .both, .earth, .fire, .thunder, .water, .wind, .frost, .rainbow, .elestral, .spirit, .rune, .fullArt, .common, .rare, .uncommon, .holoRare, .stellarRare, .alternativeArt])
    
    @Published var filters: Set<CollectionFilterType>
    
    var sortOrder: Set<CollectionFilterType> {
        filters.intersection([.ascending, .descending])
    }
    
    var sortBy: Set<CollectionFilterType> {
        filters.intersection([.releaseDate, .name, .artist])
    }
    
    var cardState: Set<CollectionFilterType> {
        filters.intersection([.both, .ownedOnly, .moreThan1OwnedOnly, .unowned])
    }
    
    var cardType: Set<CollectionFilterType> {
        filters.intersection([.elestral, .spirit, .rune])
    }
    
    var elestralElement: Set<CollectionFilterType> {
        filters.intersection([.earth, .fire, .thunder, .water, .wind, .frost, .rainbow])
    }
    
    var rarity: Set<CollectionFilterType> {
        filters.intersection([.fullArt, .common, .rare, .uncommon, .holoRare, .stellarRare, .alternativeArt])
    }
    
    init() {
        self.filters = self.defaultsFilters
    }
    
    func isDefault() -> Bool {
        return self.filters == self.defaultsFilters
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
    case frost
    case rainbow
    
    //Rarity
    case fullArt
    case common
    case rare
    case uncommon
    case holoRare
    case stellarRare
    case alternativeArt
    
    
}
