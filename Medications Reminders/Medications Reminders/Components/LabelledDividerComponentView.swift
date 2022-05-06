//
//  LabelledDividerComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct LabelledDividerComponentView: View {
    let text: String
    
    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            
            Text(text)
                .font(.caption)
                .foregroundColor(Color(UIColor.systemGray2))
            
            VStack {
                Divider()
            }
        }
    }
}

struct LabelledDividerComponentView_Previews: PreviewProvider {
    static var previews: some View {
        LabelledDividerComponentView(text: "Or sign up using")
            .preview(with: "Labelled Divider")
    }
}
