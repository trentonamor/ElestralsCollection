//
//  LoginView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct LoginView: View {
    @State var authError: AuthError = .none
    @State var email: String = ""
    @State var password: String = ""
    @State var isSigningIn: Bool = false
    @State var isShowingAlert: Bool = false
    @State var didCompleteForgotPassword: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var cardStore: CardStore
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
                //Reset Button
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            try await self.authViewModel.resetPassword(email: self.email)
                            self.didCompleteForgotPassword = true
                        }
                        
                    }, label: {
                        Text("Forgot Password?")
                    })
                    .alert(isPresented: self.$didCompleteForgotPassword, content: {
                        Alert(title: Text("Email Sent"), message: Text("Check your inbox to reset your password"))
                    })
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Sign In Button
                Button(action: {
                    isSigningIn = true
                    Task {
                        do {
                            try await authViewModel.signIn(withEmail: email, password: password)
                            isSigningIn = false
                        } catch let error as AuthError {
                            switch error {
                            case .verifyEmail:
                                self.authError = error
                                self.isShowingAlert = true
                            default:
                                self.authError = .other(error)
                                self.isShowingAlert = true
                                
                            }
                            isSigningIn = false
                        }
                        
                    }
                }, label: {
                    if !self.isSigningIn {
                        HStack {
                            Spacer()
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                            Spacer()
                        }
                        .foregroundColor(Color(.dynamicGrey0))
                        .frame(maxWidth: .infinity, minHeight: 55)
                    } else {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 55)
                    }
                })
                .background(Color(.dynamicUiBlue)
                    .opacity(formIsValid ? 1.0 : 0.5))
                .cornerRadius(10)
                .padding(.top)
                .padding(.horizontal)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .alert(isPresented: $isShowingAlert, content: {
                    switch self.authError {
                    case .verifyEmail:
                        return Alert(title: Text("Verify Email"), message: Text("Your email must be verified before you can sign in."))
                    default:
                        return Alert(title: Text("Error Logging In"),
                              message: Text("An account with that email and password could not be found. Or email has not been verified. Please try again."),
                              dismissButton: .default(Text("OK")))
                        
                    }
                })
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
