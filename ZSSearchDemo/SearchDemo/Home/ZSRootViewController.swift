//
//  ZSRootViewController.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

class ZSRootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZSSearchViewControllerDelegate, ZSSearchBarDelegate {


    lazy var searchController: ZSSearchViewController = {
        let resultVc = ZSSearchResultController.init(nibName: nil, bundle: nil)
        var _searchController = ZSSearchViewController.init(searchResultsController: resultVc)
        _searchController.searchBarBackgroudColor = UIColor.themeColor
        _searchController.searchBar.placeholder = "搜索"
        _searchController.searchBar.cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
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
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.themeColor.imageIn(size: CGSize.init(width: SCREEN_WIDTH, height: CGFloat(CGSafeAreaTopHeight))), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.addSubview(searchController.searchBar)
        searchController.searchBar.top = 0
        tableView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGSafeAreaTopHeight)
        tableView.contentInset = UIEdgeInsets.init(top: searchController.searchBar.top + searchController.searchBar.height, left: 0, bottom: 0, right: 0)
        self.view.insertSubview(tableView, belowSubview: searchController.searchBar)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushVC = PushViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK: scrollviewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetYContainInset = scrollView.contentOffset.y + scrollView.contentInset.top
        print("contentOffsetYContainInset = \(contentOffsetYContainInset)")
        let maxY = searchController.searchBar.height
        var adjustY = CGFloat(0)
        if contentOffsetYContainInset > 0 {
            adjustY = min(contentOffsetYContainInset, maxY)
            adjustY *= -1
        } else {
            adjustY = CGFloat(0)
        }
        // 判断searchBar不在编辑状态下，才调整top值。（编辑状态下由searchController来调整）
        if searchController.searchBar.top != adjustY, !searchController.searchBar.isEditing {
            searchController.searchBar.top = adjustY
        }
    }
    
    // 搜索关键字输入
    func searchBar(_ searchBar: ZSSearchBar, textDidChange searchText: String) {
        let key = searchText
        print("当前搜索框的内容为\(key)")
    }
}



