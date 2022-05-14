//
//  AppCoordinator.swift
//  Notes
//
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        FolderListCoordinator(router: router).start()
    }
}
