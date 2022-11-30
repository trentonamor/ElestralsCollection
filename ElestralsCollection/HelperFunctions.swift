//
//  HelperFunctions.swift
//
//
//  Created by Trenton Parrotte on 11/29/22.
//

import Foundation

extension ElestralsView {
    func getNumberOwned(for element: Element) -> Int {
        let list = self.data.elestralsList.filter {
                $0.element == element &&
                $0.isOwned
            }
            return list.count
        }
}

extension ElestralsGridItem {
    func updateOwned(for elestral: Elestral) {
        let index = self.data.elestralsList.firstIndex(where: { $0.name == elestral.name })
        self.data.elestralsList[index!].isOwned = elestral.isOwned
    }
}
