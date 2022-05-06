//
//  ContentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    fileprivate func ContentView() -> some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
                .navigationTitle("Back")
                .navigationBarHidden(true)
                
            MedicationsView(user: authViewModel.currentUser)
                .tabItem {
                    Label("Medications", systemImage: "pills.fill")
                }
                .navigationTitle("Back")
                .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            UITabBar.appearance().backgroundColor
                = UIColor(Color(UIColor.systemBackground))
        }
    }
    
    var body: some View {
        NavigationView {
            if authViewModel.isLoggedIn {
                ContentView()
            } else {
                SignUpView()
            }
        }
    }
}

