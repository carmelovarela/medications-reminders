//
//  ReminderCardComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 03/04/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CheckboxToggleStyle: ToggleStyle {
    @ObservedObject var remindersViewModel: RemindersViewModel
    
    let reminder: Reminder
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
                .grayscale(configuration.isOn ? 1.0 : 0)
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(configuration.isOn ? Color("AppText") : Color(UIColor.systemGray5))
        }
        .padding()
        .background(Color("ReminderCardComponentBackground"))
        .cornerRadius(14)
        .onTapGesture {
            configuration.isOn.toggle()
            Firestore.firestore().collection("reminders").document(reminder.id!).updateData(["completed" : configuration.isOn])
            remindersViewModel.fetchReminders()
        }
    }
}

func getTime(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.string(from: date)
}

struct ReminderCardComponentView: View {
    let reminder: Reminder
    let remindersViewModel: RemindersViewModel
    

    @State private var status: Bool
    
    init(reminder: Reminder, remindersViewModel: RemindersViewModel) {
        self.remindersViewModel = remindersViewModel
        self.reminder = reminder
        _status = State(initialValue: reminder.completed)
    }

    var body: some View {
        ZStack {
            Toggle(isOn: $status) {
                HStack {
                    Image(reminder.type)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 49, height: 49)
                        .padding(.trailing, 4.0)
                    VStack(alignment: .leading) {
                        Text(reminder.name)
                            .fontWeight(.semibold)
                            .strikethrough(status)
                            .padding(.bottom, -4.5)
                        Text("\(floor(reminder.dosage) == reminder.dosage ? String(format: "%.0f", reminder.dosage) : String(format: "%.1f", reminder.dosage)) \(reminder.dosage > 1 ? reminder.type + "s" : reminder.type)")
                            .font(.caption)
                            .strikethrough(status)
                            .padding(.bottom, -1.5)
                        Text("\(getTime(date: reminder.time))")
                            .font(.caption)
                            .strikethrough(status)
                            .padding(.bottom, -1.5)
                    }
                }
            }.toggleStyle(CheckboxToggleStyle(remindersViewModel: remindersViewModel, reminder: reminder))
        }
    }
}
