//
//  VDCellModels.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/11/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// VDCellModels
//    File to implement 2 Models for 2 different UICollectionView Cells
//    These Cells are used in Vehicle Detail Controller View
//    This is part of extra activity for assignment

import UIKit
import Foundation

// MARK: - Class for Cell with Properties and Text Values
class VDPropertiesAndValuesModel {
  
  var title: String
  var propertiesList: [String: String]
  
  init(title: String, properties: [String: String]) {
    self.title = title
    self.propertiesList = properties
  }
}

// MARK: - Class for Cell with Properties and Images
class VDPropertiesAndImagesModel {
  
  var title: String
  var propertiesList: [String: String]
  
  init(title: String, properties: [String: String]) {
    self.title = title
    self.propertiesList = properties
  }
}

// MARK: - logic to handle 2 different Cell types in 1 UICollectionView
protocol CellConfigurator {
  static var reuseId: String { get }

  func configure(cell: UIView, atIndex: IndexPath)
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
  static var reuseId: String { return String(describing: CellType.self) }
  
  let item: DataType
  
  init(item: DataType) {
    self.item = item
  }
  
  func configure(cell: UIView, atIndex: IndexPath) {
    guard let cell = (cell as? CellType) else {return}
    cell.configure(data: item, atIndex: atIndex)
  }
}

typealias PropertiesAndValuesCellConfigurator = CollectionCellConfigurator<VDPropertiesAndValuesCell, VDPropertiesAndValuesModel>
typealias PropertiesAndImageCellConfigurator = CollectionCellConfigurator<VDPropertiesAndImagesCell, VDPropertiesAndImagesModel>

class VDPropertiesModel {
  var items: [CellConfigurator] = []
  init(items: [CellConfigurator]) {
  }
}
