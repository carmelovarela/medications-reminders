//
//  MedicationsView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct MedicationsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var medicationsViewModel: MedicationsViewModel
    @State private var showingSheet = false
    
    init(user: User) {
        self.medicationsViewModel = MedicationsViewModel(user: user)
    }
    
    var body: some View {
        VStack {
            HeaderComponentView(title: "Medications")
            
            List(medicationsViewModel.medications) { medication in
                NavigationLink(destination: EditMedicationView(user: authViewModel.currentUser, medication: medication)) {
                    HStack {
                        Image(medication.type)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 49, height: 49)
                            .padding(.trailing, 4.0)
                        
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text(medication.name)
                                .font(.headline)
                            Text(medication.type)
                                .font(.caption)
                        }
                    }
                    .padding(8.0)
                }
            }
            .onAppear(perform: {
                    UITableView.appearance().contentInset.top = -15
                })
            .overlay(Rectangle()
                        .frame(width: nil, height: 0.5, alignment: .bottom)
                        .foregroundColor(Color(UIColor.systemGray5)), alignment: .bottom)
            .overlay(Rectangle()
                        .frame(width: nil, height: 0.5, alignment: .bottom)
                        .foregroundColor(Color(UIColor.systemGray5)), alignment: .top)
            
            
            VStack {
                PrimaryButtonComponentView(title: "Add medication") {
                    Task {
                        showingSheet.toggle()
                    }
                }
                .sheet(isPresented: $showingSheet, onDismiss: {
                    medicationsViewModel.fetchMedications()
                }) {
                    SheetView(medicationsViewModel: medicationsViewModel)
                }
            }
            .padding([.leading, .bottom, .trailing])
            .padding(.top, 4.0)
            .overlay(Rectangle()
                        .frame(width: nil, height: 0.5, alignment: .bottom)
                        .foregroundColor(Color(UIColor.systemGray5)), alignment: .bottom)
        }
        .onAppear {
            medicationsViewModel.fetchMedications()
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                    .foregroundColor(Color("AppText"))
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct MedicationType: View {
    var type: String
    
    var body: some View {
        HStack {
            Image(type)
                .resizable()
                .scaledToFill()
                .frame(width: 49, height: 49)
                .padding(.trailing, 4.0)
            Text(type)
        }
        .padding()
    }
}

struct SheetView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var medicationsViewModel: MedicationsViewModel
    @Environment(\.dismiss) var dismiss
    
    init(medicationsViewModel: MedicationsViewModel) {
        self.medicationsViewModel = medicationsViewModel
    }
    
    private var medicationTypes = ["Capsule", "Tablet", "Drop", "Injection"]

    @State private var selectedMedicationType: String = "Capsule"
    @State private var howManyTimesADay = 1
    @State private var name = ""

    @State private var schedules: [Schedule] = [
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1),
        Schedule(id: UUID().uuidString, hour: 8, minute: 30, dosage: 1)
    ]
    
    @State private var items: [String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    @State private var frequency: [String] = []
    
    func Repeat(selections: [String]) -> String {
        var str = ""
        
        if selections.isEmpty {
            str = "Never"
        } else if selections == ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] {
            str = "Everyday"
        } else if selections == ["Monday","Tuesday","Wednesday","Thursday","Friday"] {
            str = "Weekdays"
        } else if selections == ["Saturday","Sunday"] {
            str = "Weekends"
        } else if selections.count == 1 {
            str = selections[0]
        } else {
            str = selections.map{ $0.prefix(3) }.joined(separator: " ")
        }
        
        return str
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Name", text: $name)
                    }
                    
                    Section {
                        Picker("Type", selection: $selectedMedicationType) {
                            ForEach(medicationTypes, id: \.self) {
                                MedicationType(type: $0)
                            }
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
                            Picker("How many times a day", selection: $howManyTimesADay) {
                                ForEach(1...24, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.wheel)
                        }) {
                            Text("How many times a day?")
                        }
                            
                        
                        ForEach(0 ..< howManyTimesADay, id: \.self) { i in
                            NavigationLink(destination: {
                                List {
                                    Section {
                                        TextField("Dosage", value: $schedules[i].dosage, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
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
                                                Picker("How many times a day", selection: $schedules[i].minute) {
                                                    ForEach(0...59, id: \.self) {
                                                        Text("\(String(format: "%02d", $0))")
                                                    }
                                                }
                                                .pickerStyle(.wheel)
                                                .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                                                .compositingGroup()
                                                .clipped()
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
                
                PrimaryButtonComponentView(title: "Add medication") {
                    Task {
                        medicationsViewModel.addMedication(medication:
                            Medication(
                                name: name,
                                type: selectedMedicationType,
                                frequency: frequency,
                                howManyTimesADay: howManyTimesADay,
                                schedules: Array(schedules.prefix(howManyTimesADay)),
                                uid: String(authViewModel.currentUser.id!)
                            )
                        )
                        dismiss()
                    }
                }
                .padding()
                }
                .navigationBarTitle("Add medication", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            medicationsViewModel.addMedication(medication:
                                Medication(
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
                            dismiss()
                        }) {
                            Text("Save")
                                .fontWeight(.semibold)
                        }
                    }
                }
        }
    }
}
