//
//  UIScrollView+Extension.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/8/28.
//  Copyright © 2019 80263956. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: self)
            //            print("velocity = \(velocity.x), \(velocity.y)")
            let point = panGestureRecognizer.location(in: self)
            if point.x <= 30 {
                // 都等于0时表示滑动的过程中再次触发了手势，此时返回false，将手势传递给其他手势（如返回上一页手势）
                if velocity.x == 0 && velocity.y == 0 {
                    return false
                }
            }
        }
        return true
    }
}
