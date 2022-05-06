//
//  RegimensViewModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import Foundation

class MedicationsViewModel: ObservableObject {
    @Published var medications = [Medication]()
    
    private let service = MedicationService()
    let user: User
    
    init(user: User) {
        self.user = user
        self.fetchMedications()
    }
    
    func fetchMedications() {
        guard let uid = user.id else { return }
        service.fetchMedications(forUid: uid) { regimens in
            self.medications = regimens
        }
    }
    
    func addMedication(medication: Medication) {
        service.addMedication(medication: medication)
    }
    
    func updateMedication(medication: Medication) {
        service.updateMedication(medication: medication)
    }
    
    func deleteMedication(medicationToDelete: String) {
        service.deleteMedication(forMid: medicationToDelete)
    }
}

