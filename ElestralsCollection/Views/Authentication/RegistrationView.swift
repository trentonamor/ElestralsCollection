//
//  RegistrationView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var fullName = ""
    @State var password = ""
    @State var confirmedPassword = ""
    @State var isSigningIn: Bool = false
    @StateObject var requirementsViewModel = MinimumRequirementsViewModel()
    @State private var passwordStrength: PasswordStrength = .weak
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
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
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmedPassword, title: "Confirm Password", placeholder: "Confirm Your Password", isSecureField: true)
                            .textInputAutocapitalization(.never)
                        
                        if !password.isEmpty && !confirmedPassword.isEmpty {
                            if password == confirmedPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.dynamicGreen))
                            } else {
                                Image(systemName: "x.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.dynamicRed))
                            }
                        }
                    }
                    
                    PasswordStrengthMeter(passwordStrength: passwordStrength)
                    
                    MinimumRequirementsView()
                        .environmentObject(requirementsViewModel)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button(action: {
                    self.isSigningIn = true
                    Task {
                        try await viewModel.createUser(withEmail: email, password:password, fullname:fullName)
                        self.isSigningIn = false
                    }
                }, label: {
                    HStack {
                        if !self.isSigningIn {
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
