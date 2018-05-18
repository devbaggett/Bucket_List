//
//  ListVC.swift
//  Bucket_List
//
//  Created by Devin Baggett on 5/17/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [Note] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        
        fetchAllNotes()
        print(tableData)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // intermediate step
        if segue.identifier == "ItemSegue" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! ItemVC
            dest.delegate = self
            
            // EDIT button pressed
            if let indexPath = sender as? IndexPath {
                // prepopulate all fields
                let note = tableData[indexPath.row]
                // send note to destination
                dest.note = note
                // set indexPath
                dest.indexPath = indexPath
                
            }
            
        } else if segue.identifier == "InfoSegue" {
            let dest = segue.destination as! InfoVC
            let indexPath = sender as! IndexPath
            dest.note = tableData[indexPath.row]
        }
        
    }
    
    
    func fetchAllNotes(){
        let noteRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            tableData = try context.fetch(noteRequest)
        } catch {
            print("There was an error. \(error)")
        }
    }

}

// CREATE/UPDATE
extension ListVC: ItemVCDelegate {
    func donePressed(title: String, desc: String, date: Date, indexPath: IndexPath?) {
//        print(title, desc, date)
        
        
        // defining a variable and setting it equal to something or the other depending on below conditions
        let note: Note
        
        // if got indexPath
        if let ip = indexPath {
            // note is equal to the cell data clicked on
            note = tableData[ip.row]
        } else {
            // if not, create new note
            note = Note(context: context)
            // append to tableData array
            tableData.append(note)
        }
        
        // CREATE
        note.title = title
        note.desc = desc
        note.date = date
        saveContext()
        
        // if we have indexPath
        if let ip = indexPath {
            // instead of reload tableView data; reload single row, not entire tableView
            tableView.reloadRows(at: [ip], with: .automatic)
        } else {
            // otherwise generate indexPath and insert that row
            let indexPath = IndexPath(row: tableData.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
//        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
}


// extending class
extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BCell", for: indexPath) as! BCell
        let note = tableData[indexPath.row]
        
        // set labels
        cell.titleLabel.text = note.title
        cell.descLabel.text = note.desc
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // set date
        cell.dateLabel.text = dateFormatter.string(from: note.date!)
        
        
        return cell
    }
    
    
    // DELETE
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            print("delete")
            let note = tableData[indexPath.row]
            context.delete(note)
            tableData.remove(at: indexPath.row)
            saveContext()
            // more efficient than reloading tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // swipe right
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let updateAction = UIContextualAction(style: .normal, title:  "Edit") {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // handler does something once pressed
            self.performSegue(withIdentifier: "ItemSegue", sender: indexPath)
        }
        
        updateAction.backgroundColor = .blue
//
//        let otherAction = UIContextualAction(style: .normal, title:  "Other") {
//            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("OK, marked as Closed")
//            success(true)
//        }
//
//        otherAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [updateAction])
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "InfoSegue", sender: indexPath)
    }
    
}
