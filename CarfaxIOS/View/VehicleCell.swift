//
//  VehicleCell.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit

//
// VehicleCell
//      UICollectionViewCell for 1 Vehicle
//

protocol PhoneCallHandler: class {
  func handlePhoneNumberTap (phoneNumber: String)
}

class VehicleCell: UICollectionViewCell {
    
  // MARK: - Outlets
  @IBOutlet weak var vehicleYearMakeModel: UILabel!
  @IBOutlet weak var vehiclePriceMileageLocation: UILabel!
  @IBOutlet weak var vehicleImageView: UIImageView!
  @IBOutlet weak var phoneNumber: UIButton!
  
  var vehicleModel: VehicleModel?
  // MARK: - overrides
  weak var delegate: PhoneCallHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initFontsAndColors()
  }
  
  func initFontsAndColors() {
    vehicleYearMakeModel.font = Constants.systemFontBoldSize12
    vehicleYearMakeModel.textColor = Constants.blackColor
  }
  
  func updateValues(vehicleModel: VehicleModel, cellForItemAt indexPath: IndexPath) {
    self.vehicleModel = vehicleModel
    
    vehicleYearMakeModel.text = vehicleModel.formattedYearMakeModelTrim()
    vehiclePriceMileageLocation.attributedText = vehicleModel.formattedPriceMileageLocation()
    phoneNumber.setTitle(vehicleModel.formattedPhoneNumber(), for: .normal)
    updateVehicleImage(vehicleModel: vehicleModel, cellForItemAt: indexPath)
  }
  
  func updateVehicleImage(vehicleModel: VehicleModel, cellForItemAt indexPath: IndexPath) {
    vehicleImageView.image = nil
    
    let imgURL = vehicleModel.mediumImage
    if let cacheImage = CacheManager.shared.getImageFromCache(key: imgURL) {
      vehicleImageView.image = cacheImage
    } else {
      guard let url = URL(string: imgURL) else { return  }
      
      DispatchQueue.global().async {
        let data = try? Data(contentsOf: url)
        if let data = data, let image = UIImage(data: data) {
          CacheManager.shared.setImage(image: image, forKey: imgURL)
          DispatchQueue.main.async {
            
            // let us ensure that the correct cell is still visible
            // else we will add the image to wrong cell since cells are deque-ed and re-used
            if self.tag == indexPath.row {
              self.vehicleImageView.image = image
            }
          }
        }
      }
    }
  }

  // MARK: - User Action Handling
  @IBAction func callPhoneTapped(_ sender: Any) {
    
    guard let phoneNumber = self.vehicleModel?.phone else {return}
    
    delegate?.handlePhoneNumberTap(phoneNumber: phoneNumber)
  }
}
