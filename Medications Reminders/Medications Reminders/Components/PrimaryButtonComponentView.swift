//
//  PrimaryButtonComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct PrimaryButtonComponentView: View {
    
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
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity,
                       maxHeight: 60)
        })
            .background(Color.blue)
            .cornerRadius(10.0)
            
    }
}

struct PrimaryButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonComponentView(title: "Login") { }
            .preview(with: "Primary Button")
    }
}
