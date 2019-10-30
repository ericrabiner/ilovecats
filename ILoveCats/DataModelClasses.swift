//
//  DataModelClasses.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import Foundation

class Cat : Codable {
    // MARK: - Data properties
    var _id: String?
    var catName: String
    var ownerName: String
    var breedId: String
    var birthDate: Date
    var weightKg: Float
    var rating: Int
    var photoUrl: String
    
    // MARK - Initializers
    init(catName: String, ownerName: String, breedId: String, birthDate: Date, weightKg: Float, rating: Int, photoUrl: String) {
        self.catName = catName
        self.ownerName = ownerName
        self.breedId = breedId
        self.birthDate = birthDate
        self.weightKg = weightKg
        self.rating = rating
        self.photoUrl = photoUrl
    }

}

class CatPackage: Codable {
    // MARK: - Data properties
    var timestamp: Date = Date()
    var version: String = "1.0.0"
    var count: Int = 0
    var data = [Cat]()
    
    // MARK: - Initializers
    init(timestamp: Date, version: String, count: Int, data: [Cat]) {
        self.timestamp = timestamp
        self.version = version
        self.count = count
        self.data = data
    }
}

class CatUpdated: Codable {
    // MARK: - Data properties
    var _id: String
    var ownerName: String
    var rating: Int
    var photoUrl: String
    
    // MARK - Initializers
    init(_id: String, ownerName: String, rating: Int, photoUrl: String) {
        self._id = _id
        self.ownerName = ownerName
        self.rating = rating
        self.photoUrl = photoUrl
    }
}

class CatPhotoData: Codable {
    var id: String
    var url: String
    
    // MARK - Initializers
    init(id: String, url: String) {
        self.id = id
        self.url = url
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

//extension Float {
//    var clean: String {
//        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
//    }
//}
