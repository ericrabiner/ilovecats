//
//  CatEdit.swift
//  ILoveCats
//
//  Created by eric on 2019-10-29.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

protocol CatEditDelegate: AnyObject {
    func editTaskDidCancel(_ controller: UIViewController)
    func editTask(_ controller: UIViewController, didSave item: CatUpdated)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class CatEdit: UIViewController {
    
    // MARK: - Instance variables
    weak var delegate: CatEditDelegate?
    var m: DataModalManager!
    var cat: Cat!
    var catUpdated: CatUpdated?
    var catImageUrl: String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var catRating: UISegmentedControl!
    @IBOutlet weak var catPhoto: UIImageView!
    @IBOutlet weak var catPhotoButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ownerName.text = cat.ownerName
        catRating.selectedSegmentIndex = cat.rating - 1
        errorMessage.text?.removeAll()
        
        if cat.photoUrl.contains("https://") {
            guard let imageURL = URL(string: cat.photoUrl) else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.catPhoto.image = image
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("CatPutWasSuccessful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateImageUI), name: Notification.Name("CatPhotoIsReady"), object: nil)
    }
    
    @objc func updateUI() {
        self.errorMessage.text = "Save was successful!"
    }
    
    @objc func updateImageUI() {
        guard let imageURL = URL(string: m.catData!.url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.catImageUrl = self.m.catData!.url
                self.catPhoto.image = image
            }
        }
    }
    
    // MARK - Actions
    @IBAction func updatePhotoPressed(_ sender: Any) {
        m.catGetImage(cat.breedId)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.editTaskDidCancel(self)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        // Force keyboard to disappear
        ownerName.resignFirstResponder()
        
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validation before saving
        if ownerName.text!.isEmpty {
            errorMessage.text = "Owner name cannot be empty."
            return
        }
        // Validation Passes here
        
        // Create a cat Object
        errorMessage.text = "Attempting to save..."
        
        catUpdated = CatUpdated(_id: cat._id!, ownerName: ownerName.text!, rating: catRating.selectedSegmentIndex + 1, photoUrl: catImageUrl)
        
        // Send the request
        m.catPut(catUpdated!)
        delegate?.editTask(self, didSave: catUpdated!)
        
    }

}
