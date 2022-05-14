//
//  NotesViewModel.swift
//  Notes
//
//

import UIKit
import CoreData

class NoteListViewModel {
    private let folderId: NSManagedObjectID
    private let coordinator: NoteListCoordinator
    private var sort: SortCondition = .creationDate
    
    var fetchedResultsController: NSFetchedResultsController<Note>
    
    init(coordinator: NoteListCoordinator, folderId: NSManagedObjectID) {
        self.coordinator = coordinator
        self.folderId = folderId
        self.fetchedResultsController = Note.createFetchedResultsController(sort: sort, folderId: folderId)
        try? self.fetchedResultsController.performFetch()
    }

    func addNoteTapped() {
        coordinator.showNoteCreation()
    }
    
    func delete(note: Note) {
        note.delete()
    }
    
    func tappedNote(note: Note) {
        coordinator.showNoteDetails(note)
    }
    
    func sort(by sort: SortCondition) {
        guard sort != self.sort else { return }
        self.sort = sort
        
        let delegate = fetchedResultsController.delegate
        fetchedResultsController = Note.createFetchedResultsController(sort: sort, folderId: folderId)
        fetchedResultsController.delegate = delegate
        
        try? fetchedResultsController.performFetch()
    }
}
