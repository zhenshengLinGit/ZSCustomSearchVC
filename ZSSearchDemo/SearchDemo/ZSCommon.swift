//
//  ZSCommon.swift
//  SearchDemo
//
//  Created by 王晶 on 2019/7/27.
//  Copyright © 2019年 80263956. All rights reserved.
//

import Foundation
import UIKit

// 颜色
func ZSColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}


// 尺寸
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

func IPHONE_X() -> Bool {
    var isPhoneX = false
    if #available(iOS 11.0, *) {
        if let safeBottom = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom {
                isPhoneX = safeBottom > 0
        }
    }
    return isPhoneX
}

let SafeAreaTopHeight = IPHONE_X() ? 88 : 64
let SafeAreaBottomHeight = IPHONE_X() ?  (49 + 34) : 49
let StatusBarHeight = IPHONE_X() ?  44 : 20

let CGSafeAreaTopHeight = CGFloat(SafeAreaTopHeight)
let CGSafeAreaBottomHeight = CGFloat(SafeAreaBottomHeight)
let CGStatusBarHeight = CGFloat(StatusBarHeight)
