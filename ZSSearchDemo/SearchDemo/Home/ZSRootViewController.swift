//
//  ZSRootViewController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSRootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZSSearchControllerDelegate, ZSSearchControllerhResultsUpdating, ZSSearchBarDelegate {


    lazy var searchController: ZSSearchController = {
        let resultVc = ZSSearchResultController.init(nibName: nil, bundle: nil)
        var _searchController = ZSSearchController.init(searchResultsController: resultVc)
        _searchController.searchBar.placeholder = "搜索"
        _searchController.searchResultsUpdater = self
        _searchController.delegate = self
        _searchController.searchBar.delegate = self
        return _searchController
    }()
    
    lazy var tableView: UITableView = {
        var _tableView = UITableView.init()
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseID")
        return _tableView
    }()
    
    // 测试数据
    lazy var dataArray: [String] = {
       var _dataArray = ["AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC", "AAA", "BBB", "CCC"]
        return _dataArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID") {
            cell.textLabel?.text = self.dataArray[indexPath.row]
            return cell
        }
        return UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44)
    }
    
    //MARK: ZSSearchControllerhResultsUpdating
    func updateSearchResultsForSearchController(_ searchController: ZSSearchController) {
        let searchText = searchController.searchBar.text
        print("当前搜索框的内容为 \(searchText ?? "")")
    }
}



