//
//  ZSSearchBar.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit


let SEARCH_CANCEL_NOTIFICATION_KEY = "SEARCH_CANCEL_NOTIFICATION_KEY"
let SEARCH_RESIGN_NOTIFICATION_KEY = "SEARCH_RESIGN_NOTIFICATION_KEY"  //取消第一响应者

protocol ZSSearchBarDelegate: class {
    func searchBarTextDidBeginEditing(_ searchBar: ZSSearchBar)
    func searchBarTextDidEndEditing(_ searchBar: ZSSearchBar)
    func searchBar(_ searchBar: ZSSearchBar, textDidChange searchText: String)
}

extension ZSSearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: ZSSearchBar) {}
    func searchBarTextDidEndEditing(_ searchBar: ZSSearchBar) {}
    func searchBar(_ searchBar: ZSSearchBar, textDidChange searchText: String) {}
}

class ZSSearchBar: UIView, UITextFieldDelegate {
    
    // 当存在时，搜索框有返回按钮
    var showBack: Bool = false {
        didSet {
            self.setupFrame()
        }
    }
    
    var placeholder: String? {
        didSet {
            self.searchTextField.placeholder = placeholder
        }
    }
    
    var animateWhenChangeEditing: Bool = true
    var isEditing: Bool = false {
        didSet {
            if isEditing {
                // 添加动画
                UIView.animate(withDuration: animateWhenChangeEditing ? 0.2 : 0, animations: {
                    self.searchTextField.left = self.backButton.right
                    self.rightButton.left = SCREEN_WIDTH - self.rightButton.width - self.cancelButton.width
                    self.backgroudImageView.width = self.backgourdImageViewWidth(isEditing: true)
                    self.cancelButton.left = SCREEN_WIDTH - self.cancelButton.width
                }) { (finished) in
                    self.searchTextField.width = SCREEN_WIDTH - self.backButton.right - 10 - self.rightButton.width - self.cancelButton.width
                }
                searchTextField.canTouch = true
                if animateWhenChangeEditing {
                    searchTextField.becomeFirstResponder()
                }
            } else {
                text = ""
                UIView.animate(withDuration: animateWhenChangeEditing ? 0.2 : 0, animations: {
                    self.searchTextField.left = SCREEN_WIDTH * 0.5 - 40
                    self.rightButton.left = SCREEN_WIDTH - 38
                    self.backgroudImageView.width = self.backgourdImageViewWidth(isEditing: false)
                    self.cancelButton.left = SCREEN_WIDTH
                }) { (finished) in
                    self.searchTextField.width = SCREEN_WIDTH * 0.5
                }
                searchTextField.canTouch = false
                searchTextField.resignFirstResponder()
            }
        }
    }
    
    @objc dynamic var text: String = "" {
        didSet {
            if text != self.searchTextField.text {
                self.searchTextField.text = text
                // 给TextField.text主动赋值的时候，不会触发editingChanged事件，主动调用
                delegate?.searchBar(self, textDidChange: text)
            }
            rightButton.isHidden = text.count == 0 ? true : false
        }
    }
    
    weak var delegate: ZSSearchBarDelegate?
    
    lazy var backgroudImageView: UIImageView = {
        var _backgroudImageView = UIImageView.init(image: UIImage.init(named: "widget_searchbar_textfield"))
        _backgroudImageView.contentMode = .scaleToFill
        return _backgroudImageView
    }()
    
    lazy var searchTextField: ZSSearchTextField = {
        var _searchTextField = ZSSearchTextField.init()
        _searchTextField.canTouch = false
        _searchTextField.placeholder = "搜索"
        var searchIcon = UIImageView.init(image: UIImage.init(named: "SearchContactsBarIcon"))
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 20)
        _searchTextField.leftView = searchIcon
        _searchTextField.leftViewMode = .always
        _searchTextField.font = UIFont.systemFont(ofSize: 16.0)
        _searchTextField.autocorrectionType = UITextAutocorrectionType.no // 关闭系统键盘的自动联想
        _searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        _searchTextField.delegate = self
        return _searchTextField
    }()
    
    lazy var rightButton: UIButton = {
        var _rightButton = UIButton.init(type: UIButtonType.custom)
        _rightButton.setImage(UIImage.init(named: "card_delete"), for: UIControlState.normal)
        _rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        _rightButton.isHidden = true
        return _rightButton
    }()
    
    lazy var cancelButton: UIButton = {
        var _cancelButton = UIButton.init(type: UIButtonType.custom)
        _cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _cancelButton.setTitle("取消", for: UIControlState.normal)
        _cancelButton.setTitleColor(UIColor.init(R: 85, G: 183, B: 55, A: 1.0), for: UIControlState.normal)
        _cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControlEvents.touchUpInside)
        return _cancelButton
    }()
    
    lazy var backButton: UIButton = {
        var _backButton = UIButton.init(type: UIButtonType.custom)
        // 图片宽是22
        let sizeW = 44
        _backButton.setImage(UIImage.init(named: "btn_navigationbar_back"), for: UIControlState.normal)
        _backButton.addTarget(self, action: #selector(backButtonClick), for: UIControlEvents.touchUpInside)
        return _backButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        let vFrame = CGRect.init(x: 0, y: 0, width:SCREEN_WIDTH , height: 44)
        super.init(frame: vFrame)
        self.backgroundColor = UIColor.init(R: 243, G: 243, B: 243, A: 1.0)
        self.addSubview(backgroudImageView)
        self.addSubview(searchTextField)
        self.addSubview(rightButton)
        self.addSubview(cancelButton)
        self.addSubview(backButton)
        self.setupFrame()
        NotificationCenter.default.addObserver(self, selector: #selector(resignSearchField), name: NSNotification.Name.init(SEARCH_RESIGN_NOTIFICATION_KEY), object: nil)
    }
    
    func setupFrame() {
        backgroudImageView.frame = CGRect.init(x: 10, y: 8, width: SCREEN_WIDTH - 20, height: 44 - 16)
        searchTextField.frame = CGRect.init(x: SCREEN_WIDTH * 0.5 - 40, y: 0, width: SCREEN_WIDTH * 0.5, height: 44)
        rightButton.frame = CGRect.init(x: SCREEN_WIDTH - 38, y: 8, width: 28, height: 28)
        cancelButton.frame = CGRect.init(x: SCREEN_WIDTH, y: 0, width: 50, height: 44)
        backButton.frame = CGRect.init(x: -34, y: 3, width: 44, height: 38)
        
        if showBack {
            backButton.left = 0
            backgroudImageView.left = backButton.right
            backgroudImageView.width = SCREEN_WIDTH - backButton.right - 10
        }
    }
    
    // 手势返回时，更改样式
    func changeStyleWhenGestureBack(percent: CGFloat) {
        let alpha: CGFloat = 0.7
        cancelButton.alpha = alpha
        rightButton.alpha = alpha
        searchTextField.alpha = alpha
        // 根据百分比设置输入框的宽度
        if percent >= 0 || percent <= 1 {
            let per_100_width = backgourdImageViewWidth(isEditing: false)
            let per_0_width = backgourdImageViewWidth(isEditing: true)
            backgroudImageView.width = per_0_width + (per_100_width - per_0_width) * percent
        }
    }
    
    // 还原初始样式
    func restoreOriginStyle() {
        cancelButton.alpha = 1
        rightButton.alpha = 1
        searchTextField.alpha = 1
        // 只还原编辑状态
        if isEditing {
            backgroudImageView.width = backgourdImageViewWidth(isEditing: true)
        }
    }
    
    func backgourdImageViewWidth(isEditing: Bool) -> CGFloat {
        if isEditing {
            return SCREEN_WIDTH - self.backButton.right - self.cancelButton.width
        } else {
            return SCREEN_WIDTH - self.backButton.right - 10
        }
    }
    
    @objc func resignSearchField() {
        if self.searchTextField.isFirstResponder {
            self.searchTextField.resignFirstResponder()
        }
    }
    
    //MARK: 回调方法
    @objc func textFieldDidChange() {
        // 只保存无高亮状态下的文字
        let markedRange = searchTextField.markedTextRange
        if markedRange != nil {
            if markedRange!.isEmpty == false {
                return
            }
        }
        if self.searchTextField.text == text { return }
        text = self.searchTextField.text ?? ""
        // 延迟0.25s调用，如果该时间内有多次输入，则只调用一次
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(callBakcDelegateTextChange), object: nil)
        perform(#selector(callBakcDelegateTextChange), with: nil, afterDelay: 0.25)
    }
    
    @objc func callBakcDelegateTextChange() {
        delegate?.searchBar(self, textDidChange: text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidEndEditing(self)
    }
    
    @objc func rightButtonClick() {
        text = ""
    }
    
    @objc func cancelButtonClick() {
        NotificationCenter.default.post(name: NSNotification.Name.init(SEARCH_CANCEL_NOTIFICATION_KEY), object: nil)
    }
    
    @objc func backButtonClick() {
        
    }
    
}
