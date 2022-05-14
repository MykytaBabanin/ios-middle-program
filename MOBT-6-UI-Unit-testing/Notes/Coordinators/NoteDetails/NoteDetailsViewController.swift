//
//  NoteDetailsViewController.swift
//  Notes
//
//

import UIKit

class NoteDetailsViewController: UIViewController, SetupAccessibilityIdentifiers {
    var viewModel: NoteDetailsViewModel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
        dateLabel.text = viewModel.creationDateTitle
        noteTextView.text = viewModel.body
        
        setupAccessibilityIdentifiers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let text = noteTextView.text {
            viewModel.update(body: text)
        }
    }
    
    func setupAccessibilityIdentifiers() {
        dateLabel.accessibilityIdentifier = "dateLabel"
        noteTextView.accessibilityIdentifier = "noteTextView"
    }
}
