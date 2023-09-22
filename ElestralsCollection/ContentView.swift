import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    @State private var selectedTab = 0
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        if cardStore.isLoading {
            VStack(alignment: .center) {
                Image("Launch")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .scaledToFill()
            }
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
                CollectionTabView()
                    .tabItem {
                        Image(systemName: "archivebox")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
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
            .onAppear {
                self.cardStore.setBookmarks(context: self.managedObjectContext)
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
