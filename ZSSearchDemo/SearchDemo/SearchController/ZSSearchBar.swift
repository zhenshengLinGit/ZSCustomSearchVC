//
//  ZSSearchBar.swift
//  SearchDemo
//
//  Created by 80263956 on 2019/7/26.
//  Copyright © 2019 80263956. All rights reserved.
//

import UIKit

let SEARCH_CANCEL_NOTIFICATION_KEY = "SEARCH_CANCEL_NOTIFICATION_KEY"

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
    
    var placeholder: String? {
        didSet {
            self.searchTextField.placeholder = placeholder
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            if isEditing {
                // 添加动画
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchTextField.x = 10
                    self.rightButton.x = kScreenWidth - 38 - 40
                    self.backgroudImageView.width = kScreenWidth - 20 - 40
                    self.cancelButton.x = kScreenWidth - 40
                }) { (finished) in
                    self.searchTextField.width = kScreenWidth - 20 - 38 - 40
                }
                searchTextField.canTouch = true
                searchTextField.becomeFirstResponder()
            } else {
                text = nil
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchTextField.x = kScreenWidth * 0.5 - 40
                    self.rightButton.x = kScreenWidth - 38
                    self.backgroudImageView.width = kScreenWidth - 20
                    self.cancelButton.x = kScreenWidth
                }) { (finished) in
                    self.searchTextField.width = kScreenWidth * 0.5
                }
                searchTextField.canTouch = false
                searchTextField.resignFirstResponder()
            }
        }
    }
    
    @objc dynamic var text: String? {
        didSet {
            if text != self.searchTextField.text {
                self.searchTextField.text = text ?? ""
            }
            rightButton.isHidden = (text?.count == 0 || text == nil) ? true : false
        }
    }
    
    weak var delegate: ZSSearchBarDelegate?
    
    lazy var backgroudImageView: UIImageView = {
        var _backgroudImageView = UIImageView.init(image: UIImage.init(named: "widget_searchbar_textfield"))
        _backgroudImageView.frame = CGRect.init(x: 10, y: 8, width: kScreenWidth - 20, height: 44 - 16)
        return _backgroudImageView
    }()
    
    private lazy var searchTextField: ZSSearchTextField = {
        var _searchTextField = ZSSearchTextField.init(frame: CGRect.init(x: kScreenWidth * 0.5 - 40, y: 0, width: kScreenWidth * 0.5, height: 44))
        _searchTextField.canTouch = false
        _searchTextField.placeholder = "搜索"
        var searchIcon = UIImageView.init(image: UIImage.init(named: "SearchContactsBarIcon"))
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 14)
        _searchTextField.leftView = searchIcon
        _searchTextField.leftViewMode = .always
        _searchTextField.font = UIFont.systemFont(ofSize: 16.0)
        _searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        _searchTextField.delegate = self
        return _searchTextField
    }()
    
    lazy var rightButton: UIButton = {
        var _rightButton = UIButton.init(type: UIButtonType.custom)
        _rightButton.frame = CGRect.init(x: kScreenWidth - 38, y: 8, width: 28, height: 28)
        _rightButton.setImage(UIImage.init(named: "card_delete"), for: UIControlState.normal)
        _rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        _rightButton.isHidden = true
        return _rightButton
    }()
    
    lazy var cancelButton: UIButton = {
        var _cancelButton = UIButton.init(type: UIButtonType.custom)
        _cancelButton.frame = CGRect.init(x: kScreenWidth, y: 0, width: 40, height: 44)
        _cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _cancelButton.setTitle("取消 ", for: UIControlState.normal)
        _cancelButton.setTitleColor(ZSColor(85, 183, 55, 1.0), for: UIControlState.normal)
        _cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControlEvents.touchUpInside)
        return _cancelButton
    }()
    
    //  ❗️❗️❗️该方法是在协议中定义的，子类必须如果没有隐式继承该方法，就必须显示地写，而且加上 required 关键字
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        let vFrame = CGRect.init(x: 0, y: 0, width:kScreenWidth , height: 44)
        super.init(frame: vFrame)
        self.backgroundColor = ZSColor(243, 243, 243, 1.0)
        self.addSubview(backgroudImageView)
        self.addSubview(searchTextField)
        self.addSubview(rightButton)
        self.addSubview(cancelButton)
    }
    
    func resignSearchField() {
        self.searchTextField.resignFirstResponder()
    }
    
    // 回调方法
    @objc func textFieldDidChange() {
        text = self.searchTextField.text
        delegate?.searchBar(self, textDidChange: self.searchTextField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidEndEditing(self)
    }
    
    @objc func rightButtonClick() {
        text = nil
    }
    
    @objc func cancelButtonClick() {
        NotificationCenter.default.post(name: NSNotification.Name.init(SEARCH_CANCEL_NOTIFICATION_KEY), object: nil)
    }
}
