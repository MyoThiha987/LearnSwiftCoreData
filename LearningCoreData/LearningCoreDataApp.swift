//
//  LearningCoreDataApp.swift
//  LearningCoreData
//
//  Created by Myo Thiha on 08/09/2024.
//

import SwiftUI

@main
struct LearningCoreDataApp: App {
    let persistenceController = CoreDataStack.shared.persistanceContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
