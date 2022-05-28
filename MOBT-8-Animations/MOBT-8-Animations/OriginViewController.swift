//
//  ViewController.swift
//  MOBT-8-Animations
//
//  Created by Mykyta Babanin on 25.05.2022.
//

import UIKit

class OriginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func executeTransition(_ sender: Any) {
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TransitionViewController") as? TransitionViewController else { return }
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
}



