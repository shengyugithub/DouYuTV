//
//  UIBarButtonItemExtension.swift
//  DYZB
//
//  Created by 盛钰 on 24/10/2017.
//  Copyright © 2017 shengyu. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    convenience  init(imageName : String, size : CGSize) {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: size)
        self.init(customView: btn)
    }
    
}
