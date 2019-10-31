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
    var m: DataModalManager!
    var cat: Cat!
    
    // MARK: - Outlets

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
