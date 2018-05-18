//
//  ItemVC.swift
//  Bucket_List
//
//  Created by Devin Baggett on 5/17/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit

protocol ItemVCDelegate: class {
    func donePressed(title: String, desc: String, date: Date, indexPath: IndexPath?)
}

class ItemVC: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: ItemVCDelegate!
    var note: Note?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if have note, take all data out of note and put into fields
        if let n = note {
            titleField.text = n.title
            descField.text = n.desc
            datePicker.date = n.date!
        }

    }

  
    @IBAction func cancelButtonPushed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let title = titleField.text!
        let desc = descField.text!
        let date = datePicker.date
        
        delegate.donePressed(title: title, desc: desc, date: date, indexPath: indexPath)
    }
    
}
