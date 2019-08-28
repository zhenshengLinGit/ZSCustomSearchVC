//
//  ZSSearchResultController.swift
//  SearchDemo
//
//  Created by 王晶 on 2019/7/28.
//  Copyright © 2019年 80263956. All rights reserved.
//

import UIKit

class ZSSearchResultController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let theView = UIView.init()
        theView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        theView.backgroundColor = UIColor.cyan
        view.addSubview(theView)
        theView.viewShadowPath(shadowColor: UIColor.black, shadowOpacity: 0.4, shadowRadius: 3, shadowPathType: .left, shadowPathWidth: 2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
