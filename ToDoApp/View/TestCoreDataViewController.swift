//
//  ViewController.swift
//  ToDoApp
//
//  Created by Renato F. dos Santos Jr on 21/03/22.
//

import UIKit

class TestCoreDataViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getTarefas() {
        let tarefas: Tarefas = ManagedObjectContext.shared.getTarefas()
        
        _ = tarefas.map { print($0) }
    }
    
    @IBAction func getUndoneTarefas() {
        let tarefas: Tarefas = ManagedObjectContext.shared.getUndoneTarefas()
        
        _ = tarefas.map { print($0) }
    }
    
    @IBAction func getDoneTarefas() {
        let tarefas: Tarefas = ManagedObjectContext.shared.getDoneTarefas()
        
        _ = tarefas.map { print($0) }
    }
    
    @IBAction func save() {
        _ = MockTarefas.dump.map {
            ManagedObjectContext.shared.save(tarefa: $0) { print($0) }
        }
    }
    
    @IBAction func delete() {
        let tarefasDone = ManagedObjectContext.shared.getDoneTarefas() as Tarefas
        
        _ = tarefasDone.map {
            ManagedObjectContext.shared.delete(uuid: $0.id.description) { print($0) }
        }
    }
}

