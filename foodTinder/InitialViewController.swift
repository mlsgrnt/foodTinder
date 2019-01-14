//
//  ViewController.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit

class InitialViewController: UICollectionViewController {
    
    var foods = [
        Food(emoji: "🍔", name: "borger"),
        Food(emoji: "🥙", name: "döner"),
        Food(emoji: "🌭", name: "hot dog"),
        Food(emoji: "🍕", name: "pizza")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FoodCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        cell.configure(with: foods[indexPath.item])
        
        return cell
    }
    
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
