//
//  LoginViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/28/23.
//

import Foundation
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
        && !self.isSigningIn
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && self.requirementsViewModel.meetsRequirements()
        && confirmedPassword == password
        && !fullName.isEmpty
        && !self.isSigningIn
    }
}
