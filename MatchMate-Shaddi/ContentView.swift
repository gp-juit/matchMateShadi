//
//  ContentView.swift
//  MatchMate-Shaddi
//
//  Created by Gurpreet Singh on 03/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.profiles) { profile in
                        ProfileCardView(
                            profile: profile,
                            onAccept: {
                                viewModel.updateProfileStatus(profile: profile, isAccepted: true)
                            },
                            onDecline: {
                                viewModel.updateProfileStatus(profile: profile, isAccepted: false)
                            }
                        )
                        .padding()
                    }
                }
            }
            .navigationTitle("Profile Matches")
            .onAppear {
                viewModel.fetchProfiles()
            }
        }
    }
}



