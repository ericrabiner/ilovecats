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
    var catData: CatData?
    var catBreedData: CatBreedData?
  
    let breedString = "abys - Abyssinian, aege - Aegean, abob - American Bobtail, acur - American Curl, asho - American Shorthair, awir - American Wirehair, amau - Arabian Mau, amis - Australian Mist, bali - Balinese, bamb - Bambino, beng - Bengal, birm - Birman, bomb - Bombay, bslo - British Longhair, bsho - British Shorthair, bure - Burmese, buri - Burmilla, cspa - California Spangled, ctif - Chantilly-Tiffany, char - Chartreux, chau - Chausie, chee - Cheetoh, csho - Colorpoint Shorthair, crex - Cornish Rex, cymr - Cymric, cypr - Cyprus, drex - Devon Rex, dons - Donskoy, lihu - Dragon Li, emau - Egyptian Mau, ebur - European Burmese, esho - Exotic Shorthair, hbro - Havana Brown, hima - Himalayan, jbob - Japanese Bobtail, java - Javanese, khao - Khao Manee, kora - Korat, kuri - Kurilian, lape - LaPerm, mcoo - Maine Coon, mala - Malayan, manx - Manx, munc - Munchkin, nebe - Nebelung, norw - Norwegian Forest Cat, ocic - Ocicat, orie - Oriental, pers - Persian, pixi - Pixie-bob, raga - Ragamuffin, ragd - Ragdoll, rblu - Russian Blue, sava - Savannah, sfol - Scottish Fold, srex - Selkirk Rex, siam - Siamese, sibe - Siberian, sing - Singapura, snow - Snowshoe, soma - Somali, sphy - Sphynx, tonk - Tonkinese, toyg - Toyger, tang - Turkish Angora, tvan - Turkish Van, ycho - York Chocolate"
    
    // MARK: Methods
    
    func catGetData() -> [Cat] {
        return cats
    }
    
    // GET all request method
    func catGetAll() {
        // Create a request object (and configure it if necessary)
        let request = WebApiRequest()
        
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "") { (result: [Cat]) in
            
            // Save the result in the manager property
            self.catPackage = CatPackage(timestamp: Date(), version: "1.0.0", count: result.count, data: result)
            self.cats = self.catPackage!.data.sorted(by: { (c1: Cat, c2: Cat) -> Bool in return c1.catName.lowercased() < c2.catName.lowercased() })
            
            // Post a notification
            NotificationCenter.default.post(name: Notification.Name("WebApiDataIsReady"), object: nil)
        }
    }
    
    // POST request method
    func catPostNew(_ postData: Cat) {
        // Create a request object (and configure it if necessary)
        let request = WebApiRequest()
        
        // Configure the request
        request.urlBase = "https://thecatapi-56b0.restdb.io/rest/a-3-cats"
        request.httpMethod = "POST"
        
        // Prepare the data to be sent
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        // Add the data to the body
        // For this example, we will disable error-handling with try!
        
        request.httpBody = try! encoder.encode(postData)

        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "") { (result: Cat) in
            // We don't need to save it here or do anything else
            // But we will update the user interface (below)
        }
        
        // Post a notification
        NotificationCenter.default.post(name: Notification.Name("CatPostWasSuccessful"), object: nil)
        
        catGetAll()
        
    }
    
    // PUT request method
    func catPut(_ putData: CatUpdated) {
        dump(putData)
        
        // Create a request object (and configure it if necessary)
        let request = WebApiRequest()
        
        // Configure the request
        request.urlBase = "https://thecatapi-56b0.restdb.io/rest/a-3-cats"
        request.httpMethod = "PUT"
        
        // Prepare the data to be sent
        let encoder = JSONEncoder()
        
        // Add the data to the body
        // For this example, we will disable error-handling with try!
        
        request.httpBody = try! encoder.encode(putData)
        
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "/\(putData._id)") { (result: CatUpdated) in
            // We don't need to save it here or do anything else
            // But we will update the user interface (below)
        }
        
        // Post a notification
        NotificationCenter.default.post(name: Notification.Name("CatPutWasSuccessful"), object: nil)
        
        catGetAll()
        
    }
    
    // GET request method - CAT API
    func catGetImage(_ catBreedId: String) {
        let request = WebApiRequest()
        request.urlBase = "https://api.thecatapi.com/v1/images/search?breed_ids="
        request.httpMethod = "GET"
        request.sendRequest(toUrlPath: "\(catBreedId)") { (result: [CatData]) in
            
            self.catData = CatData(id: result[0].id, url: result[0].url, breeds: result[0].breeds)

            // Post a notification
            NotificationCenter.default.post(name: Notification.Name("CatPhotoIsReady"), object: nil)
        }
    }
    
    // GET request method - CAT API - cat breed
    func catGetBreed(_ catBreedId: String) {
        let request = WebApiRequest()
        request.urlBase = "https://api.thecatapi.com/v1/images/search?breed_ids="
        request.httpMethod = "GET"
        request.sendRequest(toUrlPath: "\(catBreedId)") { (result: [CatData]) in
            
            self.catData = CatData(id: result[0].id, url: result[0].url, breeds: result[0].breeds)
            self.catBreedData = CatBreedData(name: result[0].breeds[0].name, description: result[0].breeds[0].description, temperament: result[0].breeds[0].temperament)
            
            // Post a notification
            NotificationCenter.default.post(name: Notification.Name("CatBreedIsReady"), object: nil)
        }
    }
    
}
