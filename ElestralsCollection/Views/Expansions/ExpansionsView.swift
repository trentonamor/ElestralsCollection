import SwiftUI

struct ExpansionsView: View {
    @State var searchText = ""
    @State var presentFilters = false
    
    @ObservedObject var filtersViewModel: ExpansionFiltersViewModel =
        ExpansionFiltersViewModel()
    
    let expansionCellModels: [ExpansionCellModel] = [
        ExpansionCellModel(imageName: "base-set", cellText: "Base Set", expansionId: .baseSet, creationDate: "01/01/2022".toDate()),
        ExpansionCellModel(imageName: "centaurbor-starter-deck", cellText: "Centaurbor Starter Deck", expansionId: .centaurborStarterDeck, creationDate: "02/01/2022".toDate()),
        ExpansionCellModel(imageName: "trifernal-starter-deck", cellText: "Trifernal Starter Deck", expansionId: .trifernalStarterDeck, creationDate: "02/01/2022".toDate()),
        ExpansionCellModel(imageName: "majesea-starter-deck", cellText: "Majesea Starter Deck", expansionId: .majeseaStarterDeck, creationDate: "02/01/2022".toDate()),
        ExpansionCellModel(imageName: "ohmperial-starter-deck", cellText: "Ohmperial Starter Deck", expansionId: .ohmperialStarterDeck, creationDate: "02/01/2022".toDate()),
        ExpansionCellModel(imageName: "penterror-starter-deck", cellText: "Penterror Starter Deck", expansionId: .penterrorStarterDeck, creationDate: "02/01/2022".toDate()),
        ExpansionCellModel(imageName: "artist-collection", cellText: "Artist Collection", expansionId: .artistCollection, creationDate: "04/01/2022".toDate()),
        ExpansionCellModel(imageName: "base-set-promo", cellText: "Base Set Promo Cards", expansionId: .baseSetPromoCards, creationDate: "04/01/2022".toDate())
    ]
    
    var filteredExpansionCellModels: [ExpansionCellModel] {
        let sortedCells = returnSortedList(by: filtersViewModel.filters.first ?? .Descending, cells: expansionCellModels)
        
        if searchText.isEmpty {
            return sortedCells
        } else {
            return sortedCells.filter { $0.cellText.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(filteredExpansionCellModels) { model in
                            Button(action: {
                                print("tappy")
                            }) {
                                ExpansionCellView(model: model)
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                            }
                            .tint(Color.black)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search by Name")
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
        case .Ascending:
            return cells.sorted { $0.creationDate > $1.creationDate }
        case .Descending:
            return cells.sorted { $0.creationDate < $1.creationDate }
        default:
            return cells
        }
    }
}


struct ExpansionViewPreview: PreviewProvider {
    static var previews: some View {
        ExpansionsView()
    }
}
