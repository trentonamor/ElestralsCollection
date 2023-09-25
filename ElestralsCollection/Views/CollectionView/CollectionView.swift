//
//  CollectionView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/9/23.
//

import SwiftUI
import UIKit
import FirebaseStorage
import FirebaseFirestore

struct CollectionView: View {
    init(subset: [ElestralCard], viewTitle: String = "My Collection", noResultsText: String = "No Cards found, start collecting to see cards appear here!", showOwnedIndicator: Bool = true, showNumberOwned: Bool = true) {
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

    @EnvironmentObject var data: CardStore

    @State var searchText = ""
    @State var presentFilters = false

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
            CardGridView(
                title: self.viewTitle,
                subset: subset,
                searchText: $searchText,
                presentFilters: $presentFilters,
                filtersViewModel: filtersViewModel,
                layout: layout,
                selectedCard: $selectedCard,
                noResultsString: self.noResultsText,
                showOwnedIndicator: self.showOwnedIndicator,
                showNumberOwned: self.showNumberOwned
            )
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search by Name, Artist, or Id")
            .sheet(isPresented: $presentFilters, content: {
                CollectionFiltersView(filters: $filtersViewModel.filters)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    FilterButton(presentFilters: $presentFilters, filtersViewModel: filtersViewModel)
                })
            }
        }
        .hiddenNavigationBarStyle()
        .sheet(item: $selectedCard) { selectedCard in
            CardDetailView(card: selectedCard)
        }
    }
}

struct FilterButton: View {
    @Binding var presentFilters: Bool
    @ObservedObject var filtersViewModel: CollectionFiltersViewModel
    
    var body: some View {
        Button(action: {
            presentFilters.toggle()
        }, label: {
            if filtersViewModel.isDefault() {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .frame(height: 96, alignment: .trailing)
            } else {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .frame(height: 96, alignment: .trailing)
            }
        })
        .tint(Color.blue)
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(subset: [])
    }
}
