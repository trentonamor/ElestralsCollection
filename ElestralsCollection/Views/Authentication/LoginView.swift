//
//  LoginView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("StoneSquare")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                // Form Fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email", placeholder: "yourEmail@email.com")
                        .textInputAutocapitalization(.never)
                    InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)
                // Sign In Button
                Button(action: {
                    print("Sign user in")
                }, label: {
                    HStack {
                        Text("SIGN IN")
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
                
                // Sign Up Button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
