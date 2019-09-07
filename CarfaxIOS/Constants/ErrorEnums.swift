//
//  ErrorEnums.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//


import Foundation

public enum CarfaxErrors: LocalizedError {
  case noInternetConnection
  case requestTimeout
  case unknown
  
  public var errorDescription: String? {
    switch self {
    case .noInternetConnection:
      return "No Internet Connection."
    case .requestTimeout:
      return "The request timed out."
    case .unknown:
      return "Something went wrong."
    }
  }
  
}
