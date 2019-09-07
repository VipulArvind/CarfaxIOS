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

class VehicleCell: UICollectionViewCell {
    
  // MARK: - Outlets
  @IBOutlet weak var vehicleYearMakeModel: UILabel!
  @IBOutlet weak var vehiclePriceMileageLocation: UILabel!
  @IBOutlet weak var vehicleImageView: UIImageView!
  
  // MARK: - overrides
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: - User Action Handling
  @IBAction func callPhoneTapped(_ sender: Any) {
  }
}
