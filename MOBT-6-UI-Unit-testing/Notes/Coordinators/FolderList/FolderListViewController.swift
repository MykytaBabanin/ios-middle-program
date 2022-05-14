//
//  FolderTableViewController.swift
//  Notes
//
//

import UIKit
import CoreData

class FolderListViewController: UITableViewController, SetupAccessibilityIdentifiers {
    
    @IBOutlet weak var addFolderButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    var viewModel: FolderListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        createSortMenu()
        setupAccessibilityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchedResultsController.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.fetchedResultsController.delegate = nil
    }
    
    @IBAction private func addFolderButtonAction(_ sender: UIBarButtonItem) {
        present(createAlertController(), animated: true)
    }
    
    private func createAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "New Folder",
                                      message: "Enter a name for this folder.",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text,
                  let self = self else { return }
            self.viewModel.createFolder(name: nameToSave)
            self.tableView.reloadData()
        }
        
        saveAction.accessibilityIdentifier = "saveButton"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { textField in
            textField.accessibilityIdentifier = "textField"
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        return alert
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FolderViewCell = dequeueCell(indexPath: indexPath)
        
        cell.setupViews(folder: viewModel.fetchedResultsController.object(at: indexPath))
        cell.accessibilityLabel = cell.folderNameLabel.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(folder: viewModel.fetchedResultsController.object(at: indexPath))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.showNotesList(folder: viewModel.fetchedResultsController.object(at: indexPath))
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: FolderViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: FolderViewCell.nibName())
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
    
    func setupAccessibilityIdentifiers() {
        sortButton.accessibilityIdentifier = "sortButton"
        addFolderButton.accessibilityIdentifier = "addFolderButton"
    }
}

extension FolderListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
               let folder = anObject as? Folder,
               let cell = tableView.cellForRow(at: indexPath) as? FolderViewCell {
                cell.setupViews(folder: folder)
            }
        default:
            break
        }
    }
}
