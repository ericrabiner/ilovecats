//
//  CatEdit.swift
//  ILoveCats
//
//  Created by eric on 2019-10-29.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

protocol CatEditDelegate: AnyObject {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTask(_ controller: UIViewController, didSave item: CatUpdated)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class CatEdit: UIViewController {
    
    // MARK: - Instance variables
    weak var delegate: CatEditDelegate?
    var m: DataModalManager!
    var item: Cat!
    
    // MARK: - Outlets
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var catRating: UISegmentedControl!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catImageButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ownerName.text = item.ownerName
        catRating.selectedSegmentIndex = item.rating - 1
        errorMessage.text?.removeAll()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("CatPutWasSuccessful"), object: nil)
    }
    
    @objc func updateUI() {
        self.errorMessage.text = "Save was successful!"
    }
    
    // MARK - Actions
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.addTaskDidCancel(self)
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
        
        let newCat = CatUpdated(_id: item._id!, ownerName: ownerName.text!, rating: catRating.selectedSegmentIndex + 1, photoUrl: "https://placekitten.com/300/200")
        
        // Send the request
        m.catPut(newCat)
        
    }

}
