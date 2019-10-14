//
//  ViewController.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// ViewController
//      Main Home View of the app
//      Initiates request to fetch the data from Server
//      Shows all Vehicles in List view
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
    
    addRefreshControl()
    startDownloadingData()    
  }
  
  private func startDownloadingData() {
    vehiclesManager.getVehiclesData { [weak self] success, errorMessage in
      if success == true {
        self?.collectionView.reloadData()
      } else {
        self?.showErrorMessage(error: errorMessage)
      }
      self?.collectionView.refreshControl?.endRefreshing()
    }
  }
  
  func showErrorMessage (error: String) {
    let alertController = UIAlertController(title: "Unable to retrieve Vehicle Data", message:
      error, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
    
    self.present(alertController, animated: true, completion: nil)
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
    cell.delegate = self
    guard
      let aVehicle = vehiclesManager.vehicle(atIndex: indexPath.row)
      else {
        return cell
    }
    
    cell.updateValues(vehicleModel: aVehicle, cellForItemAt: indexPath)
    
    return cell
  }
  
  /*
  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard
      let aVehicle = vehiclesManager.vehicle(atIndex: indexPath.row)
      else {
        return
    }
    
    
  }*/
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


extension ViewController {
  func addRefreshControl() {
    collectionView.refreshControl = UIRefreshControl()
    collectionView.refreshControl?.tintColor = Constants.blackColor
    collectionView.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: .valueChanged)
    collectionView.refreshControl?.beginRefreshing()
    
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    vehiclesManager.resetVehiclesList()
    collectionView.reloadData()
    startDownloadingData()
  }
}

extension ViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let destination = segue.destination as? AllVehiclesOnMapController {
      destination.vehiclesManager = vehiclesManager
    } else if let destination = segue.destination as? VehicleDetailController {
      
      let backItem = UIBarButtonItem()
      backItem.title = ""
      navigationItem.backBarButtonItem = backItem
      
      guard
        let index = collectionView.indexPathsForSelectedItems?.first,
        let aVehicle = vehiclesManager.vehicle(atIndex: index.row)
        else {
          return
      }
      destination.vehicleModel = aVehicle      
    }
  }
}

extension ViewController: PhoneCallHandler {
  func handlePhoneNumberTap (phoneNumber: String) {
    if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
      
      let application: UIApplication = UIApplication.shared
      if application.canOpenURL(phoneCallURL) {
        if #available(iOS 10.0, *) {
          application.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
          // Fallback on earlier versions
          application.openURL(phoneCallURL as URL)
        }
      }
    }
  }
}
