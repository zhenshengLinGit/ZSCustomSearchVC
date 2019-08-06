//
//  UIColor+Extension.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/8/5.
//  Copyright © 2019 80263956. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /** 根据颜色和尺寸绘制图片*/
    func imageIn(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(CGRect.init(origin: CGPoint.zero, size: size))
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}


//MARK: 颜色属性
extension UIColor {
    class var themeColor: UIColor { return ZSColor(29, 202, 172, 1) }
}
