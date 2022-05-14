//
//  NotesCoordinator.swift
//  Notes
//
//

import UIKit
import CoreData

class NoteListCoordinator: Coordinator {
    private let router: Router
    private let folderId: NSManagedObjectID
    
    init(router: Router, folderId: NSManagedObjectID) {
        self.router = router
        self.folderId = folderId
    }
    
    func start() {
        let notesController: NoteListViewController = NoteListViewController.instantiate()
        notesController.viewModel = NoteListViewModel(coordinator: self, folderId: folderId)
        router.push(notesController)
    }
    
    func showNoteCreation() {
        NoteDetailsCoordinator(router: router, folderId: folderId).start()
    }
    
    func showNoteDetails(_ note: Note) {
        NoteDetailsCoordinator(router: router, folderId: folderId).start(note)
    }
}
