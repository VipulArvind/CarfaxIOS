//
//  AllVehiclesOnMapController.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/8/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

//
// AllVehiclesOnMapController
//      Extra part of the exercise
//      Shows all Vehicles in map view
//

class AllVehiclesOnMapController: UIViewController {    
    
  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var closeButton: UIButton!
  
  var vehiclesManager: VehiclesManager = VehiclesManager()
  
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
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
        
    initUI()
    initMap()
  }
    
  override var prefersStatusBarHidden: Bool {
      return true
  }
    
  // MARK: - Private methoids
  private func initUI() {
    closeButton.layer.backgroundColor = Constants.carfaxBlueColor.cgColor
    closeButton.layer.borderWidth = 2
    closeButton.layer.borderColor = UIColor.gray.cgColor
    closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
  }
    
  private func initMap() {
    mapView.delegate = self
    mapView.register(VehicleAnnotationView.self,
                      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    guard
        let firstVehicle = vehiclesManager.first()
      else {
          return
      }
        
    let regionRadius: CLLocationDistance = 50000
    let coordinateRegion = MKCoordinateRegion(center: firstVehicle.coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
      mapView.addAnnotations(vehiclesManager.allVehicles())
    }
    
  // MARK: - User Action Handling
  @IBAction func closeTapped(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

//
// extension AllVehiclesOnMapController
//      Mark: - Contains code to launch directions when user will tap the right hand accessory button on map callout
//

extension AllVehiclesOnMapController: MKMapViewDelegate {
    
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    guard
        let location = view.annotation as? VehicleModel
      else {
          return
      }
        
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    location.mapItem().openInMaps(launchOptions: launchOptions)
  }
}
