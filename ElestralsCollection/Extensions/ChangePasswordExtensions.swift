//
//  ChangePasswordExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import Foundation

extension ChangePassword {
    func savePassword() async throws {
        
    }
}

extension ChangePassword: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return self.requirementsViewModel.meetsRequirements()
        && !self.currentPassword.isEmpty
        && self.newPassword == self.confirmPassword
    }
}
