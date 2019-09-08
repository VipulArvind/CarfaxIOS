//
//  CarfaxIOS+Int.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation

extension Int {
  
  var abbreviated: String {
    let abbrev = "KMBTPE"
    return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
      let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
      let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
      return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
      } ?? String(self)
  }
  
  var currencyFormat: String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    
    return formatter.string(from: self as NSNumber) ?? ""
  }
}