//
//  CatAdd.swift
//  ILoveCats
//
//  Created by eric on 2019-10-29.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

protocol CatAddDelegate: AnyObject {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTask(_ controller: UIViewController, didSave item: Cat)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class CatAdd: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Instance Variables
    weak var delegate: CatAddDelegate?
    var m: DataModalManager!
    var breeds = [String]()
    var postResult: Cat!
    
    // MARK: - Outlets
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var catName: UITextField!
    @IBOutlet weak var catWeight: UISlider!
    @IBOutlet weak var catWeightLabel: UILabel!
    @IBOutlet weak var catRating: UISegmentedControl!
    @IBOutlet weak var catBirthDate: UIDatePicker!
    @IBOutlet weak var catBreed: UIPickerView!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorMessage.text?.removeAll()
        catWeightLabel.text = "Weight: \(catWeight.value) kg"
        catBirthDate.datePickerMode = .date
        breeds = m.breedString.components(separatedBy: ", ")

        self.catBreed.delegate = self
        self.catBreed.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("CatPostWasSuccessful"), object: nil)
    }
    
    @objc func updateUI() {
        self.errorMessage.text = "Save was successful!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ownerName.becomeFirstResponder()
    }
    
    // Number of columns of data in catBreed picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows of data in catBreed picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    // The data in each row in catBreed picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var currentBreed = breeds[row]
        return String(breeds[row].dropFirst(7))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    @IBAction func getSliderChanged(_ sender: Any) {
        catWeightLabel.text = "Weight: \(catWeight.value) kg"
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        // Force keyboard to disappear
        ownerName.resignFirstResponder()
        catName.resignFirstResponder()
        
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Three tasks:
        // 1. Assemble the data, into an object
        // 2. Create a custom "request" object
        // 3. Perform the data task with the new request
        
        // Validation before saving
        if ownerName.text!.isEmpty {
            errorMessage.text = "Owner name cannot be empty."
            return
        }
        
        if catName.text!.isEmpty {
            errorMessage.text = "Cat name cannot be empty."
            return
        }
        // Validation Passes here
        
        // Create a cat Object
        errorMessage.text = "Attempting to save..."
 
        let newCat = Cat(catName: catName.text!, ownerName: ownerName.text!, breedId: String(breeds[catBreed.selectedRow(inComponent: 0)].prefix(4)), birthDate: catBirthDate.date, weightKg: catWeight.value, rating: catRating.selectedSegmentIndex + 1, photoUrl: "https://placekitten.com/300/200")
        
        // Send the request
        m.catPostNew(newCat)
        delegate?.addTask(self, didSave: newCat)
    }
    
}
