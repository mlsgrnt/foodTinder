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
    var places: [Place] = []
    
    func grabPlaces(query: String, completion: @escaping () -> Void) {
        
        guard let location = Places.location?.coordinate else {
            return
        }
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(query)&latitude=\(location.latitude)&longitude=\(location.longitude)&open_now=true")
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
                    let place = Place(
                        name: unwrappedPlace["name"] as! String,
                        image_url: URL(string: unwrappedPlace["image_url"] as! String)!,
                        rating: unwrappedPlace["rating"] as! Double,
                        distance: unwrappedPlace["distance"] as! Double,
                        coordinates: unwrappedPlace["coordinates"] as! [String: Double]
                    )
                    self.places.append(place)
                })
                DispatchQueue.main.async {
                    completion()
                }
            })
            task.resume()
        }
        
    }
}
