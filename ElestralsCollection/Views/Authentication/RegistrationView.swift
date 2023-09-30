//
//  RegistrationView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct RegistrationView: View {
    @State var currentAlertType: AuthError = .none
    @State var email = ""
    @State var fullName = ""
    @State var password = ""
    @State var confirmedPassword = ""
    @State var isSigningUp: Bool = false
    @State var displayAlert: Bool = false
    @StateObject var requirementsViewModel = MinimumRequirementsViewModel()
    @State private var passwordStrength: PasswordStrength = .weak
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Image("StoneSquare")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 16)
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email", placeholder: "yourEmail@email.com")
                        .textInputAutocapitalization(.never)
                    InputView(text: $fullName, title: "Full Name", placeholder: "Enter Your Name")
                        .textInputAutocapitalization(.words)
                    InputView(text: $password, title: "Password", placeholder: "Enter Your Password", isSecureField: true)
                        .textInputAutocapitalization(.never)
                        .onChange(of: password) { newValue in
                            requirementsViewModel.password = newValue
                            passwordStrength = PasswordStrengthViewModel.calculateStrength(password: newValue)
                        }
                    InputView(text: $confirmedPassword, title: "Confirm Password", placeholder: "Confirm Your Password", isSecureField: true, showConfirmationField: true, isConfirmationValid: (self.confirmedPassword == self.password) && !self.confirmedPassword.isEmpty)
                        .textInputAutocapitalization(.never)
                    
                    PasswordStrengthMeter(passwordStrength: passwordStrength)
                    
                    MinimumRequirementsView()
                        .environmentObject(requirementsViewModel)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button(action: {
                    self.isSigningUp = true
                    Task {
                        do {
                            try await authViewModel.createUser(withEmail: email, password: password, fullname: fullName)
                            self.currentAlertType = .verifyEmail
                            self.displayAlert = true
                        } catch let error as AuthError {
                            switch error {
                            case .emailAlreadyInUse:
                                self.currentAlertType = .emailAlreadyInUse
                                self.displayAlert = true
                            case .other(let originalError):
                                print("DEBUG: Failed with error \(originalError.localizedDescription)")
                            default:
                                print("Error not caught")
                            }
                        }
                        self.isSigningUp = false
                    }
                }, label: {
                    HStack {
                        if !self.isSigningUp {
                            Text("SIGN UP")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        } else {
                            ProgressView()
                                .foregroundColor(Color(.dynamicGrey0))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width:UIScreen.screenWidth - 32,height:48 )
                })
                .opacity(self.requirementsViewModel.meetsRequirements() ? 1.0 : 0.5)
                .disabled(!self.formIsValid)
                .background(Color(.dynamicUiBlue)
                    .opacity(self.formIsValid ? 1.0 : 0.5))
                .cornerRadius(10)
                .padding(.top, 24)
                .alert(isPresented: self.$displayAlert, content: {
                    switch self.currentAlertType {
                    case .verifyEmail:
                        return Alert(title: Text("Verify Your Email"),
                                             message: Text("Please check your inbox and verify your email before signing in."),
                                             dismissButton: .default({
                            Text("Ok")
                        }(), action: {
                            dismiss()
                        }))
                    case .emailAlreadyInUse:
                        return Alert(title: Text("Cannot Create User"),
                                             message: Text("A user with this email already exists."),
                                             primaryButton: .default(Text("Forgot Password"), action: {
                                                 Task {
                                                     try await self.authViewModel.resetPassword(email: self.email)
                                                 }
                                             }),
                                             secondaryButton: .cancel(Text("Try Again Later")))
                    case .other(let error):
                        return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                    case .none:
                        return Alert(title: Text("Unkown Error Occurred"))
                    }
                })
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                })
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
