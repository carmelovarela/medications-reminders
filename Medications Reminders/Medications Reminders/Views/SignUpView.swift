//
//  SignUpView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16.0) {
            Group {
                InputTextfieldComponentView(
                    text: $authViewModel.name,
                    placeholder: "Name",
                    keyboardType: .default
                )
                
                InputTextfieldComponentView(
                    text: $authViewModel.email,
                    placeholder: "Email address",
                    keyboardType: .emailAddress
                )
                
                InputPasswordComponentView(
                    password: $authViewModel.password,
                    placeholder: "Password"
                )
            }
            
            Spacer()
            
            Group {
                PrimaryButtonComponentView(
                    title: "Create account",
                    handler: {
                        Task {
                            await authViewModel.signUp()
                        }
                    }
                )
            }
            
        }
        .padding()
        .ignoresSafeArea(.keyboard)
        .navigationBarTitle("Sign up")
        .navigationBarItems(
            trailing: NavigationLink(destination: LoginView()){
                Text("Login")
                    .fontWeight(.semibold)
            })
        .alert("Error",
               isPresented: $authViewModel.hasError)
        {
            
        } message: {
            Text(authViewModel.errorMessage)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
