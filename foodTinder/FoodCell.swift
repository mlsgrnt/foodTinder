//
//  FoodCell.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit

class FoodCell: UICollectionViewCell {
    var food: Food?
    @IBOutlet var foodButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func configure(with food: Food) {
        self.food = food
        foodButton.setTitle(food.emoji, for: .normal)
    }
}
