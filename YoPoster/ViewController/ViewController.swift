//
//  ViewController.swift
//  YoPoster
//
//  Created by Yi-Chin Hsu on 2023/7/8.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    enum ShareDestination {
        case instagram
        case twitter
    }
    
    // MARK: - Subviews
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var pickerImageView: UIImageView!
    
    // MARK: - Properties
    private var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestures()
        setupBarButtonItems()
    }
    
    private func setupUI() {
        title = "Yodeila"
        postTextView.layer.cornerRadius = 12
        postTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        pickerImageView.layer.cornerRadius = 12
    }
    
    private func setupGestures() {
        let pickerImageViewTapped = UITapGestureRecognizer(target: self, action: #selector(pickerImageViewTapped))
        pickerImageView.addGestureRecognizer(pickerImageViewTapped)
        
        let backgroundViewTapped = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        view.addGestureRecognizer(backgroundViewTapped)
    }
    
    private func setupBarButtonItems() {
        shareBarButtonItem.menu = UIMenuActionBuilder()
            .actions {
                Action(title: "Instagram") { [weak self] _ in
                    self?.share(to: .instagram)
                }
                Action(title: "Twitter") { [weak self] _ in
                    self?.share(to: .twitter)
                }
            }
            .build()
    }
    
    private func share(to destination: ShareDestination) {
        var items: [Any] = []
        
        switch destination {
        case .instagram:
            UIPasteboard.general.string = postTextView.text
            items = [image]
        case .twitter:
            items = [postTextView.text, image]
        }
        
        share(with: items)
    }
    
    private func share(with items: [Any]) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.excludedActivityTypes = [.message, .mail]
        present(ac, animated: true)
    }
    
    @objc private func pickerImageViewTapped() {
        showPhotoPicker()
    }
    
    @objc private func backgroundViewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func resetBarButtonTapped(_ sender: Any) {
        postTextView.text = ""
        image = nil
        pickerImageView.contentMode = .center
        pickerImageView.image = UIImage(systemName: "photo.on.rectangle")
    }
}

// MARK: - Image Picker
extension ViewController: PHPickerViewControllerDelegate {
    
    func showPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.first?.itemProvider.loadObject(ofClass: UIImage.self) { result, error in
            guard let pickedImage = result as? UIImage, error == nil else { return }
            DispatchQueue.main.async {
                self.image = pickedImage
                self.pickerImageView.contentMode = .scaleAspectFill
                self.pickerImageView.image = pickedImage
            }
        }
    }
}
