//
//  WeeklyCalendarViewModel.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

class WeeklyCalendarViewModel: ObservableObject {
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = currentDay
        
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        var selectedWeek: [Date] = []
        
        (0...6).forEach { day in
            if let weekday = calendar.date(
                byAdding: .day,
                value: day,
                to: firstWeekDay)
            {
                selectedWeek.append(weekday)
            }
        }
        
        currentWeek = selectedWeek
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
}

