//
//  ViewController.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit
import CoreLocation

class InitialViewController: UICollectionViewController, CLLocationManagerDelegate {
    
    var foods = [
        Food(emoji: "🍔", name: "Burger"),
        Food(emoji: "🥙", name: "Kebab"),
        Food(emoji: "🍕", name: "Pizza"),
        Food(emoji: "☕️", name: "Coffee"),
        Food(emoji: "🥞", name: "Pancakes"),
        Food(emoji: "🥪", name: "Sandwhich"),
        Food(emoji: "🥡", name: "Chinese Food"),
        Food(emoji: "🍣", name: "Sushi"),
        Food(emoji: "🥖", name: "Bakery")
    ]

    var locationManager = CLLocationManager()
    var places = Places()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    //MARK: - CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FoodCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        cell.configure(with: foods[indexPath.item])
        
        return cell
    }
    
    //MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        Places.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO
        print(error)
        return
    }
    
    //MARK: - Navivgation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIButton {
            if let foodCell = sender.superview?.superview as? FoodCell {
                if let foodView = segue.destination as? FoodViewController {
                    
                    foodView.configure(with: foodCell.food!)
                }
            }
        }
    }
}
