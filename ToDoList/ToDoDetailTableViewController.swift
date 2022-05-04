//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Jeffrey on 25/11/2021.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    // MARK: - Model data
    
    var toDo: ToDo?
    
    // MARK: - UI Components

    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dueDateLabel: UILabel!
    var isPickerHidden = true
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    
    // MARK: - "Basic Info" UI Events Response
    
    func updateSaveButtonState() {
        saveButton.isEnabled = !(titleTextField.text == "")
    }

    @IBAction func titleTextFieldEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        // In this case, Primary Action Event is triggered when return key is pressed
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    // MARK: - "Due Date" UI Events Response

    func updateDueDateLabel(firstUpdate: Bool = false, date: Date) {
        if firstUpdate { dueDatePicker.minimumDate = Date() }
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: dueDatePicker.date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        // In this case, Primary Action Event is triggered when datePicker's date changes
        updateDueDateLabel(date: dueDatePicker.date)
    }
    
    // MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let toDoToEdit = toDo {
            titleTextField.text = toDoToEdit.title
            isCompleteButton.isSelected = toDoToEdit.isComplete
            dueDatePicker.date = toDoToEdit.dueDate
            notesTextView.text = toDoToEdit.notes ?? ""
        } else {
            dueDatePicker.date = Date().addingTimeInterval(24*60*60)
            updateSaveButtonState()
        }
        
        updateDueDateLabel(firstUpdate: true, date: dueDatePicker.date)
    }
    
    // MARK: - UITableViewDelegate Conformance
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let datePickerIndexPath = IndexPath(row: 1, section: 1)
        let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
        
        let normalCellHeight: CGFloat = 44
        let largeCellHeight: CGFloat = 162
        let extraLargeCellHeight: CGFloat = 200

        switch indexPath {
        case datePickerIndexPath:
            return isPickerHidden ? 0 : largeCellHeight
        case notesTextViewIndexPath:
            return extraLargeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dueDateLabelIndexPath = IndexPath(row: 0, section: 1)
        let datePickerIndexPath = IndexPath(row: 1, section: 1)

        if indexPath == dueDateLabelIndexPath {
            isPickerHidden = !isPickerHidden
            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            tableView.reloadRows(at: [dueDateLabelIndexPath, datePickerIndexPath], with: .none)
            // tableView.beginUpdates() ; tableView.endUpdates() // Not working as expected on at least Simulator
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePicker.date
        let notes = notesTextView.text
        
        toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    
}
