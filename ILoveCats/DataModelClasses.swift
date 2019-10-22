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
    var _id: String
    var catName: String
    var ownerName: String
    var breedId: String
    var birthDate: Date
    var weightKg: Float
    var rating: Float
    var photoUrl: String
//    var _version: Int
//    var _created: Date
//    var _createdby: String
//    var _changed: Date
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
