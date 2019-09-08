//
//  DataMgr.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import UIKit

//
// DataMgr
//      Class to implement all 'data fetching from server tasks'
//

class DataMgr {
  
  let defaultSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?
  var errorMessage = ""
  
  private func vehiclesDataURL () -> String {
    return Constants.vehiclesDataURL
  }
    
  func getVehiclesData (completion: @escaping DataMgrCallback) {
    dataTask?.cancel()
    
    guard let url = URL(string: self.vehiclesDataURL()) else {
      completion(nil, "Invalid URL")
      return
    }
    
    dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
      defer {
        self?.dataTask = nil
      }
      
      if let error = error {
        self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
      } else if
        let data = data,
        
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        
          DispatchQueue.main.async {
            completion(data, self?.errorMessage ?? "")
          }
        }
      }
    dataTask?.resume()
  }
}
