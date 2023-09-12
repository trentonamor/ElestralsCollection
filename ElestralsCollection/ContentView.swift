import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    @State private var selectedTab = 0
    @EnvironmentObject var cardStore: CardStore
    
    var body: some View {
        if cardStore.isLoading {
            ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            TabView(selection: $selectedTab) {
                ElestralsView()
                    .tabItem {
                        Image(systemName: "book.closed")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Elestrals")
                    }
                    .tag(0)
                ExpansionsView(cardStore: cardStore)
                    .tabItem {
                        Image(systemName: "list.bullet.below.rectangle")
                        Text("Expansions")
                    }
                    .tag(1)
                CollectionView(subset: self.cardStore.getCards(for: true))
                    .tabItem {
                        Image(systemName: "archivebox")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("My Collection")
                    }
                    .tag(2)
                //            BookmarkView()
                //                .tabItem {
                //                    Image(systemName: "bookmark")
                //                    Text("Bookmarks")
                //                }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(3)
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                            .environment(\.symbolVariants, .none)
                        Text("Settings")
                    }
                    .tag(4)
            }
        }
    }
}

//struct ContentViewPreview: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(ElestralData())
//    }
//}
