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
    var cat: Cat!
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
        catName.text = "Meet \(cat.catName)"
        ownerName.text = cat.ownerName
        
        breeds = m.breedString.components(separatedBy: ", ")
        var found = false
        for breed in breeds {
            if cat.breedId == breed.prefix(4) && !found {
                self.breed.text = String(breed.dropFirst(7))
                found = true
            }
        }
        
        weight.text = String(cat.weightKg)
        rating.text = String(cat.rating)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        birthDate.text = formatter.string(from: cat.birthDate)
        
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
    }
    
    func editTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func editTask(_ controller: UIViewController, didSave item: CatUpdated) {
        cat.ownerName = item.ownerName
        cat.rating = item.rating
        cat.photoUrl = item.photoUrl
        ownerName.text = item.ownerName
        rating.text = String(item.rating)
        guard let imageURL = URL(string: cat.photoUrl) else { return }
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
            vc.cat = cat
        }
  
    }
}
