//
//  VDCellViews.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import Foundation

protocol ConfigurableCell {
  associatedtype DataType
  func configure(data: DataType, atIndex: IndexPath)
}

class VDPropertiesAndValuesCell: UICollectionViewCell, ConfigurableCell {
  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var property0: UILabel!
  @IBOutlet weak var value0: UILabel!
  @IBOutlet weak var property1: UILabel!
  @IBOutlet weak var value1: UILabel!
  @IBOutlet weak var property2: UILabel!
  @IBOutlet weak var value2: UILabel!
  @IBOutlet weak var property3: UILabel!
  @IBOutlet weak var value3: UILabel!
  
  func configure(data cellModel: VDPropertiesAndValuesModel, atIndex: IndexPath) {
    title.text = cellModel.title
    property0.text = cellModel.propertiesList["property0"]
    property1.text = cellModel.propertiesList["property1"]
    property2.text = cellModel.propertiesList["property2"]
    property3.text = cellModel.propertiesList["property3"]
    
    value0.text = cellModel.propertiesList["value0"]
    value1.text = cellModel.propertiesList["value1"]
    value2.text = cellModel.propertiesList["value2"]
    value3.text = cellModel.propertiesList["value3"]
  }
}

class VDPropertiesAndImagesCell: UICollectionViewCell, ConfigurableCell {
  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var property0: UILabel!
  @IBOutlet weak var imageView0: UIImageView!
  @IBOutlet weak var property1: UILabel!
  @IBOutlet weak var imageView1: UIImageView!
  @IBOutlet weak var property2: UILabel!
  @IBOutlet weak var imageView2: UIImageView!
  @IBOutlet weak var property3: UILabel!
  @IBOutlet weak var imageView3: UIImageView!
  
  func configure(data cellModel: VDPropertiesAndImagesModel, atIndex: IndexPath) {
    title.text = cellModel.title
    
    property0.text = cellModel.propertiesList["property0"]
    property1.text = cellModel.propertiesList["property1"]
    property2.text = cellModel.propertiesList["property2"]
    property3.text = cellModel.propertiesList["property3"]
    
    if let imageURL0 = cellModel.propertiesList["value0"] {
      self.update(imageView: imageView0, with: imageURL0, at: atIndex)
    }
    
    if let imageURL1 = cellModel.propertiesList["value1"] {
      self.update(imageView: imageView1, with: imageURL1, at: atIndex)
    }
    
    if let imageURL2 = cellModel.propertiesList["value2"] {
      self.update(imageView: imageView2, with: imageURL2, at: atIndex)
    }
    
    if let imageURL3 = cellModel.propertiesList["value3"] {
      self.update(imageView: imageView3, with: imageURL3, at: atIndex)
    }
  }
  
  func update(imageView: UIImageView, with imageName: String, at cellForItemAt: IndexPath) {
    imageView.image = nil
    
    let imgURL = imageName
    if let cacheImage = CacheManager.shared.getImageFromCache(key: imgURL) {
      imageView.image = cacheImage
    } else {
      guard let url = URL(string: imgURL) else { return  }
      
      DispatchQueue.global().async {
        let data = try? Data(contentsOf: url)
        if let data = data, let image = UIImage(data: data) {
          CacheManager.shared.setImage(image: image, forKey: imgURL)
          DispatchQueue.main.async {
            
            // let us ensure that the correct cell is still visible
            // else we will add the image to wrong cell since cells are deque-ed and re-used
            if self.tag == cellForItemAt.row {
              imageView.image = image
            }
          }
        }
      }
    }
  }
}
