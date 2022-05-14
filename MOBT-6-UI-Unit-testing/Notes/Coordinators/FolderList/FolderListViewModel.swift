//
//  FolderViewModel.swift
//  Notes
//
//

import UIKit
import CoreData

class FolderListViewModel {
    private let coordinator: FolderListCoordinator
    private var sort: SortCondition = .creationDate
    
    var fetchedResultsController: NSFetchedResultsController<Folder>
    
    internal init(coordinator: FolderListCoordinator) {
        self.coordinator = coordinator
        self.fetchedResultsController = Folder.createFetchedResultsController(sort: sort)
        try? self.fetchedResultsController.performFetch()
    }

    func createFolder(name: String) {
        guard !name.isEmpty else { return }
        
        Folder.create(name: name, creationDate: Date(), completion: { _ in })
    }
    
    func delete(folder: Folder) {
        folder.delete()
    }

    func showNotesList(folder: Folder) {
        coordinator.showNotesList(folderId: folder.objectID)
    }
    
    func sort(by sort: SortCondition) {
        guard sort != self.sort else { return }
        self.sort = sort
        
        let delegate = self.fetchedResultsController.delegate
        
        fetchedResultsController = Folder.createFetchedResultsController(sort: sort)
        fetchedResultsController.delegate = delegate
        
        try? self.fetchedResultsController.performFetch()
    }
}
