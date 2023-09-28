//
//  ApplicationIconView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import SwiftUI

struct ApplicationIconView: View {
    @State private var selectedIcon: String? = UIApplication.shared.alternateIconName

    var body: some View {
        NavigationStack {
            List {
                iconButton(iconName: "AlternativeIcon3Dupe", displayName: "Blue")
                iconButton(iconName: "AlternateIcon1Dupe", displayName: "White")
                iconButton(iconName: "AlternateIcon2Dupe", displayName: "Black")
            }
            .background(Color(.backgroundBase))
            .navigationTitle("Application Icon")
            .onAppear {
                // When the view appears, set the selected icon to the current app icon
                selectedIcon = "\(UIApplication.shared.alternateIconName ?? "AlternativeIcon3")Dupe"
            }
        }
    }

    private func iconButton(iconName: String, displayName: String) -> some View {
        Button(action: {
            var name = iconName
            name.removeLast(4)
            changeAppIcon(to: name)
        }, label: {
            HStack {
                Image(iconName)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 57, height: 57)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                Text(displayName)
                    .foregroundStyle(Color(.dynamicGrey80))
                    .bold()
                Spacer()
                if iconName == selectedIcon {
                    Image(systemName: "checkmark")
                }
            }
        })
    }

    private func changeAppIcon(to iconName: String) {
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting alternate icon \(error.localizedDescription)")
            } else {
                // Successfully changed the icon, so update the state
                self.selectedIcon = "\(iconName)Dupe"
            }
        }
    }
}


#Preview {
    ApplicationIconView()
}
