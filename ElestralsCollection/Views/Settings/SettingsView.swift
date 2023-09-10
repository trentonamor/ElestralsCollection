import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @State private var isShowingMailView = false
    @State private var isShowingAlert = false
    let mailComposerDelegate = MailComposerDelegate()
    
    var body: some View {
        NavigationView {
            Form {
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
                Section(header: Text("About")) {
                    List {
                        Button(action: {
                            rateApp()
                        }) {
                            Label(title: {
                                Text("Review Caster Companion")
                                    .foregroundColor(.primary)
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
                                    .foregroundColor(.primary)
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
                                    Text("Send us an Email")
                                        .foregroundColor(.primary)
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
                                        .foregroundColor(.primary)
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
                                    .foregroundColor(.primary)
                            }, icon: {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.accentColor)
                            })
                        }
                        .alert(isPresented: $isShowingAlert) {
                            let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "app"
                            return Alert(title: Text("Version \(appVersion)"), message: Text("The Caster Companion app is not owned or operated by Elestrals. This app is entirely fan owned and operated. Any logos, images, or card text are all owned by Elestrals"), dismissButton: .default(Text("OK")))
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
    }
}
