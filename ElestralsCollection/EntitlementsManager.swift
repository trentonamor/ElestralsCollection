//
//  EntitlementsManager.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import Foundation
import RevenueCat

class EntitlementsManager: ObservableObject {
    @Published var hasEntitlements: Bool = false
    
    init() {
        fetchEntitlements()
    }
    
    func fetchEntitlements() {
        Purchases.shared.getCustomerInfo() { info, error in
            guard let info = info, error == nil else { return }
            
            DispatchQueue.main.async {
                self.hasEntitlements = info.entitlements.all["Pro"]?.isActive == true
            }
        }
    }
}
