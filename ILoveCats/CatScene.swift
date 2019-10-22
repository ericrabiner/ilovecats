//
//  CatScene.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

class CatScene: UIViewController {
    
    // MARK: - Instance variables
    var m: DataModalManager!
    var item: Cat!
    
    // MARK: - Outlets
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        catName.text = item.catName
        ownerName.text = item.ownerName
    }
}
