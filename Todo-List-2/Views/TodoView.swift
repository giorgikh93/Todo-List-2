//
//  TodoView.swift
//  Todo-List-2
//
//  Created by giorgi on 25.06.22.
//

import SwiftUI

struct TodoView: View {
    var todo: Todo
    var key:String
    @EnvironmentObject var todoService: TodoList
    var body: some View {
        HStack{
            Image(systemName: todo.isCompleted ?  "checkmark.circle" : "circle")
                .foregroundColor( todo.isCompleted ? .green : .red)
                .onTapGesture {
                    todoService.toggle(todo: todo, key:key)
                }
            VStack{
                Text(todo.text)
                    .frame(maxWidth:200, alignment: .leading)
                    .disableAutocorrection(false)
            
            }
          

            Spacer()
            Text(statusExpression[todo.status]?.title ?? "")
                .foregroundColor(statusExpression[todo.status]?.color)
                .font(.callout)
        }
                .contextMenu {
                      VStack{
                          Button("Todo"){
                              todoService.setStatus(todo: todo, key: key, status: .initial)
                          }

                          Button("In progress"){
                              todoService.setStatus(todo: todo, key: key, status: .inProgress)
                          }
                          Button("Complete"){
                              todoService.setStatus(todo: todo, key: key, status: .completed)
                          }
                          
                      }
                  }
    }
}

struct TodoView_Previews: PreviewProvider {
    
    static var previews: some View {
        TodoView(todo: Todo(text: "Learn swift", isCompleted: true, deadline: Date.now, status: .initial), key: "05/21/2022")
    }
}
