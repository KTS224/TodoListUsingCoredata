//
//  ContentView.swift
//  TodoListCoredata
//
//  Created by 김태성 on 2022/08/08.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

private func styleForPriority(_ value: String) -> Color {
    let priority = Priority(rawValue: value)
    
    switch priority {
    case .low:
        return Color.green
    case .medium:
        return Color.orange
    case .high:
        return Color.red
    default:
        return Color.black
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTask: FetchedResults<Task>
    
    private func saveTask() {
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateTask(_ task: Task) {
        task.isFavorite = !task.isFavorite
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offset: IndexSet) {
        offset.forEach { index in
            let task = allTask[index]
            viewContext.delete(task)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
//    func move(from source: IndexSet, to destination: Int) {
////        CoreDataManager.shared.move(fromOffsets: source, toOffset: destination)
//        Priority.move(fromOffsets: source, toOffset: destination)
//
//    }
  
//    func move(from source: IndexSet, to destination: Int){
//        self.todos.move(fromOffsets: source, toOffset: destination)
//    }
//    
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title", text: $title)
                    .padding(5)
                    .background(Color.yellow.opacity(0.7))
                    .cornerRadius(5)
//                    .textFieldStyle(.roundedBorder)
                
                
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.title).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
//                .padding(5)
                .background(Color.yellow.opacity(0.7))
                .cornerRadius(5)
                
                Button("Save") {
                    saveTask()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List {
                    ForEach(allTask) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                                
                            Image(systemName: task.isFavorite ? "heart.fill": "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }
                    .onDelete(perform: deleteTask)
                    .listRowBackground(Color.yellow.cornerRadius(5))
//                    .listRowBackground(cornerRadius(50))
                    
                }
                .listStyle(.plain)
//                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: EditButton().colorInvert())
            .navigationTitle("All Tasks")
            .background(Color.pink.opacity(0.2))
            .background(Color.blue.ignoresSafeArea())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
