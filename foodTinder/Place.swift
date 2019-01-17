//
//  Place.swift
//  foodTinder
//
//  Created by Miles Grant on 1/14/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import Foundation
import MapKit

struct Place {
    var name: String
    var image_url: URL
    var rating: Double
    var distance: Double
    var coordinates: CLLocationCoordinate2D
    
    func asDestination() -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(
            coordinate: self.coordinates
        ))
    }
}
