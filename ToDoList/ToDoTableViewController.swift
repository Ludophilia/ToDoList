//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Jeffrey on 22/11/2021.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    // MARK: - Model Data
    
    var toDos = [ToDo]()
    
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        toDos = ToDo.loadToDos() ?? ToDo.loadSampleToDos()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - ToDoCellDelegate Conformance
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete = !toDo.isComplete
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            try! ToDo.saveToDos(toDos: toDos) // YOLO 😎
        }
    }

    // MARK: - UITableViewDataSource Conformance

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? ToDoCell else { fatalError("Could not dequeue a cell") }
        let toDo = toDos[indexPath.row]
        
        cell.delegate = self
        cell.isCompleteButton.isSelected = toDo.isComplete
        cell.titleLabel.text = toDo.title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            try! ToDo.saveToDos(toDos: toDos) // YOLO 😎
        } 
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == "editToDo",
            let navigationController = segue.destination as? UINavigationController,
            let toDoDetailViewController = navigationController.topViewController as? ToDoDetailTableViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                toDoDetailViewController.toDo = toDos[selectedRow]
        }
        
    }
    
    @IBAction func unwindToDoList(segue: UIStoryboardSegue) {
        guard let sourceViewController = segue.source as? ToDoDetailTableViewController else { return }
        
        if segue.identifier == "saveUnwind", let toDo = sourceViewController.toDo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                toDos[selectedIndexPath.row] = toDo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                toDos.append(toDo)
                tableView.insertRows(at: [IndexPath(row: toDos.count - 1, section: 0)], with: .automatic)
            }
            try! ToDo.saveToDos(toDos: toDos) // YOLO 😎
        } else if segue.identifier == "cancelUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
        }
    }

}
