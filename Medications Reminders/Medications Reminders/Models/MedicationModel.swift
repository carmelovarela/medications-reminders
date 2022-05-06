//
//  RegimenModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import FirebaseFirestoreSwift

struct Schedule: Identifiable, Decodable, Hashable, Encodable {
    var id: String
    var hour: Int
    var minute: Int
    var dosage: Double
}

struct Medication: Identifiable, Decodable, Encodable, Hashable {
    @DocumentID var id: String?
    var name: String
    var type: String
    var frequency: [String]
    var howManyTimesADay: Int
    var schedules: [Schedule]
    var uid: String
}

