//
//  ZSBaseViewController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/8/29.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ZSBaseViewController: UINavigationControllerDelegate {
    
    /** 注册隐藏导航栏，建议在viewWillAppear方法中调用 */
    func registerNavigationBarHidden() {
        navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else {
            // 导航控制器为系统相册不处理
            if navigationController is UIImagePickerController {
                return
            }
            // 此时才显示navigationBar
            navigationController.setNavigationBarHidden(false, animated: animated)
            // 将代理置空
            if navigationController.delegate === self {
                navigationController.delegate = nil
            }
        }
        
    }
}
