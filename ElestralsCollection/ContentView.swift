import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    @State private var selectedTab = 0
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        if authViewModel.userSession == nil {
            LoginView()
                .onAppear(perform: {
                    self.selectedTab = 0
                })
        } else if cardStore.isLoading {
            VStack(alignment: .center) {
                Image("Launch")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .scaledToFill()
            }
            .onAppear(perform: {
                Task {
                    do {
                        try await self.authViewModel.fetchUser()
                        await self.cardStore.setup(userId: self.authViewModel.currentUser?.id ?? "", context: self.managedObjectContext)
                    } catch {
                        print("DEDBUG: Failed to fetch user")
                    }
                }
            })
        } else if cardStore.errorOccurred {
            VStack {
                Text("Failed to load data. Please try again.")
                    .padding()
                Button(action: {
                    cardStore.errorOccurred = false
                    cardStore.isLoading = true
                    Task {
                        do {
                            try await self.authViewModel.fetchUser()
                            await self.cardStore.setup(userId: self.authViewModel.currentUser?.id ?? "", context: self.managedObjectContext)
                        } catch {
                            self.authViewModel.signOut()
                        }
                    }
                }) {
                    Text("Retry")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    cardStore.errorOccurred = false
                    cardStore.isLoading = true
                    Task {
                        do {
                            try await self.authViewModel.fetchUser()
                            await self.cardStore.setup(userId: self.authViewModel.currentUser?.id ?? "", context: self.managedObjectContext)
                        } catch {
                            self.authViewModel.signOut()
                        }
                    }
                }) {
                    Text("Sign Out")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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
