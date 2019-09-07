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

struct Dealer: Codable {
  var city: String
  var state: String
  var zip: String
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
      
      //if let result1 = result as? Data {
        do {
          let decoder = JSONDecoder()
          let gitData2 = try decoder.decode(Response.self, from: result )
          
          for vehicle in gitData2.listings {
            print("year =\(vehicle.year) make=\(vehicle.make) model=\(vehicle.model) trim=\(vehicle.trim)")
            print("listPrice =\(vehicle.listPrice) mileage=\(vehicle.mileage)")
            print("city =\(vehicle.dealer.city) state=\(vehicle.dealer.state) zip=\(vehicle.dealer.zip)")
          }
          
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
