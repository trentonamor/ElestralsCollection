//
//  ChangePassword.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct ChangePassword: View {
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    @StateObject private var requirementsViewModel = MinimumRequirementsViewModel()
    @State private var passwordStrength: PasswordStrength = .weak
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                InputView(text: $currentPassword, title: "Current Password", placeholder: "Enter Your Current Password")
                    .textInputAutocapitalization(.never)
                InputView(text: $newPassword, title: "New Password", placeholder: "Enter Your New Password")
                    .textInputAutocapitalization(.never)
                    .onChange(of: newPassword) { newValue in
                        requirementsViewModel.password = newValue
                        passwordStrength = PasswordStrengthViewModel.calculateStrength(password: newValue)
                    }
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm Your New Password", isSecureField: true)
                    .textInputAutocapitalization(.never)
                
                PasswordStrengthMeter(passwordStrength: passwordStrength)
                
                MinimumRequirementsView()
                    .environmentObject(requirementsViewModel)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Password")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    self.savePassword()
                }, label: {
                    Text("Save")
                })
            })
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            })
        }
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}

