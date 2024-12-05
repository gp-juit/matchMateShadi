//
//  MatchMate_ShaddiApp.swift
//  MatchMate-Shaddi
//
//  Created by Gurpreet Singh on 03/12/24.
//

import SwiftUI

@main
struct MatchMate_ShaddiApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
