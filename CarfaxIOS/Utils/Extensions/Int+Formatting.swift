//
//  Int+FormatPhone+Int.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation

//
// Int+FormatPhone
//      Class to implement the extension for Int
//      Mainly to implement the method to abbreivate the mileage and to format Ints as currency
//

extension Int {
  
  //
  // method taken from https://stackoverflow.com/questions/18267211/ios-convert-large-numbers-to-smaller-format/39801536#39801536
  // tested with different numbers (hundreds,thousands etc.)
  //
  
  var abbreviated: String {
    let abbrev = "KMBTPE"
    return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
      let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
      let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
      return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
      } ?? String(self)
  }
  
  func currencyFormat(fractionDigits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = fractionDigits
  
    return formatter.string(from: self as NSNumber) ?? ""
  }
}
