//
//  ElestralsCollectionApp.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/29/22.
//

import SwiftUI
import FirebaseCore

@main
struct ElestralsCollectionApp: App {
    @StateObject var elestralsCardData = CardStore()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(elestralsCardData)
        }
    }
}
