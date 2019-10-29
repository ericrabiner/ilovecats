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

class CatAdd: UIViewController {
    
    // MARK: - Instance Variables
    weak var delegate: CatAddDelegate?
    var m: DataModalManager!
    let breedString = "abys - Abyssinian, aege - Aegean, abob - American Bobtail, acur - American Curl, asho - American Shorthair, awir - American Wirehair, amau - Arabian Mau, amis - Australian Mist, bali - Balinese, bamb - Bambino, beng - Bengal, birm - Birman, bomb - Bombay, bslo - British Longhair, bsho - British Shorthair, bure - Burmese, buri - Burmilla, cspa - California Spangled, ctif - Chantilly-Tiffany, char - Chartreux, chau - Chausie, chee - Cheetoh, csho - Colorpoint Shorthair, crex - Cornish Rex, cymr - Cymric, cypr - Cyprus, drex - Devon Rex, dons - Donskoy, lihu - Dragon Li, emau - Egyptian Mau, ebur - European Burmese, esho - Exotic Shorthair, hbro - Havana Brown, hima - Himalayan, jbob - Japanese Bobtail, java - Javanese, khao - Khao Manee, kora - Korat, kuri - Kurilian, lape - LaPerm, mcoo - Maine Coon, mala - Malayan, manx - Manx, munc - Munchkin, nebe - Nebelung, norw - Norwegian Forest Cat, ocic - Ocicat, orie - Oriental, pers - Persian, pixi - Pixie-bob, raga - Ragamuffin, ragd - Ragdoll, rblu - Russian Blue, sava - Savannah, sfol - Scottish Fold, srex - Selkirk Rex, siam - Siamese, sibe - Siberian, sing - Singapura, snow - Snowshoe, soma - Somali, sphy - Sphynx, tonk - Tonkinese, toyg - Toyger, tang - Turkish Angora, tvan - Turkish Van, ycho - York Chocolate"
    
    
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
        let breeds = breedString.components(separatedBy: ", ")
        print(breeds)
    }
    
    // MARK: - Actions
    @IBAction func getSliderChanged(_ sender: Any) {
        catWeightLabel.text = "Weight: \(catWeight.value) kg"
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
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
        
        // Create a friend Object
//        errorMessage.text = "Attempting to save..."
//        if pickedPhoto.image == nil {
//            let newFriend = Friend(firstName: firstNameInput.text!, lastName: lastNameInput.text!, age: age, city: cityInput.text!, imageName: "")
//            delegate?.addTask(self, didSave: newFriend)
//        }
//        else {
//            var image: UIImage?
//            var fileName: String
//            repeat {
//                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//                fileName = String((0..<25).map{ _ in letters.randomElement()! })
//                image = m.loadImage(fileName: fileName)
//            } while image != nil
//
//            m.saveImage(imageName: fileName, image: pickedPhoto.image!)
//            let newFriend = Friend(firstName: firstNameInput.text!, lastName: lastNameInput.text!, age: age, city: cityInput.text!, imageName: fileName)
//            delegate?.addTask(self, didSave: newFriend)
        
 //       }
    }
    

}
