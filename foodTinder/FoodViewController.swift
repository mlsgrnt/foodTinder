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
    var places = [Place]()
    
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
    
    private func reloadData(places: [Place]) {
        self.places = places
        
        DispatchQueue.main.async {
            self.cardSwiper.datasource = self
            self.cardSwiper.reloadData()
            
            self.activityIndicator.stopAnimating()
            
            // Show error message if nothing is found
            if(self.places.count == 0) {
                self.soldOutLabel.isHidden = false
            }
        }
    }
    
    func configure(with food: Food) {
        self.food = food
        
        let placesDataSource = Places()
        
        placesDataSource.grabPlaces(query: food.name, completion: self.reloadData)
        
        self.navigationItem.title = food.name
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let placeCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: index) as! PlaceCell
        
        placeCell.configure(with: self.places[index])
        self.places[index].findDetailedMapItem { (mapItem) in
            self.places[index].mapItem = mapItem
        }
        
        return placeCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return self.places.count
    }

    // MARK: - VerticalCardSwiperDelegate
    
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        // Allows you to return custom card sizes (optional).
        return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height)
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        if(self.places.count == 1) {
            print("this bitch empty")
            self.soldOutLabel.isHidden = false
        }
        
        // Check for right swipe!
        if(swipeDirection == .Right) {
            let place = self.places[index]
            
            place.asMapItem().openInMaps(launchOptions: nil)
        }
        self.places.remove(at: index)

    }    

}
