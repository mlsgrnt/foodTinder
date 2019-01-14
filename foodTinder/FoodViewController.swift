//
//  foodViewController.swift
//  foodTinder
//
//  Created by Miles Grant on 1/11/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit
import VerticalCardSwiper

class FoodViewController: UIViewController, VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {

    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    var food: Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")

    }
    
    func configure(with food: Food) {
        self.food = food
        
        self.navigationItem.title = food.name
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let placeCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: index) as! PlaceCell
        
        placeCell.configure()
        
        return placeCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 100
    }

    // MARK: - VerticalCardSwiperDelegate
    
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        // Allows you to return custom card sizes (optional).
        return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height)
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
