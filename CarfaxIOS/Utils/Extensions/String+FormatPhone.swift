//
//  String+FormatPhone.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// String+FormatPhone
//      Class to implement the extension for String
//      Mainly to implement the method to format the phone number
//

import Foundation

extension String {
  
  //
  // following 2 methods taken from https://stackoverflow.com/questions/32364055/formatting-phone-number-in-swift
  // tested with different phone number formats
  //
  
  internal func substring(start: Int, offsetBy: Int) -> String? {
    guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
      return nil
    }
    
    guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
      return nil
    }
    
    return String(self[substringStartIndex ..< substringEndIndex])
  }
  
  func formattedPhoneNumber () -> String? {
    // Remove any character that is not a number
    let sourcePhoneNumber = self
    let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let length = numbersOnly.count
    let hasLeadingOne = numbersOnly.hasPrefix("1")
    
    // Check for supported phone number length
    guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
      return nil
    }
    
    let hasAreaCode = (length >= 10)
    var sourceIndex = 0
    
    // Leading 1
    var leadingOne = ""
    if hasLeadingOne {
      leadingOne = "1 "
      sourceIndex += 1
    }
    
    // Area code
    var areaCode = ""
    if hasAreaCode {
      let areaCodeLength = 3
      guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
        return nil
      }
      areaCode = String(format: "(%@) ", areaCodeSubstring)
      sourceIndex += areaCodeLength
    }
    
    // Prefix, 3 characters
    let prefixLength = 3
    guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
      return nil
    }
    sourceIndex += prefixLength
    
    // Suffix, 4 characters
    let suffixLength = 4
    guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
      return nil
    }
    
    return leadingOne + areaCode + prefix + "-" + suffix
  }
}
