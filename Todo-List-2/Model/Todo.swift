//
//  Todo.swift
//  Todo-List-2
//
//  Created by giorgi on 25.06.22.
//

import Foundation
import SwiftUI



enum Status: Codable, Equatable {
    case completed
    case inProgress
    case initial
    case overdue
    case all
}

struct StatusExpression {
    let title: String
    let color: Color
}

var statusExpression = [
    Status.inProgress: StatusExpression(title: "In Progress", color: Color.yellow),
    Status.overdue: StatusExpression(title: "Overdue", color: Color.red),
    Status.completed: StatusExpression(title: "Done", color: Color.green),
    Status.initial: StatusExpression(title: "Todo", color: Color.primary),
    Status.all: StatusExpression(title: "All Todos", color: Color.primary)
]

class Todo: Identifiable, Codable {
    let id:String
    let text: String
    let isCompleted:Bool
    let deadline: Date
    var status:Status
    var hidden: Bool
    
    init(id:String = UUID().uuidString, text:String, isCompleted:Bool? = false, deadline:Date, status:Status, hidden:Bool? = false){
        self.id = id
        self.text = text
        self.isCompleted =  isCompleted!
        self.status =   status
        self.deadline = deadline
        self.hidden = hidden ?? false
    }
    
}
