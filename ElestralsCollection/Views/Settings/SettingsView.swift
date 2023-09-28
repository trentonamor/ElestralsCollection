import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @State private var isShowingMailView = false
    @State private var isShowingAlert = false
    @State private var isShowingSubscription = false
    @State private var isShowingIcons = false
    
    @EnvironmentObject var entitlementsManager: EntitlementsManager
    let mailComposerDelegate = MailComposerDelegate()
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                    Button(action: {
                        self.isShowingSubscription.toggle()
                    }, label: {
                        if !self.entitlementsManager.hasEntitlements {
                            Text("Subscribe to Caster Pro")
                                .padding(.vertical, 16)
                                .font(.title2)
                                .foregroundStyle(.white)
                                .bold()
                                .background(content: {
                                    Image("WaterBackground")
                                        .resizable()
                                        .scaledToFill()
                                })
                        } else {
                            Text("You are a Caster Pro Subscriber! 🎉")
                                .padding(.vertical, 4)
                                .font(.body)
                                .foregroundStyle(Color(.dynamicGrey0))
                                .bold()
                                .background(content: {
                                    Image("WaterBackground")
                                        .resizable()
                                        .scaledToFill()
                                })
                        }
                    })
                    .sheet(isPresented: self.$isShowingSubscription, content: {
                        UpsellView()
                    })
                }
                Section(header: Text("Account")) {
                    List {
                        Button(action: {
                            self.logoutUser()
                        }) {
                            Label(title: {
                                Text("Logout")
                                    .foregroundColor(.primary)
                            }, icon: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.accentColor)
                            })
                        }
                        NavigationLink(destination: {
                            ChangePassword()
                                .navigationBarTitleDisplayMode(.inline)
                        }, label: {
                            Label(title: {
                                Text("Change Password")
                                    .foregroundColor(.primary)
                            }, icon: {
                                Image(systemName: "person.badge.key")
                                    .foregroundColor(.accentColor)
                            })
                        })
                    }
                }
                Section(header: Text("Appearance")) {
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
                                    .foregroundColor(.accentColor)
                            })
                        }
                        .sheet(isPresented: self.$isShowingIcons, content: {
                            ApplicationIconView()
                        })
                    }
                }
                Section(header: Text("About")) {
                    List {
                        Button(action: {
                            rateApp()
                        }) {
                            Label(title: {
                                Text("Review Caster Companion")
                                    .foregroundColor(Color(.dynamicGrey80))
                            }, icon: {
                                Image(systemName: "star")
                                    .foregroundColor(.accentColor)
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
                                    .foregroundColor(.accentColor)
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
                                        .foregroundColor(.accentColor)
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
                                        .foregroundColor(.accentColor)
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
                                    .foregroundColor(.accentColor)
                            })
                        }
                        .alert(isPresented: $isShowingAlert) {
                            let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "app"
                            return Alert(title: Text("Version \(appVersion)"), message: Text("The Caster Compendium app is not owned or operated by Elestrals. This app is entirely fan owned and operated. Any logos, images, or card text are all owned by Elestrals"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
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
