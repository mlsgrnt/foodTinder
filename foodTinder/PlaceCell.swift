//
//  PlaceCell.swift
//  foodTinder
//
//  Created by Miles Grant on 1/14/19.
//  Copyright © 2019 Blydro. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import CoreMotion

class PlaceCell: CardCell {
    
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var whiteBox: UIView!
    private weak var shadowView: UIView?
    
    private let innerMargin = CGFloat(20) // This is the margin of the subview in the xib
    
    var shadowConfigured = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.shadowConfigured = false
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.whiteBox.layer.cornerRadius = 12
        
        super.layoutSubviews()
        
        if(!shadowConfigured) {
            configureShadow()
        }
    }
    
    func configure() {
        self.placeNameLabel.text = "\(String(describing: Places.location?.coordinate.longitude))"
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: self.innerMargin, y: self.innerMargin, width: bounds.width - (self.innerMargin  * 2), height: bounds.height - (self.innerMargin * 2)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        if motionManager.isDeviceMotionAvailable && !ProcessInfo.processInfo.isLowPowerModeEnabled {
                    motionManager.deviceMotionUpdateInterval = 0.02
                    motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                        if let motion = motion {
                            let pitch = motion.attitude.pitch * 10 // x-axis
                            let roll = motion.attitude.roll * 10 // y-axis
                            self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                        }
                    })
        } else {
            self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
        }
        
        self.shadowConfigured = true
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
}
