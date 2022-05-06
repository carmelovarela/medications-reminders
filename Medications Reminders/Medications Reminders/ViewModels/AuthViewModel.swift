//
//  AuthViewModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    let auth = Auth.auth()
    
    @Published var id = ""
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published private var _currentUser : User? = nil
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    
    private let service = UserService()
    
    var currentUser: User {
        return _currentUser ?? User(id: "", email: "", name: "")
    }
    
    init() {
        handler = auth.addStateDidChangeListener{ auth, user in
            if let user = user {
                self.fetchUser(uid: user.uid)
                self.isLoggedIn = true
            } else {
                self._currentUser = nil
                self.isLoggedIn = false
            }
        }
        
    }
    
    func signIn() async {
        hasError = false
        do{
            try await auth.signIn(withEmail: email, password: password)
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() async {
        hasError = false
        do{
            try auth.signOut()
            
            email = ""
            name = ""
            password = ""
            
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
        
    }
    
    func signUp() async {
        hasError = false
        do{
            try await auth.createUser(withEmail: email, password: password)
            
            let userID = Auth.auth().currentUser!.uid

            let data = [
                "email": email,
                "name": name,
                "uid": userID
            ]

            try await Firestore.firestore().collection("users")
                .document(userID)
                .setData(data as [String : Any])
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchUser(uid: String) {
        service.fetchUser(withUid: uid) { user in
            self._currentUser = user
        }
    }
    
    deinit {
        auth.removeStateDidChangeListener(handler)
    }
}

