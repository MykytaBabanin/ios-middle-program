//
//  ChatLogMessageCell.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 20.04.2022.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    lazy var messageTextView = UITextView()
    
    override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubviewAndDisableAutoresizing(textBubbleView)
        textBubbleView.addSubviewAndDisableAutoresizing(messageTextView)
    }
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupAutoLayout() {
        textBubbleView.pin(toEdges: messageTextView)
        messageTextView.pin(toEdges: contentView)
    }
    
    override func setupStyle() {
        messageTextView.font = .systemFont(ofSize: 18)
        messageTextView.textColor = .black
        messageTextView.backgroundColor = .clear
    }
}
