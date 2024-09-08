//
//  ContentView.swift
//  LearningCoreData
//
//  Created by Myo Thiha on 08/09/2024.
//

import SwiftUI
import CoreData

enum Priority : String, Identifiable, CaseIterable {
    var id : UUID {
        return UUID()
    }
    
    case medium = "Medium"
    case low = "Low"
    case high = "High"
}

extension Priority{
    var title : String{
        switch self {
        case .low : return "Low"
        case .medium : return "Medium"
        case .high : return "High"
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var text : String = ""
    @State private var selectedPriority : Priority = .medium
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)] )
    private var tasks : FetchedResults<Task>
    
    private func saveTask() {
        withAnimation{
            do {
                let task = Task(context: viewContext)
                task.title = text
                task.priority = selectedPriority.rawValue
                task.isFavourite = false
                task.timestamp = Date()
                try viewContext.save()
            } catch {
                print(error.localizedDescription )
            }
        }
        
    }
    
    private func favouriteTask(task : Task){
        withAnimation{
            task.isFavourite = !task.isFavourite
            
            do{
               try viewContext.save()
            }catch{
                
            }
        }
    }
    
    private func deletTask(offsets : IndexSet){
        withAnimation{
            offsets.forEach { index in
              let task =  tasks[index]
                viewContext.delete(task)
            }
           
            do{
                try viewContext.save()
            }
            catch{
                
            }
        }
    }
    
    private func styleForPriority(value : String) -> Color {
        let priority = Priority(rawValue: value)
        switch priority {
        case .low : return Color.green
        case .medium : return Color.orange
        case .high : return Color.red
        case .none:
            return Color.blue
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)){
                
                VStack(spacing: 20){
                    TextField("Enter Task Name", text: $text).textFieldStyle(.roundedBorder)
                    
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(Priority.allCases){priority in
                            Text(priority.title).tag(priority)
                        }
                    }.pickerStyle(.segmented)
                 
                Button(action: {
                    saveTask()
                }, label: {
                    Text("Button")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12,style: .continuous))
                })
                    List{
                        ForEach(tasks){task in
                            HStack{
                                Circle()
                                    .fill(styleForPriority(value: task.priority!))
                                    .frame(width: 15,height: 15)
                                Spacer().frame(width: 20)
                                Text(task.title ?? "")
                                Spacer()
                                Image(systemName: task.isFavourite ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        favouriteTask(task: task)
                                    }
                            
                            }
                        }.onDelete(perform: { indexSet in
                            deletTask(offsets: indexSet)
                        })
                    }.listStyle(.inset)
                    Spacer()
                }
                .padding(.horizontal,12)
                .navigationTitle("All Tasks")
                
                VStack{
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("+")
                            .padding(12)
                            .font(.system(.largeTitle))
                            .foregroundColor(.white)
                    })
                    .padding(12)
                    .background(Color.blue)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .shadow(color: Color.black.opacity(0.3),
                                                radius: 3,
                                                x: 3,
                                y: 3)
                }.padding(.horizontal,16)
            }
            
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}

struct ContentView_Preview : PreviewProvider {

        static var previews: some View{
            let persistenceController = CoreDataStack.shared.persistanceContainer

            ContentView().environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
