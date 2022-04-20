//
//  BaseCell.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 20.04.2022.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAutoLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupSubviews() {}
    func setupAutoLayout() {}
    func setupStyle() {
        backgroundColor = .white
    }
}
