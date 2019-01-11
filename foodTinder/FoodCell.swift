//
//  FoodCell.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit

class FoodCell: UICollectionViewCell {
    @IBOutlet var foodEmojiLabel: UILabel!
    
    public func configure(with food: Food) {
        foodEmojiLabel.text = food.emoji
    }
}
