//
//  EditMedicationView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

struct EditMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var medicationsViewModel: MedicationsViewModel
    @ObservedObject var remindersViewModel: RemindersViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var medication: Medication
    @State var selectedMedicationType: String
    @State private var frequency: [String]
    @State private var howManyTimesADay: Int
    @State private var schedules: [Schedule]
    @State private var name: String
    @State private var showAlert = false

    
    init(user: User, medication: Medication) {
        _medication = State(initialValue: medication)
        _selectedMedicationType = State(initialValue: medication.type)
        _frequency = State(initialValue: medication.frequency)
        _howManyTimesADay = State(initialValue: medication.howManyTimesADay)
        _schedules = State(initialValue: medication.schedules)
        _name = State(initialValue: medication.name)
        self.medicationsViewModel = MedicationsViewModel(user: user)
        self.remindersViewModel = RemindersViewModel(user: user)
    }
    
    @State private var items: [String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    private var medicationTypes = ["Capsule", "Tablet", "Drop", "Injection"]
    
    func Repeat(selections: [String]) -> String {
        var str = ""
        
        if selections.isEmpty {
            str = "Never"
        } else if selections.contains("Monday") && selections.contains("Tuesday") && selections.contains("Wednesday") && selections.contains("Thursday") && selections.contains("Friday") && selections.contains("Saturday") && selections.contains("Sunday") {
            str = "Everyday"
        } else if selections == ["Monday","Tuesday","Wednesday","Thursday","Friday"] {
            str = "Weekdays"
        } else if selections == ["Saturday","Sunday"] {
            str = "Weekends"
        } else if selections.count == 1 {
            str = "Every \(selections[0])"
        } else {
            str = selections.map{ $0.prefix(3) }.joined(separator: " ")
        }
        
        return str
    }
    
    func updateMedication() {
        medicationsViewModel.updateMedication(
            medication: Medication(
                id: medication.id,
                name: name,
                type: selectedMedicationType,
                frequency: frequency,
                howManyTimesADay: howManyTimesADay,
                schedules: schedules.filter({ s in
                    return s.hour > 0
                }),
                uid: String(authViewModel.currentUser.id!)
            )
        )
        
        let schedulesFiltered = Array(schedules.prefix(howManyTimesADay))
        print(schedulesFiltered)
        for s in schedulesFiltered {
            let remindersFiltered = remindersViewModel.reminders.filter({ r in
                return r.sid == s.id
            })
            for r in remindersFiltered {
                Firestore.firestore().collection("reminders").document(r.id!).updateData([
                    "name": name,
                    "type": selectedMedicationType
                ])
            }
        }
    }
    
    @State private var currentDate = Date()
    
    var body: some View {
        VStack {
            List {
                Section {
                    TextField("Name", text: $name)
                        .onChange(of: name) { name in
                            updateMedication()
                        }
                }
                
                Section {
                    Picker("Type", selection: $selectedMedicationType) {
                        ForEach(medicationTypes, id: \.self) {
                            MedicationType(type: $0)
                        }
                    }
                    .onChange(of: selectedMedicationType) { selectedMedicationType in
                        updateMedication()
                    }
                }
                
                Section {
                    NavigationLink(destination: {
                        List {
                            ForEach(self.items, id: \.self) { item in
                                MultipleSelectionRow(title: item, isSelected: self.frequency.contains(item)) {
                                    if self.frequency.contains(item) {
                                        self.frequency.removeAll(where: { $0 == item })
                                    }
                                    else {
                                        self.frequency.append(item)
                                    }
                                }
                            }
                        }
                        .onChange(of: frequency) { frequency in
                            updateMedication()
                        }
                    }) {
                        HStack {
                            Text("Frequency")
                            
                            Spacer()
                            
                            Text(Repeat(selections: frequency))
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                }
                
                Section {
                    
                    NavigationLink(destination: {
                        List {
                            Picker("How many times a day", selection: $howManyTimesADay) {
                                ForEach(1...24, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: howManyTimesADay) { howManyTimesADay in
                                updateMedication()
                                
                                
                            }
                        }
                    }) {
                        Text("How many times a day?")
                    }
                        
                    
                    ForEach(0 ..< howManyTimesADay, id: \.self) { i in
                        NavigationLink(destination: {
                            List {
                                Section {
                                    TextField("Dosage", value: $schedules[i].dosage, formatter: NumberFormatter())
                                        .keyboardType(.decimalPad)
                                        .onChange(of: schedules[i].dosage) { schedule in
                                            updateMedication()
                                        }
                                }
                                
                                Section {
                                    GeometryReader { geometry in
                                        HStack {
                                            Picker("How many times a day", selection: $schedules[i].hour) {
                                                ForEach(1...23, id: \.self) {
                                                    Text("\(String(format: "%02d", $0))")
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                                            .compositingGroup()
                                            .clipped()
                                            .onChange(of: schedules[i].hour) { hour in
                                                updateMedication()
                                            }
                                            Picker("How many times a day", selection: $schedules[i].minute) {
                                                ForEach(0...59, id: \.self) {
                                                    Text("\(String(format: "%02d", $0))")
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                                            .compositingGroup()
                                            .clipped()
                                            .onChange(of: schedules[i].minute) { hour in
                                                updateMedication()
                                            }
                                        }
                                        .padding(.trailing, 4.0)
                                    }
                                    .frame(width: 320, height: 150)
                                }
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 8.0) {
                                
                                Text("\(String(format: "%02d", schedules[i].hour)):\(String(format: "%02d", schedules[i].minute))")
                                Text("Take \(floor(schedules[i].dosage) == schedules[i].dosage ? String(format: "%.0f", schedules[i].dosage) : String(format: "%.1f", schedules[i].dosage)) \(schedules[i].dosage > 1 ? selectedMedicationType + "s" : selectedMedicationType)")
                                    .font(.caption)
                            }
                            .padding(.vertical, 4.0)
                        }
                    }
                }
            }
            
            Spacer()
            
            
            SecondaryButtonComponentView(title: "Delete medication") {
                Task {
                    showAlert = true
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete medication"),
                        message: Text("Are you sure you want to delete this medication?"),
                        primaryButton: .default(
                            Text("Cancel"),
                            action: {
                                dismiss()
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                medicationsViewModel.deleteMedication(medicationToDelete: String(medication.id!))
                                
                               
                                let remindersFiltered = remindersViewModel.reminders.filter({ r in
                                    return r.mid == medication.id!
                                })
                                
                                for r in remindersFiltered {
                                    Firestore.firestore().collection("reminders").document(r.id!).delete()
                                }
                                
                                
                                dismiss()
                            }
                        )
                    )
                }
        }
        .navigationBarTitle("Edit medication", displayMode: .inline)
    }
}
