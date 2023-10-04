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
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .foregroundColor(Color(.dynamicGrey80))
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                
                HStack {
                    if isSecureField && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.dynamicGrey80))
                            .padding(.bottom, 4)
                    } else {
                        TextField(placeholder, text: $text)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.dynamicGrey80))
                            .padding(.bottom, 4)
                    }
                    
                    
                }
                .padding(.horizontal, 8)
                
            }
            if isSecureField {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color(.dynamicGrey40))
                }
                .padding(8)
            }
        }
        .background(Color(.backgroundRecessed))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(showConfirmationField && !text.isEmpty ? (isConfirmationValid ? Color(.dynamicGreen) : Color(.dynamicRed)) : Color.clear, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Password", placeholder: "Enter your password", isSecureField: true)
    }
}
