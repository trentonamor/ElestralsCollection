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
                    .foregroundColor(.black)
                Spacer()
                if configuration.isOn {
                    Image(systemName: "checkmark")
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

/*
 return HStack {
     configuration.label
     Spacer()
     Image(systemName: configuration.isOn ? "checkmark.square" : "square")
         .resizable()
         .frame(width: 22, height: 22)
         .onTapGesture { configuration.isOn.toggle() }
 }
 */
