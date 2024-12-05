//
//  MatchCardView.swift
//  MatchMate-Shaddi
//
//  Created by Gurpreet Singh on 03/12/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileCardView: View {
    var profile: UserData
    var onAccept: () -> Void
    var onDecline: () -> Void

    var body: some View {
        VStack {
            // Profile Image
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: profile.picture.large)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                // Fallback on earlier versions
            }

            // Name and Location
            Text(profile.name.first + " " + profile.name.last)
                .font(.headline)
            Text("\(profile.dob.age), \(profile.location.city)")
                .font(.subheadline)
                .foregroundColor(.gray)

            // Action Buttons or Status
            if profile.status == .pending {
                HStack {
                    Button(action: onDecline) {
                        Text("Decline")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: onAccept) {
                        Text("Accept")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                // Show the status if already accepted/declined
                Text(profile.status.rawValue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(profile.status == .accepted ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

