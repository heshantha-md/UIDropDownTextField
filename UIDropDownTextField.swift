//
//  UIDropDownTextField.swift
//  UIDropDownTextField-Example
//
//  Created by Nadeeshan Jayawardana on 7/9/18.
//  Copyright © 2018 NEngineering. All rights reserved.
//

import UIKit

// MARK: - UIDropDownObject initialization
//       - Use to set objects to the drop down menu

public class UIDropDownObject: NSObject
{
    public var title: String
    public var value: Any
    public var icon: UIImage!
    
    public init(title: String, value: Any, icon: UIImage!) {
        self.title = title
        self.value = value
        self.icon = icon
    }
}

// MARK: - UIDropDownTextFieldDelegate initialization
//       - Use to function the UIDropDownTextField

protocol UIDropDownTextFieldDelegate
{
    func dropDownTextField(_ dropDownTextField: UIDropDownTextField, setOfItemsInDropDownMenu items: [UIDropDownObject]) -> [UIDropDownObject];
    func dropDownTextField(_ dropDownTextField: UIDropDownTextField, didSelectRowAt indexPath: IndexPath)
}

// MARK: - UIDropDownTextField class initialization

class UIDropDownTextField: UITextField, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - UIDropDownTextFieldDelegate object reference
    
    var dropDownDelegate: UIDropDownTextFieldDelegate?
    
    private var _height: CGFloat!
    private var _width: CGFloat!
    private var _dropDownMenuHeight: CGFloat!
    private var _itemList: Dictionary = [String:String]()
    
    private var _resourceList: [UIDropDownObject] = [UIDropDownObject]()
    
    private var _selectedText: String = ""
    private var _selectedValue: Any!
    
    private let terminateButton: UIButton = UIButton()
    private let dropDownView: UIView = UIView()
    private var dropDownTableView: UITableView = UITableView()
    private var dropDownTextField: UITextField = UITextField()
    private var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private let containerView: UIView = UIView()
    
    private var cellLeftIcon: UIImageView!
    private var cellRightIcon: UIImageView!
    private var titleLabel: UILabel!
    
    // MARK: - IBInspectable property declarations
    //       - Use to access property via Attribute Inspector panel in XCode
    
    @IBInspectable var cellHeight: CGFloat = 35.0
    @IBInspectable var maximumItems: Int = 6
    @IBInspectable var padding: CGFloat = 10.0
    @IBInspectable var menuBorder: UIColor = .groupTableViewBackground
    @IBInspectable var menuBackground: UIColor = .white
    @IBInspectable var menuSeparator: UIColor = .groupTableViewBackground
    @IBInspectable var menuText: UIColor = .black
    @IBInspectable var menuFont: UIFont = .systemFont(ofSize: 18)
    @IBInspectable var selectedIcon: UIImage!
    @IBInspectable var buttonBackground: UIColor = .red
    @IBInspectable var buttonColor: UIColor = .white
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder)
    {
        super.init(coder: decoder)
        self.commonInit()
    }
    
    // MARK: - Custom initialization
    //       - Use to configure UI of UIDropDownTextField
    
    private func commonInit()
    {
        _height = self.frame.size.height
        _width = self.frame.size.width
        
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: _height)
        self.addConstraint(heightConstraint)
        self.delegate = self
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        let containerViewTopConstraint = NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let containerViewBottomConstraint = NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let containerViewRightConstraint = NSLayoutConstraint(item: self.containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let containerViewLeftConstraint = NSLayoutConstraint(item: self.containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        self.addConstraints([containerViewTopConstraint,containerViewBottomConstraint,containerViewRightConstraint,containerViewLeftConstraint])
        self.addSubview(self.containerView)
        
        
        self.dropDownTextField.translatesAutoresizingMaskIntoConstraints = false
        let dropDownTextFieldTopConstraint = NSLayoutConstraint(item: self.dropDownTextField, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0)
        let dropDownTextFieldRightConstraint = NSLayoutConstraint(item: self.dropDownTextField, attribute: .right, relatedBy: .equal, toItem: self.containerView, attribute: .right, multiplier: 1, constant: 0)
        let dropDownTextFieldLeftConstraint = NSLayoutConstraint(item: self.dropDownTextField, attribute: .left, relatedBy: .equal, toItem: self.containerView, attribute: .left, multiplier: 1, constant: 0)
        let dropDownTextFieldHeightConstraint = NSLayoutConstraint(item: self.dropDownTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: _height)
        self.containerView.addConstraints([dropDownTextFieldTopConstraint,dropDownTextFieldRightConstraint,dropDownTextFieldLeftConstraint,dropDownTextFieldHeightConstraint])
        self.dropDownTextField.delegate = self
        self.containerView.addSubview(self.dropDownTextField)
        
        self.configureSelfTextFieldAttributesWithNewTextField()
    }
    
    // MARK: - TextField initialization
    //       - Use to assign super textField attributes to sub textField
    
    private func configureSelfTextFieldAttributesWithNewTextField()
    {
        self.dropDownTextField.textColor = self.textColor
        self.dropDownTextField.font = self.font
        self.dropDownTextField.adjustsFontForContentSizeCategory = self.adjustsFontForContentSizeCategory
        self.dropDownTextField.textAlignment = self.textAlignment
        self.dropDownTextField.placeholder = self.placeholder
        self.dropDownTextField.background = self.background
        self.dropDownTextField.disabledBackground = self.disabledBackground
        self.dropDownTextField.borderStyle = self.borderStyle
        self.dropDownTextField.clearButtonMode = self.clearButtonMode
        self.dropDownTextField.clearsOnBeginEditing = self.clearsOnBeginEditing
        self.dropDownTextField.minimumFontSize = self.minimumFontSize
        self.dropDownTextField.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth
        self.dropDownTextField.textInputView.contentMode = self.textInputView.contentMode
        self.dropDownTextField.autocapitalizationType = self.autocapitalizationType
        self.dropDownTextField.autocorrectionType = self.autocorrectionType
        self.dropDownTextField.smartDashesType = self.smartDashesType
        self.dropDownTextField.smartInsertDeleteType = self.smartInsertDeleteType
        self.dropDownTextField.smartQuotesType = self.smartQuotesType
        self.dropDownTextField.spellCheckingType = self.spellCheckingType
        self.dropDownTextField.isSecureTextEntry = self.isSecureTextEntry
        self.dropDownTextField.contentVerticalAlignment = self.contentVerticalAlignment
        self.dropDownTextField.contentHorizontalAlignment = self.contentHorizontalAlignment
        self.dropDownTextField.isSelected = self.isSelected
        self.dropDownTextField.isEnabled = self.isEnabled
        self.dropDownTextField.isHighlighted = self.isHighlighted
        self.dropDownTextField.contentMode = self.contentMode
        self.dropDownTextField.semanticContentAttribute = self.semanticContentAttribute
        self.dropDownTextField.tag = self.tag
        self.dropDownTextField.isUserInteractionEnabled = self.isUserInteractionEnabled
        self.dropDownTextField.isMultipleTouchEnabled = self.isMultipleTouchEnabled
        self.dropDownTextField.alpha = self.alpha
        self.dropDownTextField.backgroundColor = self.backgroundColor
        self.dropDownTextField.tintColor = self.tintColor
        self.dropDownTextField.isOpaque = self.isOpaque
        
        self.dropDownTextField.layer.borderWidth = self.layer.borderWidth
        self.dropDownTextField.layer.masksToBounds = self.layer.masksToBounds
        self.dropDownTextField.layer.borderColor = self.layer.borderColor
        self.dropDownTextField.layer.cornerRadius = self.layer.cornerRadius
        
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.borderStyle = .none
        self.disabledBackground = nil
        self.background = nil
        self.placeholder = ""
        self.textColor = .clear
        self.autoresizesSubviews = true
        self.tintColor = .clear
        self.backgroundColor = .clear
    }
    
    // MARK: - Drop down terminate button initialization
    
    private func drowTerminateButton()
    {
        if (!self.dropDownTextField.subviews.contains(terminateButton))
        {
            self.terminateButton.translatesAutoresizingMaskIntoConstraints = false
            let terminateButtonRightConstraint = NSLayoutConstraint(item: self.terminateButton, attribute: .right, relatedBy: .equal, toItem: self.dropDownTextField, attribute: .right, multiplier: 1, constant: -10)
            let terminateButtonHeightConstraint = NSLayoutConstraint(item: self.terminateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
            let terminateButtonWidthConstraint = NSLayoutConstraint(item: self.terminateButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
            let terminateButtonVerticalConstraint = NSLayoutConstraint(item: self.terminateButton, attribute: .centerY, relatedBy: .equal, toItem: self.dropDownTextField, attribute: .centerY, multiplier: 1, constant: 0)
            
            self.terminateButton.backgroundColor = buttonBackground
            self.terminateButton.layer.cornerRadius = 8
            self.terminateButton.clipsToBounds = true
            self.terminateButton.setTitle("X", for: .normal)
            self.terminateButton.setTitleColor(buttonColor, for: .normal)
            self.terminateButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .black)
            self.terminateButton.addTarget(self, action: #selector(terminateDropDownView), for: .touchUpInside)
            self.dropDownTextField.addSubview(self.terminateButton)
            self.dropDownTextField.addConstraints([terminateButtonRightConstraint, terminateButtonHeightConstraint, terminateButtonWidthConstraint, terminateButtonVerticalConstraint])
        }
    }
    
    // MARK: - Config drop down menu height according to cell height
    
    private func configDropDownMenuHeight()
    {
        _dropDownMenuHeight = (self.cellHeight * CGFloat(self.maximumItems))
        if (_resourceList.count != 0 && _resourceList.count < self.maximumItems)
        {
            _dropDownMenuHeight = (self.cellHeight * CGFloat(_resourceList.count))
        }
    }
    
    // MARK: - Drop down super view initialization
    
    private func drowDropDownView()
    {
        self.configItemListForDropDownMenu()
        self.configDropDownMenuHeight()
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: (_height + (self.padding + _dropDownMenuHeight)))
        self.heightConstraint.constant = (_height + (self.padding + _dropDownMenuHeight))
        self.layoutIfNeeded()
        
        self.dropDownView.translatesAutoresizingMaskIntoConstraints = false
        let dropDownViewTopConstraint = NSLayoutConstraint(item: self.dropDownView, attribute: .top, relatedBy: .equal, toItem: self.dropDownTextField, attribute: .bottom, multiplier: 1, constant: self.padding)
        let dropDownViewRightConstraint = NSLayoutConstraint(item: self.dropDownView, attribute: .right, relatedBy: .equal, toItem: self.containerView, attribute: .right, multiplier: 1, constant: 0)
        let dropDownViewLeftConstraint = NSLayoutConstraint(item: self.dropDownView, attribute: .left, relatedBy: .equal, toItem: self.containerView, attribute: .left, multiplier: 1, constant: 0)
        let dropDownViewBottomConstraint = NSLayoutConstraint(item: self.dropDownView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.dropDownView.backgroundColor = menuSeparator
        self.dropDownView.layer.borderWidth = 1
        self.dropDownView.layer.borderColor = menuBorder.cgColor
        self.dropDownView.layer.cornerRadius = 10
        self.dropDownView.clipsToBounds = true
        self.dropDownView.isUserInteractionEnabled = true
        self.containerView.addSubview(self.dropDownView)
        self.containerView.addConstraints([dropDownViewTopConstraint, dropDownViewRightConstraint, dropDownViewLeftConstraint, dropDownViewBottomConstraint])
        
        self.dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        let dropDownTableViewTopConstraint = NSLayoutConstraint(item: self.dropDownTableView, attribute: .top, relatedBy: .equal, toItem: self.dropDownView, attribute: .top, multiplier: 1, constant: 0)
        let dropDownTableViewRightConstraint = NSLayoutConstraint(item: self.dropDownTableView, attribute: .right, relatedBy: .equal, toItem: self.dropDownView, attribute: .right, multiplier: 1, constant: 0)
        let dropDownTableViewLeftConstraint = NSLayoutConstraint(item: self.dropDownTableView, attribute: .left, relatedBy: .equal, toItem: self.dropDownView, attribute: .left, multiplier: 1, constant: 0)
        let dropDownTableViewBottomConstraint = NSLayoutConstraint(item: self.dropDownTableView, attribute: .bottom, relatedBy: .equal, toItem: self.dropDownView, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "dropDownCell")
        self.dropDownTableView.isScrollEnabled = true
        self.dropDownTableView.delegate = self
        self.dropDownTableView.dataSource = self
        self.dropDownTableView.isUserInteractionEnabled = true
        self.dropDownTableView.autoresizesSubviews = true
        self.dropDownTableView.clipsToBounds = true
        self.dropDownTableView.showsVerticalScrollIndicator = true
        self.dropDownTableView.separatorStyle = .none
        self.dropDownTableView.backgroundColor = .clear
        self.dropDownTableView.bounces = false
        self.dropDownView.addSubview(self.dropDownTableView)
        self.dropDownView.addConstraints([dropDownTableViewTopConstraint, dropDownTableViewRightConstraint, dropDownTableViewLeftConstraint, dropDownTableViewBottomConstraint])
    }
    
    // MARK: - Drop down cell view initialization
    
    private func configCellLayerView(_ view: UIView)
    {
        cellLeftIcon = UIImageView()
        cellLeftIcon.backgroundColor = .green
        cellLeftIcon.translatesAutoresizingMaskIntoConstraints = false
        let cellLeftIconLeftConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10)
        let cellLeftIconHeightConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellLeftIconWidthConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellLeftIconVerticalConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        view.addSubview(cellLeftIcon)
        view.addConstraints([cellLeftIconLeftConstraint, cellLeftIconHeightConstraint, cellLeftIconWidthConstraint, cellLeftIconVerticalConstraint])
        
        cellRightIcon = UIImageView()
        cellRightIcon.backgroundColor = .green
        cellRightIcon.translatesAutoresizingMaskIntoConstraints = false
        let cellRightIconRightConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
        let cellRightIconHeightConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellRightIconWidthConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellRightIconVerticalConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        view.addSubview(cellRightIcon)
        view.addConstraints([cellRightIconRightConstraint, cellRightIconHeightConstraint, cellRightIconWidthConstraint, cellRightIconVerticalConstraint])
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .orange
        titleLabel.numberOfLines = 5
        titleLabel.textColor = menuText
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let titleLabelRightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: cellRightIcon, attribute: .left, multiplier: 1, constant: -5)
        let titleLabelLeftConstraint = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: cellLeftIcon, attribute: .right, multiplier: 1, constant: 5)
        let titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addSubview(titleLabel)
        view.addConstraints([titleLabelTopConstraint, titleLabelRightConstraint, titleLabelLeftConstraint, titleLabelBottomConstraint])
    }
    
    // MARK: - Drop down item initialization
    
    private func configItemListForDropDownMenu()
    {
        _resourceList = (dropDownDelegate?.dropDownTextField(self, setOfItemsInDropDownMenu: [UIDropDownObject]()))!
    }
    
    // Mark - UITextFieldDelegate delegate and datasource functions
    
    @objc func textFieldTouchDown(_ sender: UITextField)
    {
        self.drowDropDownView()
        self.drowTerminateButton()
    }
    
    @objc func terminateDropDownView()
    {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: _height)
        self.heightConstraint.constant = _height
        self.layoutIfNeeded()
        
        self.dropDownView.removeFromSuperview()
        self.terminateButton.removeFromSuperview()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.textFieldTouchDown(textField)
        return false;
    }
    
    // Mark - UITableView delegate and datasource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _resourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell: UIDropDownTableViewCell = UIDropDownTableViewCell(style: .default, reuseIdentifier: "myIdentifier")
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.cellLayerView.backgroundColor = menuBackground
        cell.titleLabel.textColor = menuText
        let tDropDownObject: UIDropDownObject = _resourceList[indexPath.row]
        cell.titleLabel.font = menuFont
        cell.titleLabel.text = tDropDownObject.title
        cell.cellLeftIcon.image = tDropDownObject.icon
        cell.cellLeftIconWidthConstraint.constant = (tDropDownObject.icon == nil) ? 0 : 30
        cell.cellRightIconWidthConstraint.constant = (selectedIcon == nil) ? 0 : 30
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell: UIDropDownTableViewCell = tableView.cellForRow(at: indexPath)
            as! UIDropDownTableViewCell
        cell.cellRightIcon.image = selectedIcon
        
        let tDropDownObject: UIDropDownObject = _resourceList[indexPath.row]
        _selectedText = tDropDownObject.title
        _selectedValue = tDropDownObject.value
        
        self.dropDownTextField.text = _selectedText
        dropDownDelegate?.dropDownTextField(self, didSelectRowAt: indexPath)
        self.terminateDropDownView()
    }
    
    // Mark - Public methods for object refferance
    
    public func layoutAsNeeded()
    {
        self.configureSelfTextFieldAttributesWithNewTextField()
    }
    
    public func text() -> String
    {
        return _selectedText
    }
    
    public func value() -> Any
    {
        return _selectedValue
    }
}

// MARK: - UIDropDownTableViewCell initialization
//       - Using in Drop Down Menu

fileprivate class UIDropDownTableViewCell: UITableViewCell {
    
    fileprivate let cellLayerView: UIView = UIView()
    fileprivate var cellLeftIcon: UIImageView!
    fileprivate var cellRightIcon: UIImageView!
    fileprivate var titleLabel: UILabel!
    
    fileprivate var cellLeftIconWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    fileprivate var cellRightIconWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellLayerView.translatesAutoresizingMaskIntoConstraints = false
        let cellLayerViewTopConstraint = NSLayoutConstraint(item: cellLayerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let cellLayerViewRightConstraint = NSLayoutConstraint(item: cellLayerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let cellLayerViewLeftConstraint = NSLayoutConstraint(item: cellLayerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let cellLayerViewBottomConstraint = NSLayoutConstraint(item: cellLayerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1)
        
        self.addSubview(cellLayerView)
        self.addConstraints([cellLayerViewTopConstraint, cellLayerViewRightConstraint, cellLayerViewLeftConstraint, cellLayerViewBottomConstraint])
        
        cellLeftIcon = UIImageView()
        cellLeftIcon.contentMode = .scaleAspectFit
        cellLeftIcon.translatesAutoresizingMaskIntoConstraints = false
        let cellLeftIconLeftConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .left, relatedBy: .equal, toItem: cellLayerView, attribute: .left, multiplier: 1, constant: 10)
        let cellLeftIconHeightConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        cellLeftIconWidthConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellLeftIconVerticalConstraint = NSLayoutConstraint(item: cellLeftIcon, attribute: .centerY, relatedBy: .equal, toItem: cellLayerView, attribute: .centerY, multiplier: 1, constant: 0)
        
        cellLayerView.addSubview(cellLeftIcon)
        cellLayerView.addConstraints([cellLeftIconLeftConstraint, cellLeftIconHeightConstraint, cellLeftIconWidthConstraint, cellLeftIconVerticalConstraint])
        
        cellRightIcon = UIImageView()
        cellRightIcon.contentMode = .scaleAspectFit
        cellRightIcon.translatesAutoresizingMaskIntoConstraints = false
        let cellRightIconRightConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .right, relatedBy: .equal, toItem: cellLayerView, attribute: .right, multiplier: 1, constant: -10)
        let cellRightIconHeightConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        cellRightIconWidthConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let cellRightIconVerticalConstraint = NSLayoutConstraint(item: cellRightIcon, attribute: .centerY, relatedBy: .equal, toItem: cellLayerView, attribute: .centerY, multiplier: 1, constant: 0)
        
        cellLayerView.addSubview(cellRightIcon)
        cellLayerView.addConstraints([cellRightIconRightConstraint, cellRightIconHeightConstraint, cellRightIconWidthConstraint, cellRightIconVerticalConstraint])
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 5
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: cellLayerView, attribute: .top, multiplier: 1, constant: 0)
        let titleLabelRightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: cellRightIcon, attribute: .left, multiplier: 1, constant: -5)
        let titleLabelLeftConstraint = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: cellLeftIcon, attribute: .right, multiplier: 1, constant: 10)
        let titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: cellLayerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        cellLayerView.addSubview(titleLabel)
        cellLayerView.addConstraints([titleLabelTopConstraint, titleLabelRightConstraint, titleLabelLeftConstraint, titleLabelBottomConstraint])
    }
}
