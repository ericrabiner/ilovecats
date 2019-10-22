//
//  DataModelManager.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import Foundation

class DataModalManager {
    
    // MARK: Data properties
    var catPackage: CatPackage?
    var cats = [Cat]()
    
    // MARK: Actions
    func catGetAll() {
        // Create a request object (and configure it if necessary)
        let request = WebApiRequest()
        
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "") { (result: [Cat]) in
            
            // Save the result in the manager property
            self.catPackage = CatPackage(timestamp: Date(), version: "1.0.0", count: result.count, data: result)
            self.cats = self.catPackage!.data
            
            // Post a notification
            NotificationCenter.default.post(name: Notification.Name("WebApiDataIsReady"), object: nil)
        }
    }
    
    func catsCount() -> Int {
        return cats.count
    }
    
    func catGetData() -> [Cat] {
        return cats
    }
    
}
