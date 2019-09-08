//
//  ViewController.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var vehiclesManager: VehiclesManager = VehiclesManager()
  
  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Vars
  private let reuseIdentifier = "VehicleCell"
  
  // MARK: - overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    startDownloadingData()
  }
  
  private func startDownloadingData() {
    vehiclesManager.getVehiclesData { [weak self] success, errorMessage in
      if success == true {
        print ("Success")
        self?.collectionView.reloadData()
      } else {
        print ("failure")
      }
    }
  }
  
  func updateAllUI (dataObtained: Bool) {
  }
}
  

// extension ViewController
//      Mark: - Contains code to implement UICollectionViewDataSource
//

extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return vehiclesManager.count()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VehicleCell
      else {
        preconditionFailure("Invalid cell type")
    }
    
    cell.tag = indexPath.row

    guard
      let aVehicle = vehiclesManager.vehicle(atIndex: indexPath.row)
      else {
        return cell
    }
    
    cell.updateValues(vehicle: aVehicle, cellForItemAt: indexPath)
    
    return cell
  }
}

// extension ViewController
//      Mark: - Contains code to implement UICollectionViewDelegateFlowLayout
//

extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    let width = (UIDevice.current.userInterfaceIdiom == .phone) ? collectionViewWidth : collectionViewWidth / 2 - 2
    return CGSize(width: width, height: 420.0)
  }
}
