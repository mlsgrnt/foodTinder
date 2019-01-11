//
//  ViewController.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var foods = [
        Food(emoji: "🍔", name: "burger"),
        Food(emoji: "🥙", name: "doner"),
        Food(emoji: "🌭", name: "hot dog"),
        Food(emoji: "🍕", name: "pizza")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        cell.configure(with: foods[indexPath.item])
        
        return cell
    }
}
