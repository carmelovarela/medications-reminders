//
//  HeaderComponentView.swift
//  Medications Reminders
//
//  Created by Carmelo Varela II on 01/04/2022.
//

import SwiftUI

struct HeaderComponentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var title: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            NavigationLink(destination: ProfileView()) {
                Text("\(String(authViewModel.currentUser.email.prefix(1).uppercased()))")
                    .frame(width: 49, height: 49)
                    .foregroundColor(Color("AppText"))
                    .font(.system(.title2, design: .rounded))
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Circle())
            }
        }
        .padding([.top, .leading, .trailing])
    }
}

struct HeaderComponentView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponentView(title: "Header")
            .preview(with: "Header Component")
    }
}
