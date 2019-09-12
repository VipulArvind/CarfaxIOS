//
//  Double+Formatting.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation

extension Double {
  
  func currencyFormat(fractionDigits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = fractionDigits
  
    return formatter.string(from: self as NSNumber) ?? ""
  }

  func percentageFormat() -> String {
    return String(self) + " %"
  }
}
