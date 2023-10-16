import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @State private var isShowingMailView = false
    @State private var isShowingAlert = false
    @State private var isShowingDeleteAlert = false
    @State private var isShowingSubscription = false
    @State private var isShowingIcons = false
    
    @EnvironmentObject var entitlementsManager: EntitlementsManager
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    let mailComposerDelegate = MailComposerDelegate()
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                    Button(action: {
                        self.isShowingSubscription.toggle()
                    }, label: {
                        if !self.entitlementsManager.hasEntitlements {
                            HStack {
                                Text("Subscribe to Caster Pro")
                                    .padding(.vertical, 16)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .bold()
                                Spacer()
                            }
                            .background(content: {
                                ZStack {
                                    Image("WaterBackground")
                                    
                                    LinearGradient(gradient: Gradient(colors: [.clear, Color(.dynamicNavy)]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                }
                            })

                        } else {
                            HStack {
                                Text("You are a Caster Pro Subscriber! 🎉")
                                    .padding(.vertical, 4)
                                    .font(.body)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                Spacer()
                            }
                            .background(content: {
                                ZStack {
                                    Image("WaterBackground")
                                    
                                    LinearGradient(gradient: Gradient(colors: [.clear, Color(.dynamicNavy)]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                }
                            })
                        }
                    })
                    .sheet(isPresented: self.$isShowingSubscription, content: {
                        UpsellView()
                    })
                }
                Section(header: Text("Account").foregroundStyle(Color(.dynamicGrey40))) {
                    List {
                        Button(action: {
                            
                            let dataManager = DataManager(context: self.managedObjectContext)
                            let userId = self.authViewModel.currentUser?.id ?? "-1"
                            Task {
                                try await dataManager.saveCardStoreToFirebase(cardStore: self.cardStore, for: userId)
                                self.authViewModel.signOut()
                                self.cardStore.isLoading = true
                            }
                        }) {
                            Label(title: {
                                Text("Logout")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        }
                        NavigationLink(destination: {
                            ChangePassword()
                                .navigationBarTitleDisplayMode(.inline)
                        }, label: {
                            Label(title: {
                                Text("Change Password")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "person.badge.key")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        })
                        Button(action: {
                            self.isShowingDeleteAlert = true
                        }, label: {
                            Label(title: {
                                Text("Delete Account")
                                    .foregroundStyle(Color(.dynamicRed))
                            }, icon: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color(.dynamicRed))
                            })
                        })
                        .alert(isPresented: $isShowingDeleteAlert, content: {
                            Alert(
                                title: Text("Confirm Account Deletion").foregroundColor(Color(.dynamicGrey80)),
                                message: Text("Are you sure you want to delete your account? This will delete all content and settings.").foregroundColor(Color(.dynamicGrey80)),
                                primaryButton: .destructive(Text("Delete")) {
                                    let dataManager = DataManager(context: self.managedObjectContext)
                                    dataManager.deleteAllCardsAndBookmarks()
                                    Task {
                                        await authViewModel.deleteAccount()
                                        self.cardStore.isLoading = true
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        })
                    }
                }
                .listRowBackground(Color(.backgroundTabBar))
                Section(header: Text("Appearance").foregroundStyle(Color(.dynamicGrey40))) {
                    List {
                        Button(action: {
                            if self.entitlementsManager.hasEntitlements {
                                self.isShowingIcons.toggle()
                            } else {
                                self.isShowingSubscription.toggle()
                            }
                        }) {
                            Label(title: {
                                Text("Customize App Icon")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "apps.iphone")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        }
                        .sheet(isPresented: self.$isShowingIcons, content: {
                            ApplicationIconView()
                        })
                    }
                }
                .listRowBackground(Color(.backgroundTabBar))
                Section(header: Text("About").foregroundStyle(Color(.dynamicGrey40))) {
                    List {
                        Button(action: {
                            rateApp()
                        }) {
                            Label(title: {
                                Text("Review Caster Companion")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "star")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        }
                        
                        Button(action: {
                            guard let url = URL(string: "https://www.elestrals.com/") else { return }
                            openWebpage(url: url)
                        }) {
                            
                            Label(title: {
                                Text("Visit the Official Elestrals Website")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "globe")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        }
                        
                        if MailView.canSendMail() {
                            Button(action: {
                                isShowingMailView = true
                            }) {
                                Label(title: {
                                    Text("Send us Feedback")
                                        .foregroundColor(Color(.dynamicGrey80))
                                }, icon: {
                                    Image(systemName: "paperplane")
                                        .foregroundColor(Color(.dynamicUiBlue))
                                })
                            }
                            .sheet(isPresented: $isShowingMailView) {
                                MailView(isShowingMailView: $isShowingMailView, delegate: mailComposerDelegate)
                            }
                        } else {
                            Button(action: {
                                print("Device cannot send email")
                                
                            }) {
                                Label(title: {
                                    Text("Send us an Email")
                                        .foregroundColor(Color(.dynamicGrey80))
                                }, icon: {
                                    Image(systemName: "paperplane")
                                        .foregroundColor(Color(.dynamicUiBlue))
                                })
                            }
                        }
                        
                        Button(action: {
                            isShowingAlert = true
                        }) {
                            Label(title: {
                                Text("About")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(Color(.dynamicUiBlue))
                            })
                        }
                        /*
                         [YOU APP] is an unofficial, fan-made application that is provided for free, independently of any affiliation, endorsement, or support from Elestrals LLC.

                         Image Usage: Certain images utilized within this application may be copyrighted material, which is used under the principles of fair use.

                         Trademark Acknowledgment: "Elestrals" and associated character names are registered trademarks of Elestrals LLC. Our use of these trademarks is solely for informational and entertainment purposes, with no intention of copyright infringement.

                         [YOUR APP] is an independent creation and should not be misconstrued as endorsed, sponsored, or affiliated with Elestrals LLC.
                         */
                        .alert(isPresented: $isShowingAlert) {
                            let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "app"
                            return Alert(title: Text("Version \(appVersion)"), message: Text("Caster Companion is an unofficial, fan-made application that is provided for free, independently of any affiliation, enodrsement, or support from Elestrals LLC.\n\nImage Usage: Certain images utilized within this application may be copyrighted material, which is used under the principals of fair use.\n\nTrademark Acknowledgement: \"Elestrals\" and associated character names are registered trademarks of Elestrals LLC. Our use of these trademarks is solely for informational and entertainment purposes, with no intention of copyright infringement.\n\nCaster Companion is an independed creation and should not be misconstrued as endoresed, sponsored, or affiliated with Elestrals LLC"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .listRowBackground(Color(.backgroundTabBar))
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(EntitlementsManager())
    }
}
