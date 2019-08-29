//
//  ZSSearchController.swift
//  SearchDemo
//
//  Created by 王晶 on 2019/7/28.
//  Copyright © 2019年 80263956. All rights reserved.
//

import UIKit

protocol ZSSearchViewControllerDelegate: class {
    func willPresentSearchController(_ searchController: ZSSearchViewController)
    func didPresentSearchController(_ searchController: ZSSearchViewController)
    func willDismissSearchController(_ searchController: ZSSearchViewController)
    func didDismissSearchController(_ searchController: ZSSearchViewController)
}

// 扩展是为了是协议里的方法可选
extension ZSSearchViewControllerDelegate {
    func willPresentSearchController(_ searchController: ZSSearchViewController) {}
    func didPresentSearchController(_ searchController: ZSSearchViewController) {}
    func willDismissSearchController(_ searchController: ZSSearchViewController) {}
    func didDismissSearchController(_ searchController: ZSSearchViewController) {}
}

class ZSSearchViewController: UIViewController {
    
    private lazy var bgView: UIView = {
        var _bgView = UIView.init(frame: CGRect.init(x: 0, y: self.searchBar.frame.maxY + CGSafeAreaTopHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.searchBar.height - CGStatusBarHeight))
        //        _bgView.backgroundColor = UIColor.lightGray
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(endSearchTextFieldEditing(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        _bgView.addGestureRecognizer(tapGestureRecognizer)
        return _bgView
    }()
    
    lazy var searchBar: ZSSearchBar = {
        var _searchBar = ZSSearchBar.init(frame: CGRect.zero)
        _searchBar.backgroundColor = searchBarBackgroudColor
        self.searchBarTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapSearchBarAction))
        _searchBar.addGestureRecognizer(self.searchBarTapGesture)
        return _searchBar
    }()
    
    // 在编辑状态下，展示出搜索框的背景view，遮盖在状态栏上（还原导航栏隐藏的过渡动画效果）
    private lazy var searchBarBackgroudViewWhenEdit: UIView = {
        var _searchBarBackgroudViewWhenEdit = UIView()
        _searchBarBackgroudViewWhenEdit.backgroundColor = searchBarBackgroudColor
        return _searchBarBackgroudViewWhenEdit
    }()
    
    var searchBarBackgroudColor: UIColor = UIColor.white {
        didSet {
            searchBar.backgroundColor = searchBarBackgroudColor
            searchBarBackgroudViewWhenEdit.backgroundColor = searchBarBackgroudColor
        }
    }
    
    var searchResultsController: UIViewController?
    var searchBarTapGesture: UITapGestureRecognizer!
    var isAddPanBackGesture: Bool = true // 是否添加滑动返回手势
    private var dealPanEvent = false // 是否处理滑动手势
    var changeOffsetXView: UIView? // 处理view的OffsetX
    
    weak var delegate: ZSSearchViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(searchResultsController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.searchResultsController = searchResultsController
        self.searchResultsController?.ttSearchBar = searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(bgView)
        setupResultView()
        NotificationCenter.default.addObserver(self, selector: #selector(endSearch), name: NSNotification.Name.init(SEARCH_CANCEL_NOTIFICATION_KEY), object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // ps❗️：这里设置upTouchRect是为了将触摸事件传递给 搜索框
        self.view.unTouchRect = CGRect.init(x: 0, y: 0, width: self.view.width, height: CGSafeAreaTopHeight)
        self.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func setupResultView() {
        if self.searchResultsController != nil {
            if let theView = self.searchResultsController?.view {
                self.searchResultsController?.view.frame = self.bgView.bounds
                self.bgView.addSubview(theView)
                self.addChildViewController(self.searchResultsController!)
                if isAddPanBackGesture {
                    let resultViewPan = UIPanGestureRecognizer.init(target: self, action: #selector(panResultView(pan:)))
                    self.searchResultsController?.view.addGestureRecognizer(resultViewPan)
                    // 添加左侧阴影
                    theView.viewShadowPath(shadowColor: UIColor.black, shadowOpacity: 0.4, shadowRadius: 3, shadowPathType: .left, shadowPathWidth: 3)
                }
            }
        }
    }
    
    // event方法
    @objc func panResultView(pan: UIPanGestureRecognizer) {
        guard let theView = pan.view else {
            return
        }
        switch pan.state {
        case .began:
            searchBar.resignSearchField()
            let localPoint = pan.location(in: theView)
            // 如果起始点大于100，则不处理事件
            if localPoint.x > 100 {
                dealPanEvent = false
            } else {
                dealPanEvent = true
            }
        case .changed:
            if dealPanEvent {
                let point = pan.translation(in: theView)
                pan.setTranslation(CGPoint.zero, in: theView)
                // 左滑时，如果view到了屏幕最左端，则不处理
                if point.x < 0 {
                    if theView.transform.tx <= 0 {
                        restoreOriginStyle(theView: theView)
                    } else {
                        theView.transform = CGAffineTransform(translationX: point.x, y: 0).concatenating(theView.transform)
                    }
                } else {
                    // 右滑时，如果view到了屏幕最右端，则不处理
                    if theView.transform.tx >= theView.size.width {
                        theView.transform = CGAffineTransform(translationX: theView.size.width, y: 0)
                    } else {
                        theView.transform = CGAffineTransform(translationX: point.x, y: 0).concatenating(theView.transform)
                    }
                }
                // 根据滑动的距离更改样式
                let percent = theView.transform.tx / theView.size.width
                searchBar.changeStyleWhenGestureBack(percent: percent)
                if self.changeOffsetXView != nil {
                    if percent >= 0 || percent <= 1 {
                        let per_100_width: CGFloat = 0
                        let per_0_width = self.changeOffsetXView!.width / 5
                        self.changeOffsetXView!.left = (per_0_width + (per_100_width - per_0_width) * percent) * -1
                    }
                }
            }
        case .ended:
            // 当超过一半时，退出，并还原
            if theView.transform.tx > theView.size.width / 2 {
                self.endSearch()
                changeOffsetXView?.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    self.changeOffsetXView?.alpha = 1
                }) { (finish) in
                    self.restoreOriginStyle(theView: theView)
                }
            } else {
                // 小于一半时，动画还原
                UIView.animate(withDuration: 0.1) {
                    self.restoreOriginStyle(theView: theView)
                }
            }
        default:
            print("")
        }
        
    }
    
    func restoreOriginStyle(theView: UIView) {
        theView.transform = CGAffineTransform.identity
        searchBar.restoreOriginStyle()
    }
    
    @objc func tapSearchBarAction() {
        self.delegate?.willPresentSearchController(self)
        // 让搜索框进入编辑状态
        self.searchBar.isEditing = true
        // 去掉导航栏，更新位置
        if let parent = self.searchBar.viewController?.parent as? UINavigationController {
            parent.setNavigationBarHidden(true, animated: true)
            // 给搜索框的父view添加背景view
            if let searchParent = self.searchBar.superview {
                searchParent.insertSubview(self.searchBarBackgroudViewWhenEdit, belowSubview: self.searchBar)
                self.searchBarBackgroudViewWhenEdit.isHidden = false
                self.searchBarBackgroudViewWhenEdit.frame = CGRect.init(x: 0, y: -CGStatusBarHeight, width: SCREEN_WIDTH, height: CGStatusBarHeight + self.searchBar.frame.height)
            }
            // 做过渡动画
            // 将self.view添加到searchBar所有的控制器view上，同时隐藏tabBar
            self.searchBar.viewController?.view.addSubview(self.view)
            self.searchBar.viewController?.addChildViewController(self)
            self.bgView.top = self.searchBar.frame.maxY
            self.bgView.alpha = 0.9
            UIView.animate(withDuration: 0.2, animations: {
                self.searchBar.top = CGStatusBarHeight
                self.bgView.top = self.searchBar.frame.maxY
                self.searchBarBackgroudViewWhenEdit.top = 0
                self.bgView.alpha = 1
            }) { (finish) in
                self.delegate?.didPresentSearchController(self)
                // 更改changeView的x值
                if self.changeOffsetXView != nil {
                    self.changeOffsetXView!.left = -(self.changeOffsetXView!.width / 5)
                }
                if let tabVc = self.searchBar.viewController?.tabBarController {
                    tabVc.tabBar.isHidden = true
                }
            }
        }
        self.searchBarTapGesture.isEnabled = false
    }
    
    @objc func endSearchTextFieldEditing(_ sender: UITapGestureRecognizer) {
        self.searchBar.resignSearchField()
    }
    
    @objc func endSearch() {
        self.delegate?.willDismissSearchController(self)
        if self.changeOffsetXView != nil {
            self.changeOffsetXView!.left = 0
        }
        // 移除自己，并显示tabBar
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if let tabVc = self.searchBar.viewController?.tabBarController {
            tabVc.tabBar.isHidden = false
        }
        self.delegate?.didDismissSearchController(self)
        self.searchBar.isEditing = false
        if self.searchBar.viewController?.parent != nil {
            if let navVc = self.searchBar.viewController?.parent as? UINavigationController {
                // 这里不做动画效果，原因是当导航控制器push了一层后，原先searchBar所在的控制器的view的y值会下移，导致searchBar会有个从下方回到原来位置的动画bug
                navVc.setNavigationBarHidden(false, animated: false)
                if searchBarBackgroudViewWhenEdit.superview != nil {
                    UIView.animate(withDuration: 0, animations: {
                        self.searchBarBackgroudViewWhenEdit.isHidden = true
                        self.searchBar.top = 0
                    }) { (bool) in
                        self.searchBarBackgroudViewWhenEdit.removeFromSuperview()
                    }
                }
            }
        }
        self.searchBarTapGesture.isEnabled = true
    }
    
}


var SearchBar_VC_KEY = "TT_SearchBar_VC_KEY"
extension UIViewController {
    // 添加ttSearchBar属性
    weak var ttSearchBar: ZSSearchBar? {
        set {
            objc_setAssociatedObject(self, &SearchBar_VC_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let _ttSearchBar = objc_getAssociatedObject(self, &SearchBar_VC_KEY) as? ZSSearchBar {
                return _ttSearchBar
            }
            return nil
        }
    }
}
