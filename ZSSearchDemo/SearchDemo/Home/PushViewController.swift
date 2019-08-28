//
//  PushViewController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/8/21.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    lazy var searchBar: ZSSearchBar = {
        var _searchBar = ZSSearchBar.init(frame: CGRect.zero)
        _searchBar.isEditing = true
        _searchBar.backgroundColor = UIColor.themeColor
        _searchBar.addObserver(self, forKeyPath: "text", options: [.new, .old], context: nil)
        _searchBar.cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        return _searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationItem.titleView = self.searchBar
        self.view.addSubview(self.searchBar)
        self.view.backgroundColor = UIColor.orange
        self.navigationItem.title = "push"
    }

}
