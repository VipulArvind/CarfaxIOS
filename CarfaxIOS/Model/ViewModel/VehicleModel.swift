//
//  VehicleModel.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import MapKit
import Contacts

//
// VehicleModel
//      Model for 1 Vehicle
//

class Vehicle: NSObject, Decodable {
  var year: Int = 0
  var make: String = ""
  var model: String = ""
  var trim: String = ""
  var listPrice: Int = 0
  var mileage: Int = 0
  
  var city: String = ""
  var state: String = ""
  var zip: String = ""
  var phone: String = ""
  
  var largeImage: String = ""
  var mediumImage: String = ""
  var smallImage: String = ""
  var latitude: String = ""
  var longitude: String = ""
  
  enum RootKeys: String, CodingKey {
    case year, make, model, trim, listPrice, mileage, dealer, images
  }
  
  enum DealerKeys: String, CodingKey {
    case city, state, zip, phone, latitude, longitude
  }
  
  enum ImageKeys: String, CodingKey {
    case firstPhoto
  }
  
  enum FirstPhotoKeys: String, CodingKey {
    case large, medium, small
  }
  
  override init() {
  }
  
  required init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: RootKeys.self)
    year = try container.decode(Int.self, forKey: .year)
    make = try container.decode(String.self, forKey: .make)
    model = try container.decode(String.self, forKey: .model)
    trim = try container.decode(String.self, forKey: .trim)
    listPrice = try container.decode(Int.self, forKey: .listPrice)
    mileage = try container.decode(Int.self, forKey: .mileage)
    
    let dealerContainer = try container.nestedContainer(keyedBy: DealerKeys.self, forKey: .dealer)
    city = try dealerContainer.decode(String.self, forKey: .city)
    state = try dealerContainer.decode(String.self, forKey: .state)
    zip = try dealerContainer.decode(String.self, forKey: .zip)
    phone = try dealerContainer.decode(String.self, forKey: .phone)
    latitude = try dealerContainer.decode(String.self, forKey: .latitude)
    longitude = try dealerContainer.decode(String.self, forKey: .longitude)
    
    do {
      let imagesContainer = try container.nestedContainer(keyedBy: ImageKeys.self, forKey: .images)
      let firstPhotoContainer = try imagesContainer.nestedContainer(keyedBy: FirstPhotoKeys.self, forKey: .firstPhoto)
      
      if let largeImage = try firstPhotoContainer.decodeIfPresent(String.self, forKey: .large) {
        self.largeImage = largeImage
      }
      
      if let mediumImage = try firstPhotoContainer.decodeIfPresent(String.self, forKey: .medium) {
        self.mediumImage = mediumImage
      }
      
      if let smallImage = try firstPhotoContainer.decodeIfPresent(String.self, forKey: .small) {
        self.smallImage = smallImage
      }
      
      largeImage = try firstPhotoContainer.decode(String.self, forKey: .large)
      mediumImage = try firstPhotoContainer.decode(String.self, forKey: .medium)
      smallImage = try firstPhotoContainer.decode(String.self, forKey: .small)
    } catch {
      print (error)
    }
  }
  
  func formattedYearMakeModelTrim () -> String {
    if trim.caseInsensitiveCompare("Unspecified") == .orderedSame {
      return String(year) + " " + make + " " + model
    }
    return String(year) + " " + make + " " + model +  " " + trim
  }
  
  func formattedPriceMileageLocation () -> NSAttributedString {
    
    let StringPrice = listPrice.currencyFormat
    let StringMileage = mileage.abbreviated
    let mileageCityState = " | " + StringMileage + "Mi | " + city + ", " + state
    
    //now we want the price to be bold and rest of the string as regular font
    let attributesBold: [NSAttributedString.Key: Any] = [
      .font: Constants.systemFontBoldSize12,
      .foregroundColor: Constants.blackColor
    ]
    
    let attributesRegular: [NSAttributedString.Key: Any] = [
      .font: Constants.systemFontSize12,
      .foregroundColor: Constants.blackColor
    ]
    
    let attributedString = NSMutableAttributedString(string: StringPrice, attributes: attributesBold)
    let attributedStringForMileageCityState = NSAttributedString(string: mileageCityState, attributes: attributesRegular)
    
    attributedString.append(attributedStringForMileageCityState)
    return attributedString
  }
  
  func formattedPhoneNumber () -> String? {
    return phone.formattedPhoneNumber()
  }
}

struct CarfaxAPIResponse: Decodable {
  var listings: [Vehicle]
}

extension Vehicle: MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D {
    let doubleLon = Double(longitude) ?? 0
    let doubleLat = Double(latitude) ?? 0
    return CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLon)
  }
  
  var title: String? {
    return formattedYearMakeModelTrim()
  }
  
  var subtitle: String? {
    return "subtitle"
  }
  
  func mapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
}
