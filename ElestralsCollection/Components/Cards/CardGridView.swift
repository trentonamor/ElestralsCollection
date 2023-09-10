import SwiftUI

struct CardGridView: View {
    let title: String
    let subset: [ElestralCard]
    let searchText: Binding<String>
    let presentFilters: Binding<Bool>
    @ObservedObject var filtersViewModel: CollectionFiltersViewModel
    let layout: [GridItem]
    let selectedCard: Binding<ElestralCard?>
    
    @State private var currentImageLoaded: String = ""

    private var filteredCards: [ElestralCard] {
            let sortOrder = filtersViewModel.sortOrder
            let sortBy = filtersViewModel.sortBy
            let cardState = filtersViewModel.cardState
            let cardType = filtersViewModel.cardType
            let elestralElement = filtersViewModel.elestralElement
            let rarity = filtersViewModel.rarity

            var filtered = subset.filter { card in
                let cardStateMatch = cardState.contains(where: { filter in
                    switch filter {
                    case .both:
                        return true
                    case .ownedOnly:
                        return card.numberOwned > 0
                    case .moreThan1OwnedOnly:
                        return card.numberOwned > 1
                    case .unowned:
                        return card.numberOwned == 0
                    default:
                        return false
                    }
                })
                let cardTypeMatch = cardType.contains(where: { filter in
                    switch filter {
                    case .elestral:
                        return card.cardType == "Elestral"
                    case .spirit:
                        return card.cardType == "Spirit"
                    case .rune:
                        return card.cardType == "Rune"
                    default:
                        return false
                    }
                })
                let elestralElementMatch = elestralElement.contains(where: { filter in
                    switch filter {
                    case .earth:
                        return card.elements.contains("earth")
                    case .fire:
                        return card.elements.contains("fire")
                    case .thunder:
                        return card.elements.contains("thunder")
                    case .water:
                        return card.elements.contains("water")
                    case .wind:
                        return card.elements.contains("wind")
                    default:
                        return false
                    }
                }) || card.elements.contains("rainbow")

                let rarityMatch = rarity.first(where: { filter in
                    switch filter {
                    case .fullArt:
                        return card.rarity == "full-art"
                    case .common:
                        return card.rarity == "common"
                    case .rare:
                        return card.rarity == "rare"
                    case .uncommon:
                        return card.rarity == "uncommon"
                    case .holoRare:
                        return card.rarity == "holo-rare"
                    case .stellarRare:
                        return card.rarity == "stellar-rare"
                    case .alternativeArt:
                        return card.rarity == "alternative-art"
                    default:
                        return false
                    }
                }) != nil

                let isMatch = cardStateMatch && cardTypeMatch && elestralElementMatch && rarityMatch

                return isMatch
            }

        if !searchText.wrappedValue.isEmpty {
            let lowercasedSearchText = searchText.wrappedValue.lowercased()
            filtered = filtered.filter { card in
                card.name.lowercased().contains(lowercasedSearchText) ||
                card.artist.lowercased().contains(lowercasedSearchText) ||
                card.cardNumber.lowercased().contains(lowercasedSearchText)
            }
        }

            filtered.sort { (card1, card2) -> Bool in
                switch sortBy.first {
                case .releaseDate:
                    return sortOrder.contains(.ascending) ? card1.publishedDate < card2.publishedDate : card1.publishedDate > card2.publishedDate
                case .name:
                    return sortOrder.contains(.ascending) ? card1.name < card2.name : card1.name > card2.name
                case .artist:
                    return sortOrder.contains(.ascending) ? card1.artist < card2.artist : card1.artist > card2.artist
                default:
                    return false
                }
            }

            return filtered
        }

    var body: some View {
        ZStack {
            if filteredCards.isEmpty {
                Text("No Cards found, start collecting to see cards appear here!")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(filteredCards, id: \.self) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    selectedCard.wrappedValue = card
                                }
                        }
                    }
                }
                .searchable(text: searchText, placement: .toolbar, prompt: "Search by Name, Artist, or Id")
                .autocorrectionDisabled()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.automatic)
        .padding([.top, .horizontal])
        .background(Color("backgroundBase"))
    }
}