//
//  ChuckNorrisJokes_MikeApp.swift
//  ChuckNorrisJokes_Mike
//
//  Created by Mike_Tree on 10/8/24.
//

import SwiftUI
import CoreData

@main
struct ChuckNorrisJokes_MikeApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            JokeView()
                .environment(\.managedObjectContext, CoreDataStack.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                CoreDataStack.save()
            default:
                break
            }
        }
    }
}

private enum CoreDataStack {
    static var viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ChuckNorrisJokes")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("\(#file), \(#function), \(error!.localizedDescription)")
            }
        }
        
        return container.viewContext
    }()
    
    static func save() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
