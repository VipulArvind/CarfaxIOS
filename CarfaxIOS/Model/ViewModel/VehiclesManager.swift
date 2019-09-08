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

final class VehiclesManager: NSObject {
  
  // MARK: - Vars
  var vehiclesList: [Vehicle] = []
    
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
          let rootData = try decoder.decode(CarfaxAPIResponse.self, from: result )
          self.vehiclesList.append(contentsOf: rootData.listings)
        } catch let err {
          print("Err", err)
        }
      
        completion(true, "")
    }
  }
  
  // MARK: - Public Methods
   
  func count() -> Int {
    return vehiclesList.count
  }
   
  func vehicle(atIndex: Int) -> Vehicle? {
    if vehiclesList.count > atIndex {
      return vehiclesList[atIndex]
    }
    return nil
  }
   
  func allVehicles() -> [Vehicle] {
    return vehiclesList
  }
   
  func first() -> Vehicle? {
    return vehiclesList.first
  }
  
  func resetVehiclesList() {
    vehiclesList.removeAll()
  }
}
