//
//  ZSTabBarController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSTabBarController: UITabBarController {
    
    let rootVc = ZSRootViewController.init()
    let contactsVc = ZSContactsViewController.init()
    let findVc = ZSFindViewController.init()
    let meVc = ZSMeViewController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildrenViewController()
    }
    
    func addChildrenViewController() {
        self.addChildrenViewController(children: rootVc, title: "微信", imageName: "tabbar_mainframe", seletedImageName: "tabbar_mainframeHL")
        self.addChildrenViewController(children: contactsVc, title: "通讯录", imageName: "tabbar_contacts", seletedImageName: "tabbar_contactsHL")
        self.addChildrenViewController(children: findVc, title: "发现", imageName: "tabbar_discover", seletedImageName: "tabbar_discoverHL")
        self.addChildrenViewController(children: meVc, title: "我", imageName: "tabbar_me", seletedImageName: "tabbar_meHL")
    }
    
    func addChildrenViewController(children: UIViewController, title: String, imageName: String, seletedImageName: String) {
        let image = UIImage.init(named: imageName)
        let seletedImage = UIImage.init(named: seletedImageName)
        children.tabBarItem.image = image
        children.tabBarItem.selectedImage = seletedImage
        children.tabBarItem.title = title
        children.navigationItem.title = title
        let navVc = ZSNavigationController.init(rootViewController: children)
        self.addChildViewController(navVc)
    }
}
