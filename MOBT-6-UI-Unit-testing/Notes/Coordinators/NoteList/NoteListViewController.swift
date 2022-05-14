//
//  NoteListViewController.swift
//  Notes
//
//

import UIKit
import CoreData

class NoteListViewController: UITableViewController, SetupAccessibilityIdentifiers {
    
    var viewModel: NoteListViewModel!
    
    @IBOutlet weak var addNoteButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var notesCountLabel: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchedResultsController.delegate = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: NoteViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: NoteViewCell.nibName())
        createSortMenu()
        updateToolBar()
        setupAccessibilityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: true)
    }

    @IBAction func addNoteButtonAction(_ sender: UIBarButtonItem) {
        viewModel.addNoteTapped()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteViewCell = dequeueCell(indexPath: indexPath)
        
        cell.setupView(note: viewModel.fetchedResultsController.object(at: indexPath))
        cell.isAccessibilityElement = true
        cell.setupAccessibilityIdentifiers()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.tappedNote(note: viewModel.fetchedResultsController.object(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(note: viewModel.fetchedResultsController.object(at: indexPath))
        }
    }
    
    private func createSortMenu() {
        sortButton.menu = createSortMenu(sortByName: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.sort(by: .name)
            self.tableView.reloadData()
        }, sortByDate: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.sort(by: .creationDate)
            self.tableView.reloadData()
        })
    }
    
    private func updateToolBar() {
        notesCountLabel.title = "\(viewModel.fetchedResultsController.sections?.first?.numberOfObjects ?? 0) notes"
    }
}

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateToolBar()
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath,
               let note = anObject as? Note,
               let cell = tableView.cellForRow(at: indexPath) as? NoteViewCell {
                cell.setupView(note: note)
            }
        default:
            break
        }
    }
    func setupAccessibilityIdentifiers() {
        sortButton.accessibilityIdentifier = "sortButton"
        notesCountLabel.accessibilityIdentifier = "notesCountLabel"
        addNoteButton.accessibilityIdentifier = "addNoteButton"
    }
}
