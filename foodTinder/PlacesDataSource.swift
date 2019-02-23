//
//  PlacesDataSource.swift
//  foodTinder
//
//  Created by Miles Grant on 1/14/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import Foundation
import CoreLocation

class Places {
    static var location: CLLocation?
    
    func grabPlaces(query: String, completion: @escaping (_ places: [Place]) -> Void) {
        var places = [Place]()

        guard let location = Places.location?.coordinate else {
            return
        }
        
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(escapedQuery!)&latitude=\(location.latitude)&longitude=\(location.longitude)&open_now=true")
        var request = URLRequest(url: url!)
        request.setValue("Bearer DKBpOix761jB6JYUXRd_GYx_o6UMfdPW26VV9Mom8sroAKCpH1HjD111H22v94KoocJ2stlczJOgWXsbm0HGi1_uABbK2hV21Sz3Kf5WMkmb33fCgVSN2HfilRc9XHYx", forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                    
                }
                guard let json = (try? JSONSerialization.jsonObject(with: dataResponse, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    print("Not containing JSON")
                    return
                }
                guard let businesses = json["businesses"] as? NSArray else {
                    print("Not containing JSON")
                    return
                }
                businesses.forEach({ (jsonPlace) in
                    guard let unwrappedPlace = jsonPlace as? [String: Any] else {
                        print("oh ok")
                        return
                    }
                    
                    let coords = unwrappedPlace["coordinates"] as! [String: Double]
                    
                    var place = Place(
                        name: unwrappedPlace["name"] as! String,
                        image_url: nil,
                        rating: unwrappedPlace["rating"] as? Double,
                        distance: unwrappedPlace["distance"] as! Double,
                        coordinates: CLLocationCoordinate2D(latitude: coords["latitude"]!, longitude: coords["longitude"]!),
                        zipCode: unwrappedPlace["zip_code"] as? String,
                        mapItem: nil
                    )
                    if let url = unwrappedPlace["image_url"] as? String {
                        place.image_url = URL(string: url)
                    }
                    places.append(place)
                })
                // Sort by distance
                places = places.sorted(by: { (a, b) -> Bool in
                    return a.distance < b.distance
                })
                DispatchQueue.main.async {
                    completion(places)
                }
            })
            task.resume()
        }
        
    }
    
    func fakegrabPlaces(query: String, completion: @escaping (_ places: [Place]) -> Void) {
        var places = [Place]()

        let place1 = Place(
            name: "test",
            image_url: URL(string: "https://user-images.githubusercontent.com/7799382/30356431-dbba9920-97ed-11e7-8f2b-a5b5ba0e7682.png")!,
            rating: 5,
            distance: 5,
            coordinates: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), zipCode: "G20 7SE",
            mapItem: nil
        )
        let place2 = Place(
            name: "test2",
            image_url: nil,
            rating: 1,
            distance: 5,
            coordinates: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), zipCode: "G20 7SB",
            mapItem: nil
        )
        let place3 = Place(
            name: "test3",
            image_url: URL(string: "https://user-images.githubusercontent.com/7799382/30356431-dbba9920-97ed-11e7-8f2b-a5b5ba0e7682.png")!,
            rating: 5,
            distance: 5,
            coordinates: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), zipCode: "11111",
            mapItem: nil
        )
        places.append(place1)
        places.append(place2)
        places.append(place3)
        DispatchQueue.main.async {
            completion(places)
        }
    }

}
