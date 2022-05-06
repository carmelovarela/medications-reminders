//
//  TodayView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI
import UserNotifications


struct TodayView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16.0) {
            HeaderComponentView(title: "Today")
            
            WeeklyCalendarComponentView(user: authViewModel.currentUser)
        }
    }
}

