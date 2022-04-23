//
//  Tarefa.swift
//  ToDoApp
//
//  Created by Renato F. dos Santos Jr on 21/03/22.
//

import Foundation

typealias Tarefas = [Tarefa]

struct Tarefa {
    var id: UUID
    var taskDescription: String
    var createdAt: Date?
    var updatedAt: Date?
    var done: Bool
}

struct MockTarefas {
    static let dump: Tarefas = [.init(id: UUID(), taskDescription: "Primeira Tarefa", createdAt: Date.now, updatedAt: Date.now, done: false),
                                .init(id: UUID(), taskDescription: "Segunda Tarefa", createdAt: Date.now, updatedAt: Date.now, done: false),
                                .init(id: UUID(), taskDescription: "Terceira Tarefa", createdAt: Date.now, updatedAt: Date.now, done: false),
                                .init(id: UUID(), taskDescription: "Quarta Tarefa", createdAt: Date.now, updatedAt: Date.now, done: true),
                                .init(id: UUID(), taskDescription: "Quinta Tarefa", createdAt: Date.now, updatedAt: Date.now, done: true),
                                .init(id: UUID(), taskDescription: "Sexta Tarefa", createdAt: Date.now, updatedAt: Date.now, done: true),
                                .init(id: UUID(), taskDescription: "Sétima Tarefa", createdAt: Date.now, updatedAt: Date.now, done: true)]
}
