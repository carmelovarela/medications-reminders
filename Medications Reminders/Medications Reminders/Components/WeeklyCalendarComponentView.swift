//
//  WeeklyCalendarComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI
import UserNotifications

struct WeeklyCalendarComponentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var weeklyCalendarViewModel: WeeklyCalendarViewModel
    = WeeklyCalendarViewModel()
    @ObservedObject var remindersViewModel: RemindersViewModel
    @State var direction = ""
    @State var startPos : CGPoint = .zero
    @State var isSwipping = true
    
    init(user: User) {
        self.remindersViewModel = RemindersViewModel(user: user)
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(weeklyCalendarViewModel.currentWeek, id: \.self) { day in
                    VStack(spacing: 5) {
                        Text(weeklyCalendarViewModel.extractDate(
                            date: day, format: "EEE")
                        )
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 45, height: 45)
                                .opacity(weeklyCalendarViewModel.isToday(
                                    date: day) ? 1 : 0
                                )
                            Text(weeklyCalendarViewModel.extractDate(
                                date: day, format: "dd")
                            )
                                .fontWeight((
                                        weeklyCalendarViewModel.isToday(date: day)
                                        ? .semibold : .regular
                                    )
                                )
                        }
                        
                        .foregroundColor(
                            weeklyCalendarViewModel.isToday(date: day)
                            ? Color.white : Color("AppText")
                        )
                        
                    }
                    .onTapGesture {
                        withAnimation() {
                            weeklyCalendarViewModel.currentDay = day
                        }
                    }
                }
            }
            .padding(.bottom, 2.0)
            
            VStack {
                Text("\(weeklyCalendarViewModel.currentDay.formatted(date: .complete, time: .omitted))")
                    .foregroundColor(Color(UIColor.systemGray))
            }
        }
        .gesture(DragGesture()
                .onChanged { gesture in
                    if self.isSwipping {
                        self.startPos = gesture.location
                        self.isSwipping.toggle()
                    }
                }
                .onEnded { gesture in
                    let xDist =  abs(gesture.location.x - self.startPos.x)
                    let yDist =  abs(gesture.location.y - self.startPos.y)
                    if self.startPos.y <  gesture.location.y && yDist > xDist {
                        self.direction = "Down"
                    }
                    else if self.startPos.y >  gesture.location.y && yDist > xDist {
                        self.direction = "Up"
                    }
                    else if self.startPos.x > gesture.location.x && yDist < xDist {
                        self.direction = "Left"
                        weeklyCalendarViewModel.currentDay =
                        Calendar.current.date(
                            byAdding: .day,
                            value: 7,
                            to: weeklyCalendarViewModel.currentDay
                        )!
                        weeklyCalendarViewModel.fetchCurrentWeek()

                    }
                    else if self.startPos.x < gesture.location.x && yDist < xDist {
                        self.direction = "Right"
                        weeklyCalendarViewModel.currentDay =
                        Calendar.current.date(
                            byAdding: .day,
                            value: -7,
                            to: weeklyCalendarViewModel.currentDay
                        )!
                        weeklyCalendarViewModel.fetchCurrentWeek()
                    }
                    self.isSwipping.toggle()
                }
             )
        
        ScrollView {
            LazyVStack(spacing:16.0) {
                ForEach(remindersViewModel.reminders.sorted(by: {$0.time < $1.time})) { reminder in
                    if reminder.time.formatted(date: .complete, time: .omitted) == weeklyCalendarViewModel.currentDay.formatted(date: .complete, time: .omitted) {
                        ReminderCardComponentView(reminder: reminder, remindersViewModel: remindersViewModel)
                    }
                }
            }
            .padding()
        }
        .background(Color("SecondarySystemBackground"))
        .overlay(Rectangle()
                    .frame(width: nil, height: 0.5, alignment: .bottom)
                    .foregroundColor(Color(UIColor.systemGray5)), alignment: .bottom)
        .overlay(Rectangle()
                    .frame(width: nil, height: 0.5, alignment: .bottom)
                    .foregroundColor(Color(UIColor.systemGray5)), alignment: .top)
        .gesture(DragGesture()
                    .onChanged { gesture in
                        if self.isSwipping {
                            self.startPos = gesture.location
                            self.isSwipping.toggle()
                        }
                    }
                    .onEnded { gesture in
                        let xDist =  abs(gesture.location.x - self.startPos.x)
                        let yDist =  abs(gesture.location.y - self.startPos.y)
                        if self.startPos.y <  gesture.location.y && yDist > xDist {
                            self.direction = "Down"
                        }
                        else if self.startPos.y >  gesture.location.y && yDist > xDist {
                            self.direction = "Up"
                        }
                        else if self.startPos.x > gesture.location.x && yDist < xDist {
                            self.direction = "Left"
                            weeklyCalendarViewModel.currentDay =
                            Calendar.current.date(
                                byAdding: .day,
                                value: 1,
                                to: weeklyCalendarViewModel.currentDay
                            )!
                            weeklyCalendarViewModel.fetchCurrentWeek()

                        }
                        else if self.startPos.x < gesture.location.x && yDist < xDist {
                            self.direction = "Right"
                            weeklyCalendarViewModel.currentDay =
                            Calendar.current.date(
                                byAdding: .day,
                                value: -1,
                                to: weeklyCalendarViewModel.currentDay)!
                            weeklyCalendarViewModel.fetchCurrentWeek()
                        }
                        self.isSwipping.toggle()
                    }
                 )
        .onAppear {
            remindersViewModel.fetchReminders()
            remindersViewModel.setupNotifications()
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
