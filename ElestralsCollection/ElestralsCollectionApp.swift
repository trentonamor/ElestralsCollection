//
//  ElestralsCollectionApp.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/29/22.
//

import SwiftUI

@main
struct ElestralsCollectionApp: App {
    @StateObject var elestralsList = ElestralData()
    @StateObject var elestralsCardData = ElestralCardData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(elestralsList)
                .environmentObject(elestralsCardData)
        }
    }
}
