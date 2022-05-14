//
//  UIViewController+Extensions.swift
//  Notes
//
//

import UIKit

extension UIViewController {
    static func instantiate<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "\(T.self)") as? T
        else {
            fatalError("Main storyboard does not contain \(T.self)")
        }
        
        return controller
    }
}

extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension UITableViewController {
    func dequeueCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T.nibName(),
                                                       for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func createSortMenu(sortByName: @escaping ((UIAction) -> Void), sortByDate: @escaping ((UIAction) -> Void)) -> UIMenu {
        var actions = [UIAction]()
        
        let sortByNameAction = UIAction(title: "Sort by name", handler: sortByName)
        let sortByDateAction = UIAction(title: "Sort by date", handler: sortByDate)
        
        actions.append(sortByNameAction)
        actions.append(sortByDateAction)
        let menu = UIMenu(title: String(), children: actions)
        
        return menu
    }
}

extension Date {
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
                
        return formatter.string(from: self)
    }
}

public protocol SetupAccessibilityIdentifiers {
    func setupAccessibilityIdentifiers()
}

