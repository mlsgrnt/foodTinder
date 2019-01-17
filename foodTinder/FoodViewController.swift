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
    var placesDataSource = Places()
    
    var cardsSwipedAwayCounter = 0
    @IBOutlet weak var soldOutLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardSwiper.datasource = nil
        cardSwiper.delegate = self
        
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")

    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.cardSwiper.datasource = self
            self.cardSwiper.reloadData()
            
            self.activityIndicator.stopAnimating()
            
            // Show error message if nothing is found
            if(self.placesDataSource.places.count == 0) {
                self.soldOutLabel.isHidden = false
            }
        }
    }
    
    func configure(with food: Food) {
        self.food = food
        
        self.placesDataSource.grabPlaces(query: food.name, completion: self.reloadData)
        
        self.navigationItem.title = food.name
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let placeCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: index) as! PlaceCell
        
        //print(index)
        
        placeCell.configure(with: self.placesDataSource.places[index])
        
        return placeCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return self.placesDataSource.places.count
    }

    // MARK: - VerticalCardSwiperDelegate
    
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        // Allows you to return custom card sizes (optional).
        return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height)
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        self.cardsSwipedAwayCounter = self.cardsSwipedAwayCounter + 1
        if(cardsSwipedAwayCounter == self.placesDataSource.places.count) {
            print("this bitch empty")
            self.soldOutLabel.isHidden = false
        }
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // Check for right swipe!
        if(swipeDirection == .Right) {
            let place = self.placesDataSource.places[index]
            
            place.asMapItem().openInMaps(launchOptions: nil)
        }
        
        self.placesDataSource.places.remove(at: index)
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
