//
//  RemindersViewModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 03/04/2022.
//

import Foundation
import UserNotifications

class RemindersViewModel: ObservableObject {
    @Published var reminders = [Reminder]()
    
    private let service = RemindersService()
    let user: User
    
    init(user: User) {
        self.user = user
        self.fetchReminders()
        self.setupNotifications()
    }
    
    func fetchReminders() {
        guard let uid = user.id else { return }
        service.fetchReminders(forUid: uid) { reminders in
            self.reminders = reminders
        }
    }
    
    func setupNotifications() {
        for r in reminders {
            let content = UNMutableNotificationContent()
            content.title = "Time to take your medication"
            content.body = "\(r.name) - \(floor(r.dosage) == r.dosage ? String(format: "%.0f", r.dosage) : String(format: "%.1f", r.dosage)) \(r.dosage > 1 ? r.type + "s" : r.type)"
            
            // Configure the recurring date.
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            
            dateComponents.year = Calendar.current.component(.year, from: r.time)
            dateComponents.month = Calendar.current.component(.month, from: r.time)
            dateComponents.day = Calendar.current.component(.day, from: r.time)
            dateComponents.hour = Calendar.current.component(.hour, from: r.time) // 14:00 hours
            dateComponents.minute = Calendar.current.component(.minute, from: r.time)
        
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: true)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
                   print(error!)
               }
            }
        }
    }
}

