//
//  VehiclesManager.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// VehiclesManager
//      Class to implement the singleton for managing the Vehicles data
//
//

import UIKit

struct VehicleImages: Codable {
  var large: String
  var medium: String
  var small: String
}

struct Dealer: Codable {
  var city: String
  var state: String
  var zip: String
  var phone: String
}

struct Response: Codable {
  
  struct Vehicle: Codable {
    var year: Int
    var make: String
    var model: String
    var trim: String
    var listPrice: Int
    var mileage: Int
    
    var dealer: Dealer
    
    func formattedYearMakeModelTrim () -> String {
      return String(year) + " " + make + model + trim
    }
    
    func formattedPriceMileageLocation () -> NSAttributedString {
      
      let StringPrice = listPrice.currencyFormat
      let StringMileage = mileage.abbreviated
      
      let mileageCityState = " | " + StringMileage + "Mi | " + dealer.city + ", " + dealer.state
      
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
      return dealer.phone.formattedPhoneNumber()
    }
  }
  
  var listings: [Vehicle]
}

final class VehiclesManager: NSObject {
  
  // MARK: - Vars
  var vehiclesList: [Response.Vehicle] = []
    
  // MARK: - overrides
  override init() {
    super.init()
  }
  
  func getVehiclesData (completion: @escaping APICallback) {
    let dataMgrIntrf = DataMgr()
    
    dataMgrIntrf.getVehiclesData { (result, errorMessage) in
      guard let result = result else { completion(false, "errorMessage"); return}
      
        do {
          let decoder = JSONDecoder()
          let gitData2 = try decoder.decode(Response.self, from: result )
          self.vehiclesList.append(contentsOf: gitData2.listings)
        } catch let err {
          print("Err", err)
        }
        //unpack all the data here
        completion(true, "")
    }
  }
  
   // MARK: - Public Methods
   
   func count() -> Int {
    return vehiclesList.count
   }
   
   func vehicle(atIndex: Int) -> Response.Vehicle? {
    if vehiclesList.count > atIndex {
      return vehiclesList[atIndex]
    }
    return nil
   }
   
   func allVehicles() -> [Response.Vehicle] {
    return vehiclesList
   }
   
   func first() -> Response.Vehicle? {
    return vehiclesList.first
   }
}
