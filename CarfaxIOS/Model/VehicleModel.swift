//
//  VehicleModel.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation

//
// VehicleModel
//      Model for 1 Vehicle
//

class VehicleModel: NSObject {
    
  // MARK: - Vars
  /*
  let model: String
  let make: String
  let year: Int
  let onePrice: Int
  let mileage: Int
  let city: String
  let state: String
  let phone: String
 */
  
  // MARK: - Init
  override init() {
      super.init()
  }
     
  init?(vehicleDict: [String: Any]) {
  }
        
}
