//
//  ProfileView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16.0) {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.headline)
                
                InputTextfieldComponentView(
                    text: $authViewModel.name,
                    placeholder: authViewModel.currentUser.name,
                    keyboardType: .default
                )
            }
            
            Spacer()

            SecondaryButtonComponentView(
                title: "Log out") {
                    Task { await authViewModel.signOut() }
            }
        }
        .padding()
        .navigationTitle("Account")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
