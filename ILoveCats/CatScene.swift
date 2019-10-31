//
//  CatScene.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

class CatScene: UIViewController, CatEditDelegate {
    
    // MARK: - Instance variables
    var m: DataModalManager!
    var item: Cat!
    var breeds = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var catPhoto: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        catName.text = "Meet \(item.catName)"
        ownerName.text = item.ownerName
        
        breeds = m.breedString.components(separatedBy: ", ")
        var found = false
        for breed in breeds {
            if item.breedId == breed.prefix(4) && !found {
                self.breed.text = String(breed.dropFirst(7))
                found = true
            }
        }
        
        weight.text = String(item.weightKg)
        rating.text = String(item.rating)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        birthDate.text = formatter.string(from: item.birthDate)
        
        guard let imageURL = URL(string: item.photoUrl) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.catPhoto.image = image
            }
        }
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: CatUpdated) {
        self.item.ownerName = item.ownerName
        self.item.rating = item.rating
        self.item.photoUrl = item.photoUrl
        ownerName.text = item.ownerName
        rating.text = String(item.rating)
        guard let imageURL = URL(string: item.photoUrl) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.catPhoto.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCatEdit" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CatEdit
            vc.m = m
            vc.delegate = self
            vc.item = item
        }
  
    }
}
