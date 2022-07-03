//
//  ViewController.swift
//  MOBT-11-App-Extension
//
//  Created by Mykyta Babanin on 03.07.2022.
//

import UIKit

fileprivate struct SharedData {
    var text: String?
    var image: UIImage?
    var url: URL?
    
    init(text: String?, image: UIImage?, url: URL?) {
        self.text = text
        self.image = image
        self.url = url
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var shareURLButton: UIButton!
    @IBOutlet weak var shareImageButton: UIButton!
    @IBOutlet weak var shareTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        shareTextButton.addTarget(self, action: #selector(shareTextButtonTapped), for: .touchUpInside)
        shareImageButton.addTarget(self, action: #selector(shareImageButtonTapped), for: .touchUpInside)
        shareURLButton.addTarget(self, action: #selector(shareURLButtonTapped), for: .touchUpInside)
    }
    
    @objc private func shareTextButtonTapped(sender: UIBarButtonItem) {
        shareService(getSharedData().text, sender: sender)
    }
    
    @objc private func shareImageButtonTapped(sender: UIBarButtonItem) {
        shareService(getSharedData().image, sender: sender)
    }
    
    @objc private func shareURLButtonTapped(sender: UIBarButtonItem) {
        shareService(getSharedData().url, sender: sender)
    }
    
    private func shareService<T>(_ sharedSubject: T, sender: UIBarButtonItem) {
        let activity = UIActivityViewController(
            activityItems: [sharedSubject],
            applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = sender
        present(activity, animated: true, completion: nil)
    }
    
    private func getSharedData() -> SharedData {
        let sharedText = "Some text"
        let sharedImage = UIImage(named: "cat")
        if let sharedURL = URL(string: "https://github.com/MykytaBabanin/ios-middle-program") {
            let sharedData = SharedData(text: sharedText,
                                        image: sharedImage,
                                        url: sharedURL)
            
            return sharedData
        }
        return SharedData(text: nil, image: nil, url: nil)
    }
}

