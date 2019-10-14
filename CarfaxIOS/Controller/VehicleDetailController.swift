//
//  VehicleDetailController.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/8/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

//
// VehicleDetailController
//      Shows details of 1 Vehicle
//      Uses Location manager to show the User's current location
//

class VehicleDetailController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var vehiclePriceMileageLocation: UILabel!
  @IBOutlet weak var VDCollectionView: UICollectionView!

  // MARK: - Vars
  let locationManager = CLLocationManager()
  var vehicleModel = VehicleModel()
  var vehiclePropertiesModel =  VDPropertiesModel(items: [])
    
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
    
  // This extends the superclass.
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
    
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  // MARK: - opverrides
  override func viewDidLoad() {
    super.viewDidLoad()
        
    locationManager.delegate = self
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.showsUserLocation = true
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
        
    initFontAndColors()
    initMap()
    initVehicleDetails()
  }
    
  override var prefersStatusBarHidden: Bool {
    return true
  }
    
  // MARK: - Private Initialzation
  private func initFontAndColors() {
    self.title = vehicleModel.formattedYearMakeModelTrim()
        
    vehiclePriceMileageLocation.font = Constants.systemFontSize12
    vehiclePriceMileageLocation.textColor = Constants.whiteColor
  }
    
  private func initMap() {
    let regionRadius: CLLocationDistance = 500
                
    let coordinateRegion = MKCoordinateRegion(center: vehicleModel.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  // we are dividing the Vehicle details in 4 Cells
  // each cell will hold 4 sets of properties
  //
  // further this collectioview handles 2 different types of cells
  // 1 which displays Properties and there text values (for example Bodytype -> Sedan)
  // 2nd which displays Properties and there assocaited imag icons (for example Accident Histiry -> Icon denoting the accident history)
  private func initVehicleDetails() {

    vehiclePriceMileageLocation.text = vehicleModel.formattedPriceMileageLocation().string
    
    // data model from Vehicle Details for the CollectionView
    
    let propertiesQuickView = ["property0": vehicleModel.accidentHistoryText, "value0": vehicleModel.accidentHistoryIconURL,
                               "property1": vehicleModel.ownerHistoryText, "value1": vehicleModel.ownerHistoryIconURL,
                               "property2": vehicleModel.serviceHistoryText, "value2": vehicleModel.serviceHistoryIconURL,
                               "property3": vehicleModel.vehicleUseHistoryText, "value3": vehicleModel.vehicleUseHistoryIconURL
    ]
    
    let propertiesVehicleInfo = ["property0": "Body Type", "value0": vehicleModel.bodytype,
                                 "property1": "Color Ext/Int", "value1": vehicleModel.exteriorInteriorColors(),
                                 "property2": "MPG City/Highway", "value2": vehicleModel.combinedMileage(),
                                 "property3": "Vin", "value3": vehicleModel.vin
    ]
    
    let propertiesDealerInfo = ["property0": "Name", "value0": vehicleModel.dealerName,
                                "property1": "Rating", "value1": String(vehicleModel.dealerAverageRating),
                                "property2": "Address", "value2": vehicleModel.dealerAddr1,
                                "property3": "", "value3": vehicleModel.formattedCityStateZipFromDealerAddress()
    ]
    
    let propertiesFinancingInfo = ["property0": "Loan Amount", "value0": vehicleModel.loanAmount.currencyFormat(fractionDigits: 0),
                                 "property1": "Down Payment", "value1": vehicleModel.downPaymentAmount.currencyFormat(fractionDigits: 0),
                                 "property2": "Interest Rate", "value2": String(vehicleModel.interestRate.percentageFormat()),
                                 "property3": "Monthly Payments", "value3": vehicleModel.formattedMonthlyPaymentsWithMonths()
    ]
    
    let items: [CellConfigurator] = [
      PropertiesAndImageCellConfigurator(item: VDPropertiesAndImagesModel(title: "Quick View", properties: propertiesQuickView)),
      PropertiesAndValuesCellConfigurator(item: VDPropertiesAndValuesModel(title: "Vehicle Info", properties: propertiesVehicleInfo)),
      PropertiesAndValuesCellConfigurator(item: VDPropertiesAndValuesModel(title: "Dealer Info", properties: propertiesDealerInfo)),
      PropertiesAndValuesCellConfigurator(item: VDPropertiesAndValuesModel(title: "Financing Info", properties: propertiesFinancingInfo))
    ]
    
    vehiclePropertiesModel.items = items
    
    VDCollectionView.dataSource = self
    VDCollectionView.delegate = self
  }
}

//
// extension VehicleDetailController
//      Mark: - Contains code to implement CLLocationManagerDelegate
//

extension VehicleDetailController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
}

extension VehicleDetailController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return vehiclePropertiesModel.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = vehiclePropertiesModel.items[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
    item.configure(cell: cell, atIndex: indexPath)
    
    return cell
  }
}

extension VehicleDetailController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    let width = (UIDevice.current.userInterfaceIdiom == .phone) ? collectionViewWidth : collectionViewWidth / 2 - 2
    return CGSize(width: width, height: 180.0)
  }
}
