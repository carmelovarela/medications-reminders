//
//  RegimenService.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import Firebase
import FirebaseFirestoreSwift

struct MedicationService {
    func StringifySchedules(schedules: [Schedule]) -> [Any] {
        var arr = [Any]()
        
        for i in schedules {
            let schedule = [
                "id": i.id,
                "hour": i.hour,
                "minute": i.minute,
                "dosage": i.dosage
            ] as [String : Any]
            
            arr.append(schedule)
            
        }
        
        return arr
    }
    
    func GetWeekday(weekday: String) -> Int {
        var weekdayComponent = 1
        
        switch weekday {
            case "Sunday":
                weekdayComponent = 1
            case "Monday":
                weekdayComponent = 2
            case "Tuesday":
                weekdayComponent = 3
            case "Wednesday":
                weekdayComponent = 4
            case "Thursday":
                weekdayComponent = 5
            case "Friday":
                weekdayComponent = 6
            case "Saturday":
                weekdayComponent = 7
            default:
                weekdayComponent = 0
        }
        
        return weekdayComponent
    }
    
    func GenerateReminders(weeks: Int, mid: String, medication: Medication) {
        let today = Date()
        let frequency = medication.frequency
        let schedules = medication.schedules

        for d in 0...weeks  {
            let tomorrow = Calendar.current.date(byAdding: .weekOfYear, value: d, to: today)

            for f in frequency {
                // Set days
                let withDay = Calendar.current.date(bySetting: .weekday, value: GetWeekday(weekday: f), of: tomorrow!)!
                for t in 0...schedules.count - 1 {
                    // Set times
                    let withTime = Calendar.current.date(bySettingHour: schedules[t].hour, minute: schedules[t].minute, second: 0, of: withDay)
                    let dateFormatter = DateFormatter()

                    // Format date
                    dateFormatter.dateFormat = "HH:mm EEEE, d MMM y"
                    
                    let reminder = [
                        "name": medication.name,
                        "type": medication.type,
                        "dosage": schedules[t].dosage,
                        "time": withTime!,
                        "completed": false,
                        "uid": medication.uid,
                        "mid": mid,
                        "sid": schedules[t].id,
                    ] as [String : Any]

                    Firestore.firestore().collection("reminders").document("\(UUID().uuidString)-\(schedules[t].id)").setData(reminder)
                }

            }
        }
    }
    
    
    
    func addMedication(medication: Medication) {
        let mid = UUID().uuidString
        
        Firestore.firestore().collection("medications").document(mid).setData(
            [
                "name": medication.name,
                "type": medication.type,
                "schedules": StringifySchedules(schedules: medication.schedules),
                "frequency": medication.frequency,
                "howManyTimesADay": medication.howManyTimesADay,
                "uid": medication.uid
            ]
        )
        
        GenerateReminders(weeks: 4, mid: mid, medication: medication)
    }
    
    func updateMedication(medication: Medication) {
        Firestore.firestore().collection("medications")
            .document(String(medication.id!))
            .setData(
                [
                    "name": medication.name,
                    "type": medication.type,
                    "schedules": StringifySchedules(schedules: medication.schedules),
                    "frequency": medication.frequency,
                    "howManyTimesADay": medication.howManyTimesADay,
                    "uid": medication.uid
                ], merge: true
            )
    }
    
    func deleteMedication(forMid mid: String) {
        Firestore.firestore().collection("medications").document(mid).delete()
    }
    
    func fetchMedications(forUid uid: String, completion: @escaping([Medication]) -> Void) {
        Firestore.firestore().collection("medications")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let medications = documents.compactMap({
                    try? $0.data(as: Medication.self)
                })
                print(medications)
                completion(medications)
            }
    }
}
