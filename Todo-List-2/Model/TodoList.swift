//
//  TodoList.swift
//  Todo-List-2
//
//  Created by giorgi on 25.06.22.
//

import Foundation


class TodoList:ObservableObject {
    @Published var list: [String:[Todo]]
    @Published var selectedStatus: Int = 4
    private var isFiltered = false

    let defaults = UserDefaults.standard
    private let key = "todos"

    init(){
        if let data = defaults.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode([String:[Todo]].self, from:data){
                decoded.keys.forEach({ key in
                    if key.toDate().isInThePast {
                        decoded[key]?.forEach{ if $0.status == .initial {
                            $0.status = .overdue
                        }
                            
                    }
                        
                }
                })
              
                list = decoded
                
                return
            }
        }
        list = [:]
        
    }
    

    
    func add(text:String, key:String, deadline:Date, isCompleted:Bool? = false, status:Status? = .initial) {
        var status = status
        if status == .initial && !deadline.isInSameDay(as: Date.now) && deadline.isInThePast {
            status = Status.overdue
        }
        let todo = Todo(text: text, isCompleted: isCompleted, deadline: deadline, status: status ?? Status.initial)

        if list[key] != nil {
            list[key]?.append(todo)
        } else {
            list[key] = [todo]
            
        }
        let filtered = list
        resetFilter(dict: filtered)
      save()
    }
    
    func deleteTodo(indexSet:IndexSet, key:String) {
        list[key]?.remove(atOffsets: indexSet)
    
        if list[key] == nil || list[key]?.count == 0 {
            list.removeValue(forKey: key)
        }
        save()
    }
    
    func toggle(todo:Todo, key:String){
        if let index = list[key]?.firstIndex(where: { $0.id == todo.id }) {
            list[key]?[index] = Todo(
                text: todo.text,
                isCompleted: !todo.isCompleted,
                deadline: todo.deadline,
                status: todo.status == .completed ? .initial : .completed )
            
            list[key] = list[key]?.sorted { !$0.isCompleted && $1.isCompleted }
            
        }
        save()
    }
    
    func setStatus(todo:Todo, key:String, status: Status) {
        if let index = list[key]?.firstIndex(where: { $0.id == todo.id }) {
            list[key]?[index] = Todo(text: todo.text, isCompleted: status == .completed ? true : false, deadline: todo.deadline, status: status )
            
            list[key] = list[key]?.sorted { !$0.isCompleted && $1.isCompleted }
        }
        if isFiltered {
            let filtered = list
            resetFilter(dict: filtered)
            
        }
        save()

    }
    
    func updateTodo(todo:Todo, text:String, key:String, deadline:Date) {
        let sameDay = deadline.isInSameDay(as: todo.deadline)
        if !sameDay {
            let formattedDate = deadline.formatted(date: .long, time: .omitted)
            let prevDate = todo.deadline.formatted(date: .long, time: .omitted)
            if  let index = list[prevDate]?.firstIndex(where: { $0.text == text }){
                  list[prevDate]?.remove(at: index)
                    if list[prevDate] == nil || list[prevDate]?.count == 0 {
                        list.removeValue(forKey: prevDate)
                    }
            }
            add(text: text, key: formattedDate, deadline: deadline, isCompleted: todo.isCompleted, status: todo.status )
            return
        }
       
        if let index = list[key]?.firstIndex(where: { $0.id == todo.id }) {
            list[key]?[index] = Todo(text: text, isCompleted: todo.isCompleted, deadline: deadline, status:todo.status)
        }
   
   
        save()
    }
    
    func filterByStatus(status:Status) {
       let filtered = list
        
        if status != .all {
            filtered.keys.forEach { key in
                filtered[key]?.forEach({ todo in
                    if todo.status == status {
                        todo.hidden = false
                    }else{
                        todo.hidden = true
                    }
                  
                })
            }
          
            isFiltered = true
            list = filtered
        }else{
            resetFilter(dict:filtered)
            
        }
        
        
    }
    
    func resetFilter(dict:[String:[Todo]]) {
        dict.keys.forEach { key in
            dict[key]?.forEach({ todo in
                    todo.hidden = false
            })
        }
        isFiltered = false
        list = dict
        selectedStatus = 4
        
    }
    
    func save(){
        
            if let encoded = try? JSONEncoder().encode(list) {
                defaults.set(encoded, forKey: key)
                
        }
    }
}
