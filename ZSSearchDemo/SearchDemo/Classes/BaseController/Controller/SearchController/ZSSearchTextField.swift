//
//  ZSSearchTextField.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSSearchTextField: UITextField {

    var canTouch = true
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = super.point(inside: point, with: event)
        return canTouch ? result : false
    }
    
}
