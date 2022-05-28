//
//  FirstViewController+TransitioningDelegate.swift
//  MOBT-8-Animations
//
//  Created by Mykyta Babanin on 28.05.2022.
//

import Foundation
import UIKit
import CoreGraphics

class TransitionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        self.transitioningDelegate = self
        createSnowEmitterLayer()
    }
    
    func createSnowEmitterLayer() {
        guard let snowflakesImage = UIImage(named: "snowflake") else { return }
        let emitter = Emitter.get(with: snowflakesImage)
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension TransitionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 3, animationType: .dismiss)
    }
}
