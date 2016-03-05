//
//  Hotel.swift
//  Sasquatch Travel
//
//  Created by Evan on 12/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import Foundation

class Hotel: NSObject {
    let name: String
    let imageURL: String
    let rating: Int
    let shortDescription: String
    let lat: Float
    let lon: Float
    
    init(name: String, imageUrl: String, rating: Int, shortDescription: String, latitude: Float, longitude: Float ) {
        self.name = name
        self.imageURL = imageUrl
        self.rating = rating
        self.shortDescription = shortDescription
        self.lat = latitude
        self.lon = longitude
    }
}
