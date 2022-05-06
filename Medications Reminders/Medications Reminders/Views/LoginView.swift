//
//  LoginView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16.0) {
            Group {
                InputTextfieldComponentView(
                    text: $authViewModel.email,
                    placeholder: "Email address",
                    keyboardType: .emailAddress
                )
                
                InputPasswordComponentView(
                    password: $authViewModel.password,
                    placeholder: "Password"
                )
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: ResetPasswordView()) {
                        Text("Forgot your password?")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.placeholderText))
                    }
                }
            }
            
            Spacer()
            
            Group {
                PrimaryButtonComponentView(
                    title: "Log in",
                    handler: {
                        Task { await authViewModel.signIn() }
                    }
                )
            }
        }
        .padding()
        .ignoresSafeArea(.keyboard)
        .navigationBarTitle("Log in")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
