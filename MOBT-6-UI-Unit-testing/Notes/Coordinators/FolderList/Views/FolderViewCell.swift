//
//  TableViewCell.swift
//  Notes
//
//

import UIKit

class FolderViewCell: UITableViewCell, SetupAccessibilityIdentifiers {

    @IBOutlet weak var notesCountLabel: UILabel!
    @IBOutlet weak var folderNameLabel: UILabel!
    
    func setupViews(folder: Folder) {
        notesCountLabel.text = String(folder.notes?.count ?? 0)
        folderNameLabel.text = folder.name
        setupAccessibilityIdentifiers()
    }
    
    func setupAccessibilityIdentifiers() {
        notesCountLabel.accessibilityIdentifier = "notesCountLabel"
        folderNameLabel.accessibilityIdentifier = "folderNameLabel"
        folderNameLabel.accessibilityLabel = folderNameLabel.text
    }
}
