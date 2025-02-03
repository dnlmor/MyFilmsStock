//
//  myfilmsApp.swift
//  myfilms
//
//  Created by Daniel Moreno Wellinski Siahaan on 03/02/2025.
//

import SwiftUI

@main
struct myfilmsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
