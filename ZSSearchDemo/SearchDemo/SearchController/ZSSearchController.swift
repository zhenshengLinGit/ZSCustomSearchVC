//
//  ZSSearchController.swift
//  SearchDemo
//
//  Created by 王晶 on 2019/7/28.
//  Copyright © 2019年 80263956. All rights reserved.
//

import UIKit

protocol ZSSearchControllerDelegate: class {
    func willPresentSearchController(_ searchController: ZSSearchController)
    func didPresentSearchController(_ searchController: ZSSearchController)
    func willDismissSearchController(_ searchController: ZSSearchController)
    func didDismissSearchController(_ searchController: ZSSearchController)
}

// 扩展是为了是协议里的方法可选
extension ZSSearchControllerDelegate {
    func willPresentSearchController(_ searchController: ZSSearchController) {}
    func didPresentSearchController(_ searchController: ZSSearchController) {}
    func willDismissSearchController(_ searchController: ZSSearchController) {}
    func didDismissSearchController(_ searchController: ZSSearchController) {}
}

protocol ZSSearchControllerhResultsUpdating {
    func updateSearchResultsForSearchController(_ searchController: ZSSearchController)
}

extension ZSSearchControllerhResultsUpdating {
    func updateSearchResultsForSearchController(_ searchController: ZSSearchController) {}
}

class ZSSearchController: UIViewController {

    deinit {
        searchBar.removeObserver(self, forKeyPath: "text")
    }
    
    private lazy var bgView: UIView = {
        var _bgView = UIView.init(frame: CGRect.init(x: 0, y: self.searchBar.frame.maxY + CGSafeAreaTopHeight, width: kScreenWidth, height: kScreenHeight - self.searchBar.height - CGStatusBarHeight))
        _bgView.backgroundColor = UIColor.lightGray
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(endSearchTextFieldEditing(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        _bgView.addGestureRecognizer(tapGestureRecognizer)
        return _bgView
    }()

    lazy var searchBar: ZSSearchBar = {
        var _searchBar = ZSSearchBar.init(frame: CGRect.zero)
        self.searchBarTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapSearchBarAction))
        _searchBar.addGestureRecognizer(self.searchBarTapGesture)
        _searchBar.addObserver(self, forKeyPath: "text", options: [.new, .old], context: nil)
        return _searchBar
    }()
    
    var searchResultsController: UIViewController?
    var searchBarTapGesture: UITapGestureRecognizer!
    
    weak var delegate: ZSSearchControllerDelegate?
    
    var searchResultsUpdater: ZSSearchControllerhResultsUpdating?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(searchResultsController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.searchResultsController = searchResultsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(bgView)
        // ps❗️：这里设置upTouchRect是为了将触摸事件传递给 搜索框
        self.view.unTouchRect = CGRect.init(x: 0, y: 0, width: self.view.width, height: CGSafeAreaTopHeight)
        self.searchResultsController?.view.frame = self.bgView.bounds
        if self.searchResultsController != nil {
            self.bgView.addSubview(self.searchResultsController!.view)
            self.addChildViewController(self.searchResultsController!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(endSearch), name: NSNotification.Name.init(SEARCH_CANCEL_NOTIFICATION_KEY), object: nil)
    }
    
    // event方法
    @objc func tapSearchBarAction() {
        self.delegate?.willPresentSearchController(self)
        // 将当前vc的view添加到window上
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.view)
        self.delegate?.didPresentSearchController(self)
        // 让搜索框进入编辑状态
        self.searchBar.isEditing = true
        // 去掉导航栏，更新位置
        if let parent = self.searchBar.locate_viewController?.parent as? UINavigationController {
            parent.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.2) {
                self.bgView.y = CGSafeAreaTopHeight
            }
        }
        self.searchBarTapGesture.isEnabled = false
    }
    
    @objc func endSearchTextFieldEditing(_ sender: UITapGestureRecognizer) {
        self.searchBar.resignSearchField()
    }
    
    @objc func endSearch() {
        self.delegate?.willDismissSearchController(self)
        // 移除自己
        self.view.removeFromSuperview()
        self.delegate?.didDismissSearchController(self)
        self.searchBar.isEditing = false
        if self.searchBar.locate_viewController?.parent != nil {
            if let navVc = self.searchBar.locate_viewController?.parent as? UINavigationController {
                navVc.setNavigationBarHidden(false, animated: true)
                self.bgView.y = self.searchBar.frame.maxY + CGSafeAreaTopHeight
            }
        }
        self.searchBarTapGesture.isEnabled = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            self.searchResultsUpdater?.updateSearchResultsForSearchController(self)
        }
    }
}
