//
//  UIView+Helper.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 20.04.2022.
//

import UIKit

extension UIView {
    func addSubviewAndDisableAutoresizing(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pin(toEdges containerView: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -constant),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constant)
        ])
    }
}
