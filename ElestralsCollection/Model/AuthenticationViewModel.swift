//
//  AuthenticationModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/28/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        guard let user = Auth.auth().currentUser else {
            self.signOut()
            return
        }
        if user.isEmailVerified {
            self.userSession = user
        }
        
        Task {
            await self.fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Check if email is verified
            guard result.user.isEmailVerified else {
                throw AuthError.verifyEmail
            }
            self.userSession = result.user
            await fetchUser()
        } catch let error as NSError {
            print("DEBUG: Error signing in with \(error.localizedDescription)")
            throw AuthError.other(error)
        }
            
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Send verification email
            try await result.user.sendEmailVerification()
            
            // Set the display name for the user
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = fullname
            try await changeRequest.commitChanges()
            
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            try Auth.auth().signOut()
        } catch let error as NSError {
            if error.domain == AuthErrorDomain && error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                throw AuthError.emailAlreadyInUse
            } else {
                throw AuthError.other(error)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userDocumentRef = db.collection("users").document(user.uid)
        
        do {
            // Delete user from Firebase Auth
            try await user.delete()
            // Delete user's document from Firestore
            try await userDocumentRef.delete()
            
            self.userSession = nil
            self.currentUser = nil
            
        } catch let error {
            print("Error deleting account: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("DEBUG: Failed to retrieve user with error \(error.localizedDescription)")
        }
    }
    
    func updatePassword(newPassword: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Could not send email to \(email)")
        }
    }
    
    func reauthenticateUser(currentPassword: String) async throws {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: self.currentUser?.email ?? "", password: currentPassword)
        
        try await user?.reauthenticate(with: credential)
    }
    
}
