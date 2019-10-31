//
//  CatDetail.swift
//  ILoveCats
//
//  Created by Eric Rabiner on 2019-10-31.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

protocol CatDetailDelegate: AnyObject {
    func detailTaskDidFinish(_ controller: UIViewController)
}

class CatDetail: UIViewController {
    
    // MARK: - Instance variables
    weak var delegate: CatDetailDelegate?
    var m: DataModalManager!
    var cat: Cat!
    
    // MARK: - Outlets
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catTemperment: UILabel!
    @IBOutlet weak var catDescription: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("CatBreedIsReady"), object: nil)
    }
    
    @objc func updateUI() {
        catName.text = m.catBreedData?.name
        catTemperment.text = m.catBreedData?.temperment
        catDescription.text = m.catBreedData?.description
    }
    
    // MARK: - Actions
    @IBAction func donePressed(_ sender: Any) {
        delegate?.detailTaskDidFinish(self)
    }
    

   

}
