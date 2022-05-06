//
//  InputTextfieldComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct InputTextfieldComponentView: View {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        if keyboardType == .default {
            TextField(placeholder, text: $text)
                .autocapitalization(UITextAutocapitalizationType.words)
                .disableAutocorrection(true)
                .padding(10.0)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10.0)
                .keyboardType(.default)
        } else {
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10.0)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10.0)
                .keyboardType(.emailAddress)
        }
        
    }
}

struct InputTextfieldComponentView_Previews: PreviewProvider {
    static var previews: some View {
        InputTextfieldComponentView(text: .constant(""),
                           placeholder: "Email",
                           keyboardType: .emailAddress)
            .preview(with: "Email text input")
        
        InputTextfieldComponentView(text: .constant(""),
                           placeholder: "Name",
                           keyboardType: .default)
            .preview(with: "Name text input")
    }
}
