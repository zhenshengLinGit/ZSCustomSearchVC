//
//  ZSNavigationController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    var fullScreenPopGestureRecorgnizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置了此行代码，VC才会回调preferredStatusBarStyle方法
        self.navigationBar.barStyle = UIBarStyle.black
        addFullScreenPopGesture()
    }
    
    private func addFullScreenPopGesture() {
        interactivePopGestureRecognizer?.isEnabled = false
        let target = interactivePopGestureRecognizer?.delegate
        fullScreenPopGestureRecorgnizer = UIPanGestureRecognizer.init(target: target,
                                                                      action: Selector.init(("handleNavigationTransition:")))
        view.addGestureRecognizer(fullScreenPopGestureRecorgnizer)
        fullScreenPopGestureRecorgnizer.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
