//
//  SecondaryButtonComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct SecondaryButtonComponentView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let handler: ActionHandler
    
    internal init(title: String,
                  handler: @escaping PrimaryButtonComponentView.ActionHandler) {
        self.title = title
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,
                       maxHeight: 60)
        })
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10.0)
            
    }
}

struct SecondaryButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButtonComponentView(title: "Sign Up") { }
            .preview(with: "Secondary Button")
    }
}
