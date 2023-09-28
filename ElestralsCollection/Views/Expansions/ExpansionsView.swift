import SwiftUI

struct ExpansionsView: View {
    @State var searchText = ""
    @State var presentFilters = false
    
    @ObservedObject var filtersViewModel: ExpansionFiltersViewModel =
        ExpansionFiltersViewModel()
    @ObservedObject var cardStore: CardStore
    
    var expansionCellModels: [ExpansionCellModel] = []
    
    var filteredExpansionCellModels: [ExpansionCellModel] {
        let sortedCells = returnSortedList(by: filtersViewModel.filters.first ?? .descending, cells: expansionCellModels)
        
        if searchText.isEmpty {
            return sortedCells
        } else {
            return sortedCells.filter { $0.cellText.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(cardStore: CardStore) {
        self.cardStore = cardStore
        self.expansionCellModels = [
        ExpansionCellModel(imageName: "base-set", cellText: "Base Set", expansionId: .baseSet, creationDate: self.cardStore.getAverageReleaseDate(for: .baseSet)),
        ExpansionCellModel(imageName: "centaurbor-starter-deck", cellText: "Centaurbor Starter Deck", expansionId: .centaurborStarterDeck, creationDate: self.cardStore.getAverageReleaseDate(for: .centaurborStarterDeck)),
        ExpansionCellModel(imageName: "trifernal-starter-deck", cellText: "Trifernal Starter Deck", expansionId: .trifernalStarterDeck, creationDate: self.cardStore.getAverageReleaseDate(for: .trifernalStarterDeck)),
        ExpansionCellModel(imageName: "majesea-starter-deck", cellText: "Majesea Starter Deck", expansionId: .majeseaStarterDeck, creationDate: self.cardStore.getAverageReleaseDate(for: .majeseaStarterDeck)),
        ExpansionCellModel(imageName: "ohmperial-starter-deck", cellText: "Ohmperial Starter Deck", expansionId: .ohmperialStarterDeck, creationDate: self.cardStore.getAverageReleaseDate(for: .ohmperialStarterDeck)),
        ExpansionCellModel(imageName: "penterror-starter-deck", cellText: "Penterror Starter Deck", expansionId: .penterrorStarterDeck, creationDate: self.cardStore.getAverageReleaseDate(for: .penterrorStarterDeck)),
        ExpansionCellModel(imageName: "artist-collection", cellText: "Artist Collection", expansionId: .artistCollection, creationDate: self.cardStore.getAverageReleaseDate(for: .artistCollection)),
        ExpansionCellModel(imageName: "base-set-promo", cellText: "Base Set Promo Cards", expansionId: .baseSetPromoCards, creationDate: self.cardStore.getAverageReleaseDate(for: .baseSetPromoCards)),
        ExpansionCellModel(imageName: "base-set-promo", cellText: "Prototype Promo Cards", expansionId: .prototypePromoCards, creationDate: self.cardStore.getAverageReleaseDate(for: .prototypePromoCards))
        ]
    }
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(filteredExpansionCellModels) { model in
                            NavigationLink(destination: CollectionView(subset: cardStore.getCards(for: model.expansionId), viewTitle: model.cellText, noResultsText: "We couldn't find any card based on the current filters.")) {
                                ExpansionCellView(model: model)
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                            }
                            .tint(Color.black)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search by Name")
            .autocorrectionDisabled()
            .navigationTitle("Expansions")
            .navigationBarTitleDisplayMode(.automatic)
            .background(Color("backgroundBase"))
            .sheet(isPresented: $presentFilters, content: {
                ExpansionFiltersView(filters: $filtersViewModel.filters)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
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
                })
            }
        }
    }
    
    private func returnSortedList(by: ExpansionFilterType, cells: [ExpansionCellModel]) -> [ExpansionCellModel] {
        switch by {
        case .ascending:
            return cells.sorted { $0.creationDate > $1.creationDate }
        case .descending:
            return cells.sorted { $0.creationDate < $1.creationDate }
        default:
            return cells
        }
    }
}
