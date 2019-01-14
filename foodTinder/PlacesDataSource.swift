//
//  PlacesDataSource.swift
//  foodTinder
//
//  Created by Miles Grant on 1/14/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Places {
    static var location: CLLocation?
    var places: [Place] = []
    
    func grabPlaces(query: String, completion: @escaping () -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        guard let location = Places.location?.coordinate else {
            return
        }
        
        request.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        DispatchQueue.global(qos: .background).async {
            MKLocalSearch(request: request).start { (response: MKLocalSearch.Response?
                , error: Error?) in
                response?.mapItems.forEach({ (place) in
                    print(place)
                    self.places.append(Place(name: place.name ?? "\(query) Place"))
                })
                DispatchQueue.main.async {
                    completion()
                }
            }
        }

    }
}
