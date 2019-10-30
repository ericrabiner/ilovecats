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
    // MARK: - Outlets
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        catName.text = item.catName
        ownerName.text = item.ownerName
        
//        let range = m.breedString.range(of: item.breedId)!
//        breed.text = String(m.breedString[range])
        
        breed.text = item.breedId
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        birthDate.text = formatter.string(from: item.birthDate)
        weight.text = String(item.weightKg)
        rating.text = String(item.rating)
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: CatUpdated) {
        m.catPut(item)
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
