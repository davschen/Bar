//
//  BarApp.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import SwiftUI

@main
struct BarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
