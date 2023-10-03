//
//  Toggle+CheckboxStyle.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import Foundation
import SwiftUI

struct ToggleCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                configuration.label
                    .foregroundStyle(Color(.dynamicGrey80))
                Spacer()
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color(.dynamicUiBlue))
                } else {
                    Spacer()
                }
            }
        })
    }
}

extension ToggleStyle where Self == ToggleCheckboxStyle {
    static var checklist: ToggleCheckboxStyle { .init() }
}
