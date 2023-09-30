//
//  InputView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var showConfirmationField = false
    var isConfirmationValid = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color.black)
                .fontWeight(.semibold)
                .font(.footnote)
            
            HStack {
                if isSecureField && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding(.bottom, 0)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding(.bottom, 0)
                }
                
                if isConfirmationValid && showConfirmationField && !self.text.isEmpty{
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.dynamicGreen))
                } else if !isConfirmationValid && showConfirmationField && !self.text.isEmpty{
                    Image(systemName: "x.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.dynamicRed))
                }

                if isSecureField {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
            }
            
            Divider()
                .padding(.top, 0)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Password", placeholder: "Enter your password", isSecureField: true)
    }
}
