//
//  VehicleAnnotationView.swift
//  BRIOSApp
//
//  Created by Vipul Arvind on 9/8/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

//
// VehicleAnnotationView
//      Extra part of the exercise
//      Shows the callouts (MKAnnotations) for all Vehicles in map view
//

class VehicleAnnotationView: MKAnnotationView {
    
    // MARK: - Vars
    override var annotation: MKAnnotation? {
        willSet {
            guard
                let vehicleModel = newValue as? Vehicle
            else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            image = UIImage(named: "carIconBlue")
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = vehicleModel.formattedPriceMileageLocation().string
            detailCalloutAccessoryView = detailLabel
        }
    }
}
