//
//  foodViewController.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {

    @IBOutlet var testLabel: UILabel!
    var food: Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testLabel.text = self.food?.emoji
        // Do any additional setup after loading the view.
    }
    
    func configure(with food: Food) {
        self.food = food
        
        self.navigationItem.title = food.name
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
