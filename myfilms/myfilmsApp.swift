import SwiftUI

@main
struct MyFilmsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MovieListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
