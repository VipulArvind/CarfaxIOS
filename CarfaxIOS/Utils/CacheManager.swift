//
//  CacheManager.swift
//  CarfaxIOS
//
//  Created by Vipul Arvind on 9/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit

//
// CacheManager
//      Class to implement the singleton for managing the image cache
//      Uses NSCache for cache management
//

final class CacheManager: NSObject {  
    
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = CacheManager()
    weak var observer: NSObjectProtocol?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.imageCache.removeAllObjects()
        }
    }
 
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
  
    // MARK: - Public Methods
    func getImageFromCache(key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }

    func setImage(image: UIImage, forKey: String) {
        imageCache.setObject(image, forKey: forKey as NSString)
    }
}
