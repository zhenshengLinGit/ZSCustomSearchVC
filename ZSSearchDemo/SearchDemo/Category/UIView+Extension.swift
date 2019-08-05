//
//  UIView+Extension.swift
//  SearchDemo
//
//  Created by 王晶 on 2019/7/28.
//  Copyright © 2019年 80263956. All rights reserved.
//

import Foundation
import UIKit

var UN_TOUCH_RECT_KEY = "JKR_UN_TOUCH_RECT"

extension UIView: SelfAware {
    static func awake() {
        UIView.takeOnceTime
    }
    // ❤️参考文章：https://www.jianshu.com/p/23ea81be5cc2
    private static let takeOnceTime: Void = {
        let originalSelector = #selector(point(inside:with:))
        let swizzledSelector = #selector(zs_point(inside:with:))
        swizzlingForClass(UIView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
}

extension UIView {
// ====================  Frame ====================
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
// ====================  view所在的控制器 ====================
    var locate_viewController: UIViewController? {
        var next = self.next
        while next != nil {
            if let result = next! as? UIViewController {
                return result
            }
            next = next!.next
        }
        return nil
    }
    
// ====================  触摸事件相关 ====================
    var unTouchRect: CGRect {
        set {
            objc_setAssociatedObject(self, &UN_TOUCH_RECT_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let _unTouchRect = objc_getAssociatedObject(self, &UN_TOUCH_RECT_KEY) as? CGRect {
                return _unTouchRect
            }
            return CGRect.zero
        }
    }
    
    @objc func zs_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.unTouchRect.equalTo(CGRect.zero)  {
            return self.zs_point(inside:point, with:event)
        } else {
            if self.unTouchRect.contains(point) {
                return false
            } else {
                return self.zs_point(inside:point, with:event)
            }
        }
    }
    
}
 
