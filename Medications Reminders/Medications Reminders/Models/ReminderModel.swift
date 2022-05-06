//
//  ReminderModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 03/04/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Reminder: Identifiable, Decodable, Encodable, Hashable {
    @DocumentID var id: String?
    var name: String
    var type: String
    var mid: String
    var uid: String
    var sid: String
    var completed: Bool
    var dosage: Double
    var time: Date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd 'of' MMMM"
        return formatter.string(from: time)
    }
}

