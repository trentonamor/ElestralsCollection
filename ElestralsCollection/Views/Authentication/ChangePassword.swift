//
//  ChangePassword.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct ChangePassword: View {
    @State var showInvalidCredentials: Bool = false
    @State var showServerError: Bool = false
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    @StateObject var requirementsViewModel = MinimumRequirementsViewModel()
    @State private var passwordStrength: PasswordStrength = .weak
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                InputView(text: $currentPassword, title: "Current Password", placeholder: "Enter Your Current Password", isSecureField: true)
                    .textInputAutocapitalization(.never)
                InputView(text: $newPassword, title: "New Password", placeholder: "Enter Your New Password", isSecureField: true)
                    .textInputAutocapitalization(.never)
                    .onChange(of: newPassword) { newValue in
                        requirementsViewModel.password = newValue
                        passwordStrength = PasswordStrengthViewModel.calculateStrength(password: newValue)
                    }
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm Your New Password", isSecureField: true, showConfirmationField: true, isConfirmationValid: (self.confirmPassword == self.newPassword) && !self.confirmPassword.isEmpty)
                    .textInputAutocapitalization(.never)
                
                PasswordStrengthMeter(passwordStrength: passwordStrength)
                
                MinimumRequirementsView()
                    .environmentObject(requirementsViewModel)
                    .alert(isPresented: self.$showServerError, content: {
                        Alert(title: Text("Server Error"), message: Text("There was a problem updating your password. Try again later."))
                    })
            }
            .padding(.horizontal)
            .alert(isPresented: self.$showInvalidCredentials, content: {
                Alert(title: Text("Invalid Credentials"), message: Text("The current password is incorrect"))
            })
            
            Spacer()
        }
        .navigationTitle("Password")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    Task {
                        do {
                            try await self.authViewModel.reauthenticateUser(currentPassword: self.currentPassword)
                        } catch {
                            self.showInvalidCredentials = true
                        }
                        do {
                            try await self.authViewModel.updatePassword(newPassword: self.newPassword)
                            dismiss()
                        } catch {
                            self.showServerError = true
                        }
                    }
                }, label: {
                    Text("Save")
                })
                .disabled(!self.formIsValid)
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

