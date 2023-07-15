//
//  ViewController.swift
//  YoPoster
//
//  Created by Yi-Chin Hsu on 2023/7/8.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBarButtonItems()
    }
    
    private func setupUI() {
        title = "YoPoster"
        postTextView.layer.cornerRadius = 12
        postTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func setupBarButtonItems() {
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.red)
        let shareToInstagramAction = UIAction(
            title: "Instagram",
            image: nil,
            handler: { [weak self] action in
                let items: [Any] = [
                    image,
                ]
                self?.share(with: items)
            }
        )
        
        let shareToTwitterAction = UIAction(
            title: "Twitter",
            image: nil,
            handler: { [weak self] action in
                let items: [Any] = [
                    self?.postTextView.text,
                    image,
                ]
                
                self?.share(with: items)
            }
        )
        
        let menu = UIMenu(children: [shareToInstagramAction, shareToTwitterAction])
        shareBarButtonItem.menu = menu
    }
    
    private func share(with items: [Any]) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.excludedActivityTypes = [.message, .mail]
        present(ac, animated: true)
    }
}
