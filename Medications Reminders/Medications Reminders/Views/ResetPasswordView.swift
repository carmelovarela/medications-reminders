//
//  ResetPasswordView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct ResetPasswordView: View {
    var body: some View {
        VStack(spacing: 16.0) {
            InputTextfieldComponentView(text: .constant(""),
                               placeholder: "Email address",
                               keyboardType: .emailAddress)
            
            Spacer()
            
            PrimaryButtonComponentView(title: "Send password reset") { }
        }
        .padding()
        .navigationTitle("Reset password")
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResetPasswordView()
        }
    }
}
