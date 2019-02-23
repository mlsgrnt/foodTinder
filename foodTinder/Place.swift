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
    var image_url: URL?
    var rating: Double?
    var distance: Double
    var coordinates: CLLocationCoordinate2D
    var zipCode: String?
    var mapItem: MKMapItem?
    
    func asMapItem() -> MKMapItem {
        let lousyMapItem = MKMapItem(placemark: MKPlacemark(
            coordinate: self.coordinates
        ))
        lousyMapItem.name = self.name
        
        guard let mapItem = self.mapItem else {
            return lousyMapItem
        }
        return mapItem
    }
    
    // PATENT PENDING EMOJI-RANK™️ SYSTEM
    func ratingEmoji() -> String {
        guard let rating = self.rating else {
            return "🤷"
        }
        switch(rating) {
            case 0..<1:
                return "😷"
            case 1..<2:
                return "😨"
            case 2..<3:
                return "😕"
            case 3..<4:
                return "😐"
            case 4..<4.5:
                return "🙂"
            case 4.5..<4.8:
                return "😀"
            case 4.8..<5.1:
                return "😃"
            default:
                return "🤷"
        }
        
    }
    
    func findDetailedMapItem(completion: @escaping (_: MKMapItem) -> Void) -> Void {
        // "Search" for the place we're looking for
        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(center: self.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        request.naturalLanguageQuery = self.name
        
        // Add the zip code of the location to ensure we get the correct one
        if let zipCode = self.zipCode {
            request.naturalLanguageQuery = request.naturalLanguageQuery! + " " + zipCode
        }
        
        MKLocalSearch(request: request).start { (response, error) in
            guard error == nil else { return }
            guard let response = response else { return }
            guard response.mapItems.count > 0 else { return }
            
            let nearestMapItem = response.mapItems.sorted(by: { (lhs, rhs) -> Bool in
                if let lhs = lhs.placemark.region as? CLCircularRegion, let rhs = rhs.placemark.region as? CLCircularRegion {
                    return lhs.distanceFrom(request.region) > rhs.distanceFrom(request.region)
                }
                    return false
            })[0]
            
            completion(nearestMapItem)
        }
    }
}

extension CLCircularRegion {
    // This is not the true distance, but we don't care about the true distance, we just need
    // a comparable value
    public func distanceFrom(_ other: MKCoordinateRegion) -> Double {
        let latDifference = other.center.latitude - self.center.latitude
        let longDifference = other.center.longitude - self.center.longitude
        
        return abs(latDifference + longDifference)
    }
}
