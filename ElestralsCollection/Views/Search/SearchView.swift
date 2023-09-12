import SwiftUI

struct SearchView: View {
    @EnvironmentObject var cardStore: CardStore
    
    var body: some View {
        NavigationStack {
            CollectionView(subset: cardStore.cards, viewTitle: "Search", noResultsText: "We couldn't find any cards based on your search and the current filters.")
        }
    }
}
