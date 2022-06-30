//
//  ContentView.swift
//  Todo-List-2
//
//  Created by giorgi on 25.06.22.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var todos = TodoList()
    
    @State  var isShowing = false
    var statuses = [Status.initial, Status.inProgress, Status.completed, Status.overdue, Status.all ]
    
    var body: some View {
        NavigationView {
            VStack{
                
                if todos.list.isEmpty {
                    VStack{
                        Button{
                            isShowing = true
                        } label:{
                            VStack {
                                Text("Click the button to create your first Todo")
                                    .padding()
                                Image(systemName:"plus.square.dashed")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFit()

                            }
                        }
                        
                    }
                }
            else{
                List {
                    ForEach(Array(todos.list.sortedKeys()), id:\.self){ key in
                                Section(header: Text(key)){
                                    ForEach(todos.list[key]?.filter{ !$0.hidden } ?? []){ todo in
                                             NavigationLink{
                                                AddTodo(
                                                    isShowing: $isShowing,
                                                    text:todo.text,
                                                    deadline:todo.deadline,
                                                    todo:todo,
                                                    dismiss: {}

                                                            )
                                                        } label: {
                                                            TodoView(todo: todo, key:key)
                                                        }

                                                    }
                                      
                                        .onDelete(perform: { indexSet in
                                            todos.deleteTodo(indexSet: indexSet, key: key)
                                        })
                                        .onMove(perform: { indexSet, int in
                                            move(from: indexSet, to: int, key:key)
                                        }
                                    )
                                  
                            }
                    }
                   
                }

                }
            }
            
            .navigationTitle("Todo List")
            .navigationBarItems(
                leading: VStack{
                    if !todos.list.isEmpty {
                        EditButton()
                    }
                },
                trailing: HStack{
                    HStack{
                        if !todos.list.isEmpty {
                            Picker("Fiter", selection: $todos.selectedStatus  ){
                                ForEach(0..<statuses.count){ statusIndex in
                                    Text(statusExpression[self.statuses[statusIndex]]?.title ?? "")
                                }
                            }
                            .onChange(of: todos.selectedStatus) { statusIndex in
                                todos.filterByStatus(status: statuses[statusIndex])
                                
                            }
                        }
                     
                        
                    }
                    Button {
                        isShowing = true
                    } label: {
                            Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            )
        }
        .sheet(isPresented: $isShowing){
            AddTodo(isShowing: $isShowing, deadline: Date.now, dismiss:{})
                
            
        }
     
        .environmentObject(todos)

    }
    
    func move(from:IndexSet, to: Int, key:String ){
        todos.list[key]?.move(fromOffsets: from, toOffset: to)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
