//
//  ElestralsCollectionApp.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/29/22.
//

import SwiftUI
import FirebaseCore
import RevenueCat

@main
struct ElestralsCollectionApp: App {
    @StateObject var elestralsCardData = CardStore()
    @StateObject var entitlementsManager = EntitlementsManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        FirebaseApp.configure()
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_fptHqUwZQNGfxGoHPaqevgdVgqM")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(elestralsCardData)
                .environmentObject(entitlementsManager)
                .environment(\.managedObjectContext, appDelegate.persistentContainer.viewContext)
                .environment(\.colorScheme, .light)
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                // App is in the background
                appDelegate.saveContext()
            case .inactive:
                // App is about to become inactive (e.g., going to the background)
                appDelegate.saveContext()
            case .active:
                // App is active
                break
            @unknown default:
                // Handle any future cases
                break
            }
        }
    }
}
