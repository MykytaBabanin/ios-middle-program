//
//  FoldersCoordintor.swift
//  Notes
//
//

import UIKit
import CoreData

class FolderListCoordinator: Coordinator {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        Database.shared.open { 
            let folderController: FolderListViewController = FolderListViewController.instantiate()
            folderController.viewModel = FolderListViewModel(coordinator: self)
            
            self.router.setRootController(folderController)
        }
    }
    
    func showNotesList(folderId: NSManagedObjectID) {
        NoteListCoordinator(router: router, folderId: folderId).start()
    }
}
