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
    @StateObject private var requirementsViewModel = MinimumRequirementsViewModel()
    @State private var passwordStrength: PasswordStrength = .weak
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("StoneSquare")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
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
                InputView(text: $confirmedPassword, title: "Confirm Password", placeholder: "Confirm Your Password", isSecureField: true)
                    .textInputAutocapitalization(.never)
                
                PasswordStrengthMeter(passwordStrength: passwordStrength)
                
                MinimumRequirementsView()
                    .environmentObject(requirementsViewModel)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button(action: {
                print("Sign user up")
            }, label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width:UIScreen.screenWidth - 32,height:48 )
            })
            .background(Color(.systemBlue))
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
