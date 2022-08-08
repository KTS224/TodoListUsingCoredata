//
//  TodoListCoredataApp.swift
//  TodoListCoredata
//
//  Created by 김태성 on 2022/08/08.
//

import SwiftUI

@main
struct TodoListCoredataApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
