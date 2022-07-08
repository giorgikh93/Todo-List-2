//
//  AddTodo.swift
//  Todo-List-2
//
//  Created by giorgi on 25.06.22.
//

import SwiftUI

struct AddTodo: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todosService: TodoList
    @Binding var isShowing: Bool
    @State var text = ""
    @State var deadline: Date
    var todo: Todo?
    
    private var buttonTitle:String {
        if todo != nil {
            return "Edit"
        }
        return "Save"
    }
 
    private var isEditMode: Bool {
        if todo != nil {
            return true
        }
        return false
    }
    
    var dismiss: () -> Void
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:10){
                    TextField("Type new todo here...", text: $text)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .background(Color("Ggray"))
                        .cornerRadius(10)
                   
                    DatePicker("Create Your Deadline: ", selection: $deadline, displayedComponents: [.date])
                        .padding()

                    Button(action: save, label: {
                        Text(buttonTitle)
                            .frame(maxWidth:.infinity)
                            .frame(height:55)
                            .background(.blue)
                            .cornerRadius(10)
                           .font(.headline)
                           .foregroundColor(.white)
                        
                    })
                        
                }
                .alert(alertMessage, isPresented: $isShowingAlert) {
                    Button("OK", role:.cancel){
                        isShowingAlert = false
                        alertMessage = ""
                    }
                    
                }
                .padding(14)
                .navigationTitle("Add an Item")
             
            }
           
        }
    }
    func save(){
        if text.isEmpty {
            isShowingAlert = true
            alertMessage = "Todo title is required!"
            return
        }
        let formattedDate = deadline.toString()
        
        if isEditMode {
            todosService.updateTodo(todo: todo ?? Todo(text: "", deadline: deadline, status: .initial), text: text, key: formattedDate, deadline: deadline)
            presentationMode.wrappedValue.dismiss()
            return
        }
        todosService.add(text:text, key:formattedDate, deadline: deadline)
        if isShowing != nil {
            isShowing = false
        }
        presentationMode.wrappedValue.dismiss()
    }
    
}

