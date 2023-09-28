//
//  UpsellViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import Foundation
import RevenueCat

extension UpsellView {
    
    func fetchPackage(completion: @escaping (Package) -> Void) {
        Purchases.shared.getOfferings(completion: { offerings, error in
            guard let offerings = offerings, error == nil else { return }
            
            guard let package = offerings.all.first?.value.availablePackages[self.index] else {
                return
            }
            
            completion(package)
        })
    }
    
    func purchase() {
        self.fetchPackage(completion: { [self] package in
            self.purchase(package: package)
        })
    }
    
    private func purchase(package: Package) {
        Purchases.shared.purchase(package: package, completion: { transaction, info, error, userCancelled in
            guard let _ = transaction,
                  let _ = info,
                  error == nil, !userCancelled else {
                return
            }
        })
    }
    
    func restorePurchases() {
        Purchases.shared.restorePurchases(completion: { info, error in
            guard let info = info, error == nil else { return }
            
            DispatchQueue.main.async {
                self.setHiddenState(info: info)
            }
        })
    }
    
    func getUserSubscriptionState() {
        Purchases.shared.getCustomerInfo() { info, error in
            guard let info = info, error == nil else { return }
            
            DispatchQueue.main.async {
                self.setHiddenState(info: info)
            }
        }
    }
    
    private func setHiddenState(info: CustomerInfo) {
        if info.entitlements.all["Pro"]?.isActive == true {
            self.userIsSubscribed = true
        } else {
            self.userIsSubscribed = false
        }
    }
}
