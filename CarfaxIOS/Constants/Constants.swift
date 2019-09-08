//
//  Constants.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import UIKit

//
// Constants
//    To keep all the constants at 1 place
//    Easier to change if we decide to go with some other font/color etc. later on
//

typealias APICallback = (_ success: Bool, _ errorMessage: String) -> Void
typealias DataMgrCallback = (_ result: Data?, _ errorMessage: String) -> Void

struct Constants {    
  
  // MARK: - URLs
  static let vehiclesDataURL = "https://carfax-for-consumers.firebaseio.com/assignment.json"
  
  // MARK: - Colors
  static let blackColor = UIColor.black
  
  // MARK: - Fonts
  static let systemFontSize12 = UIFont.systemFont(ofSize: 14.0)
  static let systemFontBoldSize12 = UIFont.boldSystemFont(ofSize: 14.0)
}
