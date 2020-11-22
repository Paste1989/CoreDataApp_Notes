//
//  NoteTableViewCell.swift
//  CoreDataApp
//
//  Created by SS on 20.11.2020..
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupNoteTableViewCell(title: String, date: String) {
        self.title.text = title
        self.date.text = date
    }
}
