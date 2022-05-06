//
//  InputPasswordComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct InputPasswordComponentView: View {
    @Binding var password: String
    let placeholder: String
    
    var body: some View {
        SecureField(placeholder, text: $password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(10.0)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10.0)
    }
}

struct InputPasswordComponentView_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordComponentView(password: .constant(""),
                           placeholder: "Password")
            .preview(with: "Password input")
    }
}
