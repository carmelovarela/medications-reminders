//
//  UserModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    var email: String
    var name: String
}

