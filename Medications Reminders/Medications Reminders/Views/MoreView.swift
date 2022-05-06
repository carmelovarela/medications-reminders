//
//  MoreView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        VStack {
            HeaderComponentView(title: "More")
            
            ScrollView { }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
