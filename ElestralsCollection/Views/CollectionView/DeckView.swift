//
//  DeckView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/21/23.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct DeckView: View {
    init(subset: [ElestralCard], viewTitle: String = "My Deck", noResultsText: String = "No Cards found, start collecting to see cards appear here!", showOwnedIndicator: Bool = true, showNumberOwned: Bool = true) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().standardAppearance = appearance
        self.subset = subset
        self.viewTitle = viewTitle
        self.noResultsText = noResultsText
        self.showNumberOwned = showNumberOwned
        self.showOwnedIndicator = showOwnedIndicator
    }
    
    var noResultsText: String = ""
    let subset: [ElestralCard]
    let viewTitle: String
    let showNumberOwned: Bool
    let showOwnedIndicator: Bool
    
    private var spiritCards: [ElestralCard] {
        return subset.filter { $0.cardType == "spirit" }
    }

    private var elestralCards: [ElestralCard] {
        return subset.filter { $0.cardType == "elestral" }
    }

    private var otherCards: [ElestralCard] {
        return subset.filter { $0.cardType != "spirit" && $0.cardType != "elestral" }
    }
    
    @EnvironmentObject var data: CardStore
    
    @State var searchText = ""
    @State var presentSearch = false
    
    @StateObject private var cardImageLoader = CardImageLoader()
    
    @StateObject var filtersViewModel: CollectionFiltersViewModel = CollectionFiltersViewModel()
    
    @State private var selectedCard: ElestralCard?
    
    public let layout = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Section for Spirit cards
                    Section(content: {
                        CardGridView(
                            title: self.viewTitle,
                            subset: spiritCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            let total = spiritCards.map { $0.numberOwned }.reduce(0, +)
                            Group {
                                if total <= 20 {
                                    Text("Spirit Cards: \(total) of 20")
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Spirit Cards: \(total) of 20")
                                        .foregroundColor(.red)
                                }
                            }
                        })
                    })
                    
                    // Section for Elestral cards
                    Section(content: {
                        CardGridView(
                            title: self.viewTitle,
                            subset: spiritCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            let total = spiritCards.map { $0.numberOwned }.reduce(0, +)
                            Text("Elestral Cards: \(total)")
                                .foregroundColor(.secondary)
                        })
                    })
                    
                    // Section for other cards
                    Section(content: {
                        CardGridView(
                            title: self.viewTitle,
                            subset: spiritCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            let total = spiritCards.map { $0.numberOwned }.reduce(0, +)
                            Text("Rune Cards: \(total)")
                                .foregroundColor(.secondary)
                        })
                    })
                }
            }
            .background(Color("backgroundBase"))
            .sheet(isPresented: $presentSearch, content: {
                SearchView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.presentSearch.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            }
        }
        .hiddenNavigationBarStyle()
        .sheet(item: $selectedCard) { selectedCard in
            CardDetailView(card: selectedCard)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(subset: [])
    }
}

