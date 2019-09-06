//
//  Restaurant.swift
//  BRIOSApp
//
//  Created by Vipul Arvind on 8/22/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import MapKit
import Contacts

//
// RestaurantModel
//      Model for 1 Restaurant
//

class RestaurantModel: NSObject, MKAnnotation {
    
    // MARK: - Vars
    let name: String
    let backgroundImageURL: String
    let category: String
    let formattedPhone: String
    let twitter: String
    let addressLine1: String
    let addressLine2: String
    let coordinate: CLLocationCoordinate2D
    
    var twitterHandle: String? {
        return twitter.isEmpty ? "" : "@" + twitter
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return category
    }
  
    // MARK: - Init
    init(name: String, backgroundImageURL: String, category: String, formattedPhone: String, twitter: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.backgroundImageURL = backgroundImageURL
        self.category = category
        self.formattedPhone = formattedPhone
        self.twitter = twitter
        self.addressLine1 = twitter
        self.addressLine2 = twitter
        self.coordinate = coordinate
        
        super.init()
    }
 
    // Not using guard here since absence of 1 key-value doesnt mean that following key-values are not present
    // Hence using if let(s)
    // other option is to change all member variables to "var" and use multiple init function (in conjunction with guard let
    
    init?(restaurantDict: [String: Any]) {
        
        self.name = restaurantDict["name"] as? String ?? ""
        self.backgroundImageURL = restaurantDict["backgroundImageURL"] as? String ?? ""
        self.category = restaurantDict["category"] as? String ?? ""
        
        if let contact = restaurantDict["contact"] as? [String: Any] {
            self.formattedPhone = contact["formattedPhone"] as? String ?? ""
            self.twitter = contact["twitter"] as? String ?? ""
        } else {
            self.formattedPhone = ""
            self.twitter = ""
        }
        
        let location = restaurantDict["location"] as? [String: Any]
        
        if let formattedAddress = location?["formattedAddress"] as? [String],
            formattedAddress.count >= 2 {
            self.addressLine1 = formattedAddress[0]
            self.addressLine2 = formattedAddress[1]
        } else {
            self.addressLine1 = ""
            self.addressLine2 = ""
        }
        
        if let lat = location?["lat"] as? Double,
            let long = location?["lng"] as? Double {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
