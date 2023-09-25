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

struct DeckView: View {
    init(subset: [ElestralCard], viewTitle: String = "My Deck", noResultsText: String = "No Cards found, start collecting to see cards appear here!", showOwnedIndicator: Bool = true, showNumberOwned: Bool = true, bookmarkId: UUID) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().standardAppearance = appearance
        self.subset = subset
        self.viewTitle = viewTitle
        self.noResultsText = noResultsText
        self.showNumberOwned = showNumberOwned
        self.showOwnedIndicator = showOwnedIndicator
        self.bookmarkId = bookmarkId
    }
    
    var noResultsText: String = ""
    let subset: [ElestralCard]
    let viewTitle: String
    let showNumberOwned: Bool
    let showOwnedIndicator: Bool
    let bookmarkId: UUID
    @EnvironmentObject var cardStore: CardStore
    
    private var spiritCards: [ElestralCard] {
        return subset.filter { $0.cardType.lowercased() == "spirit" }
    }
    
    private var spiritTotal: Int {
        self.getTotalInBookmark(cards: self.spiritCards, bookmarkId: self.bookmarkId)
    }

    private var elestralCards: [ElestralCard] {
        return subset.filter { $0.cardType.lowercased() == "elestral" }
    }
    
    private var elestralTotal: Int {
        self.getTotalInBookmark(cards: self.elestralCards, bookmarkId: self.bookmarkId)
    }

    private var runeCards: [ElestralCard] {
        return subset.filter { $0.cardType.lowercased() != "spirit" && $0.cardType.lowercased() != "elestral" }
    }
    
    private var runeTotal: Int {
        self.getTotalInBookmark(cards: self.runeCards, bookmarkId: self.bookmarkId)
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
                        DeckCardGridView(
                            title: self.viewTitle,
                            subset: spiritCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned,
                            bookmarkId: self.bookmarkId
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            Group {
                                if self.spiritTotal <= 20 {
                                    Text("Spirit Cards: \(self.spiritTotal) of 20")
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Spirit Cards: \(self.spiritTotal) of 20")
                                        .foregroundColor(.red)
                                }
                            }
                        })
                    })
                    
                    // Section for Elestral cards
                    Section(content: {
                        DeckCardGridView(
                            title: self.viewTitle,
                            subset: elestralCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned,
                            bookmarkId: self.bookmarkId
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            let remaining = 40 - self.runeTotal
                            if remaining >= self.elestralTotal {
                                Text("Elestral Cards: \(self.elestralTotal) of \(remaining)")
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Elestral Cards: \(self.elestralTotal) of \(remaining)")
                                    .foregroundColor(.red)
                            }
                        })
                    })
                    
                    // Section for other cards
                    Section(content: {
                        DeckCardGridView(
                            title: self.viewTitle,
                            subset: runeCards,
                            searchText: $searchText,
                            presentFilters: $presentSearch,
                            filtersViewModel: filtersViewModel,
                            layout: layout,
                            selectedCard: $selectedCard,
                            noResultsString: "",
                            showOwnedIndicator: self.showOwnedIndicator,
                            showNumberOwned: self.showNumberOwned,
                            bookmarkId: self.bookmarkId
                        )
                    }, header: {
                        HStack(alignment: .center, content: {
                            let remaining = 40 - self.elestralTotal
                            if remaining >= self.runeTotal {
                                Text("Rune Cards: \(self.runeTotal) of \(remaining)")
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Rune Cards: \(self.runeTotal) of \(remaining)")
                                    .foregroundColor(.red)
                            }
                        })
                    })
                }
            }
            .background(Color("backgroundBase"))
            .sheet(isPresented: $presentSearch, content: {
                CollectionView(subset: cardStore.cards, viewTitle: "Search", noResultsText: "We couldn't find any cards based on your search and the current filters.")
            })
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search by Name, Artist, or Id")
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
            DeckCardDetailView(card: selectedCard, bookmarkId: bookmarkId)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(subset: [], bookmarkId: UUID())
    }
}

