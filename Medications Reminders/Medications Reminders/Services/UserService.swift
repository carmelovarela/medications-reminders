//
//  UserService.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }

                guard let user = try? snapshot.data(as: User.self)
                else {
                    return
                }
                                
                completion(user)
            }
    }
}


