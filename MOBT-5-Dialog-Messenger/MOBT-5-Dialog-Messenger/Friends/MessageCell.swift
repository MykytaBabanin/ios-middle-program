//
//  MessageCell.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 20.04.2022.
//

import UIKit

class MessageCell: BaseCell {
    private enum Layout {
        static let profileImageEstimatedLeadingAnchor: CGFloat = 14
        static let dividerLineEstimatedHeight: CGFloat = 1
        static let containerViewInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 80)
        static let nameLabelEstimatedTopAnchor: CGFloat = 4
        static let messageLabelEstimatedBottomAnchor: CGFloat = 5
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/225, blue: 249/255, alpha: 1) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            profileImageView.image = UIImage(named: message?.friend?.profileImageName ?? "")
            hasReadImageView.image = UIImage(named: message?.friend?.profileImageName ?? "")

            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    private lazy var profileImageView = UIImageView()
    private lazy var dividerLineView = UIView()
    private lazy var nameLabel = UILabel()
    private lazy var messageLabel = UILabel()
    private lazy var timeLabel = UILabel()
    private lazy var hasReadImageView = UIImageView()
    private lazy var contentStackView = UIStackView()
    
    override func setupSubviews() {
        contentView.addSubviewAndDisableAutoresizing(contentStackView)
        contentStackView.addSubviewAndDisableAutoresizing(profileImageView)
        contentStackView.addSubviewAndDisableAutoresizing(dividerLineView)
        contentStackView.addSubviewAndDisableAutoresizing(nameLabel)
        contentStackView.addSubviewAndDisableAutoresizing(messageLabel)
        contentStackView.addSubviewAndDisableAutoresizing(timeLabel)
        contentStackView.addSubviewAndDisableAutoresizing(hasReadImageView)
    }
    
    override func setupAutoLayout() {
        contentStackView.pin(toEdges: contentView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 12),
            
            messageLabel.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: hasReadImageView.leadingAnchor, constant: -30),
            
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -10),
            timeLabel.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            
            hasReadImageView.widthAnchor.constraint(equalToConstant: 30),
            hasReadImageView.heightAnchor.constraint(equalToConstant: 30),
            hasReadImageView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -10),
            hasReadImageView.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            hasReadImageView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            hasReadImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            
            dividerLineView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            dividerLineView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: hasReadImageView.leadingAnchor),
        ])
    }
    
    override func setupStyle() {
        profileImageView.layer.cornerRadius = 34
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 18)
        
        messageLabel.textColor = .darkGray
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 2
        
        dividerLineView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 16)
        
        hasReadImageView.layer.cornerRadius = 10
        hasReadImageView.layer.masksToBounds = true
        hasReadImageView.contentMode = .scaleAspectFill
    }
}
