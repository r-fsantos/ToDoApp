//
//  ManagedObjectContext.swift
//  ToDoApp
//
//  Created by Renato F. dos Santos Jr on 21/03/22.
//

import UIKit
import CoreData
import Foundation

typealias onCompletionHandler = (String) -> Void

protocol managedProtocol {
    func getTarefas() -> Tarefas
}

protocol managedDoneProtocol {
    func getDoneTarefas() -> Tarefas
}

protocol managedUndoneProtocol {
    func getUndoneTarefas() -> Tarefas
}

protocol managedSaveProtocol {
    func save(tarefa: Tarefa,
              onCompletionHandler: onCompletionHandler)
}

protocol managedDeleteProtocol {
    func delete(uuid: String,
                onCompletionHandler: onCompletionHandler)
}


class ManagedObjectContext {
    
    private let entity = "TarefaEntity"
    
    static var shared: ManagedObjectContext = {
        let instance = ManagedObjectContext()
        return instance
    }()
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext // ?
    }
}

extension ManagedObjectContext: managedProtocol {
    
    func getTarefas() -> Tarefas {
        var listTarefas: Tarefas = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        do {
            guard let tarefas = try getContext().fetch(fetchRequest) as? [NSManagedObject] else { return listTarefas }
            
            for item in tarefas {
                if let id = item.value(forKey: "id") as? UUID,
                   let taskDescription = item.value(forKey: "taskDescription") as? String,
                   let createdAt = item.value(forKey: "createdAt") as? Date,
                   let updatedAt = item.value(forKey: "updatedAt") as? Date,
                   let done = item.value(forKey: "done") as? Bool {
                    
                    let tarefa = Tarefa(id: id,
                                        taskDescription: taskDescription,
                                        createdAt: createdAt,
                                        updatedAt: updatedAt,
                                        done: done)
                    listTarefas.append(tarefa)
                }
            }
        } catch let error as NSError {
            print("Error in request \(error.localizedDescription)")
        }
        
        return listTarefas
    }
}

extension ManagedObjectContext: managedSaveProtocol {
    func save(tarefa: Tarefa, onCompletionHandler: (String) -> Void) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context) else { return }
        
        let transaction = NSManagedObject(entity: entity, insertInto: context)
        transaction.setValue(tarefa.id, forKey: "id")
        transaction.setValue(tarefa.taskDescription, forKey: "taskDescription")
        transaction.setValue(tarefa.createdAt, forKey: "createdAt")
        transaction.setValue(tarefa.updatedAt, forKey: "updatedAt")
        transaction.setValue(tarefa.done, forKey: "done")
        
        do {
            try context.save()
            onCompletionHandler("Entity \(tarefa) Sucessfully saved")
        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }
    }
}

extension ManagedObjectContext: managedDoneProtocol {
    func getDoneTarefas() -> Tarefas {
        let listTarefas = getTarefas()
        
        let listDoneTarefas = listTarefas.filter { $0.done == true}
        
        return listDoneTarefas
    }
}

extension ManagedObjectContext: managedUndoneProtocol {
    func getUndoneTarefas() -> Tarefas {
        let listTarefas = getTarefas()
        
        let listDoneTarefas = listTarefas.filter { $0.done == false}
        
        return listDoneTarefas
    }
}

extension ManagedObjectContext: managedDeleteProtocol {
    func delete(uuid: String, onCompletionHandler: onCompletionHandler) {
        let context = getContext()
        let predicate = NSPredicate(format: "id == %@", "\(uuid)")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityDelete = fetchResults.first {
                context.delete(entityDelete)
                onCompletionHandler("Successfully deleted")
                return
            }
            
            try context.save()
            
            onCompletionHandler("Entity Does Not exist")
        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }
    }
}
