//
//  AnimationController.swift
//  MOBT-8-Animations
//
//  Created by Mykyta Babanin on 28.05.2022.
//

import Foundation
import UIKit

enum AnimationType {
    case present
    case dismiss
}

class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    
    // MARK: - Init
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}


extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? .zero
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        let duration = transitionDuration(using: transitionContext)
        let scaleDown = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let moveOut = CGAffineTransform(translationX: -viewToAnimate.frame.width, y: 0)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.25) {
                viewToAnimate.transform = scaleDown.rotated(by: CGFloat.pi)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5,
                               relativeDuration: 0.25) {
                viewToAnimate.transform = scaleDown.concatenating(moveOut).scaledBy(x: 0.1, y: 0.1)
                viewToAnimate.alpha = 0
            }
            
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        let duration = transitionDuration(using: transitionContext)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}
