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
    //MARK: iPhone X适配属性
    /** 高度减去iPhone X底部不安全高度*/
    var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return height - safeAreaInsets.bottom
        } else {
            return height
        }
    }
    
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.bottom
        } else {
            return 0
        }
    }
    
    /** iPhone X顶部不安全高度*/
    var safeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.top
        } else {
            return 0
        }
    }
    
    /** iPhone X安全区域高度*/
    var safeAreaHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return height - safeAreaInsets.bottom - safeAreaInsets.top
        } else {
            return height
        }
    }
    
    /****************************************************************************************************/
    //MARK: 尺寸信息以及尺寸更改
    //任何尺寸更改都不会改变视图的位置
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    //MARK: -
    /****************************************************************************************************/
    
    /****************************************************************************************************/
    //MARK: 位置信息以及位置更改
    //任何位置信息更改都不会改变视图的尺寸
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.top + self.height
        }
        set {
            //设置bottom需要注意，如果先设置bottom再设置height，那得到的效果可能不是你想要的
            self.frame.origin.y = newValue - self.height
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return self.left + self.width
        }
        set {
            //设置right需要注意，如果先设置right再设置width，得到的效果可能不是你想要的
            self.frame.origin.x = newValue - self.width
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }
    //MARK: -
    /****************************************************************************************************/
    
    /****************************************************************************************************/
    //MARK: 适应性布局设置
    //例如：当改变left位置的时候，自适应宽度好保持视图right位置不变
    
    func autoLeft(_ new: CGFloat) {
        let widthChanged = left - new
        left = new
        width += widthChanged
    }
    
    func autoRight(_ new: CGFloat) {
        let widthChanged = right - new
        width -= widthChanged
    }
    
    func autoTop(_ new: CGFloat) {
        let heightChanged = top - new
        top = new
        height += heightChanged
    }
    
    func autoBottom(_ new: CGFloat) {
        let heightChanged = bottom - new
        height -= heightChanged
    }
    
// ====================  view所在的控制器 ====================
    var viewController: UIViewController? {
        if let nextVC = next as? UIViewController {
            return nextVC
        }
        if let nextView = next as? UIView {
            return nextView.viewController
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
 
