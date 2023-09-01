//
//  HiddenNavigationBar.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/1/23.
//

import Foundation
import SwiftUI

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}
