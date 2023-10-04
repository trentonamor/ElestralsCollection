import SwiftUI

struct ElestralsGridItem: View {
    @ObservedObject var data: ElestralCard
    @EnvironmentObject var cardStore: CardStore

    var body: some View {
        NavigationLink(destination: CollectionView(subset: self.cardStore.getCards(for: data.name), viewTitle: data.name, noResultsText: "We couldn't find any card based on your current filters.")) {
            ZStack {
                let isOwned = cardStore.getTotalOwned(for: data.name) == 0
                Rectangle()
                    .fill(Gradient(colors: [Color(.backgroundElevated), data.getBackgroundColor(isColor: isOwned)]))
                    .cornerRadius(30)
                    .aspectRatio(1, contentMode: .fit)
                VStack {
                    Spacer()
                    ZStack {
                        Image(data.getSprite())
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 0.0)
                        if isOwned {
                            Color(.dynamicGrey40)
                                .blendMode(.color)
                        }
                    }
                    Text(data.name)
                        .font(.footnote)
                        .bold()
                        .padding(.top, 0.0)
                        .padding([.bottom, .horizontal])
                        .foregroundColor(Color(.dynamicGrey80))
                }
                .aspectRatio(1, contentMode: .fill)
            }
        }
    }
}
