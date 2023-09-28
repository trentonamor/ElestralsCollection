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
        self.userSession = Auth.auth().currentUser
        
        Task {
            await self.fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
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
    
    func deleteAccount() {
        do {
            guard let user = Auth.auth().currentUser else { return }
            user.delete()
            self.userSession = nil
            self.currentUser = nil
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
    
    func reauthenticateUser(currentPassword: String) async throws {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: self.currentUser?.email ?? "", password: currentPassword)
        
        try await user?.reauthenticate(with: credential)
    }

}
