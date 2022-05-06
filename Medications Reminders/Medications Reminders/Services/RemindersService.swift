//
//  RemindersService.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 03/04/2022.
//

import Firebase
import FirebaseFirestoreSwift

struct RemindersService {
    func fetchReminders(forUid uid: String, completion: @escaping([Reminder]) -> Void) {
        Firestore.firestore().collection("reminders")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }

                let reminders = documents.compactMap({
                    try? $0.data(as: Reminder.self)
                })

                completion(reminders)
            }
    }
}

