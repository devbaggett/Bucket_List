//
//  InfoVC.swift
//  Bucket_List
//
//  Created by Devin Baggett on 5/17/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = note.title
        descLabel.text = note.desc
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // set date
        dateLabel.text = dateFormatter.string(from: note.date!)
        
    }


}
