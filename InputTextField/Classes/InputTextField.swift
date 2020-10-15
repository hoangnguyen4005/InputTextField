//
//  InputTextField.swift
//  InputTextField
//
//  Created by Chi Hoang on 15/10/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit


enum ColorTheme {
    static let blue = #colorLiteral(red: 0, green: 0.3607843137, blue: 0.5176470588, alpha: 1)
    static let tertairy = #colorLiteral(red: 0.3882352941, green: 0.4705882353, blue: 0.5490196078, alpha: 1)
    static let grey = #colorLiteral(red: 0.737254902, green: 0.7450980392, blue: 0.7529411765, alpha: 1)
    static let red = #colorLiteral(red: 0.937254902, green: 0.2509803922, blue: 0.2117647059, alpha: 1)
    static let darkBlue = #colorLiteral(red: 0, green: 0.4588235294, blue: 0.6901960784, alpha: 1)
    static let deepBlue = #colorLiteral(red: 0, green: 0.1333333333, blue: 0.2666666667, alpha: 1)
}

public protocol InputTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidBegin(_ textField: InputTextField)
    func textFieldDidChange(_ textField: InputTextField)
}

public class InputTextField: UIView {
    @IBOutlet public weak var coverInputTextField: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    var offsetTextField: OffSetTextField = OffSetTextField()
    var placeHolderLabel: UILabel = UILabel()
    let topPadingAnimation: CGFloat = 10.0
    var isRunningAnimation: Bool = false

    var verticalPadingTextFiledAndIcon: CGFloat = 14.0
    public weak var delegate: InputTextFieldDelegate?

    // swiftlint:disable implicit_getter
    public var textField: UITextField {
        get {
            return self.offsetTextField
        }
    }

    public var text: String? {
        get {
            return offsetTextField.text
        }
        set(value) {
            self.offsetTextField.text = value
        }
    }

    public var disableEditInputField: Bool {
        get {
            return !self.offsetTextField.isUserInteractionEnabled
        }
        set(value) {
            self.offsetTextField.isUserInteractionEnabled = !value
        }
    }

    public var inputAccessoryTextField: UIView? {
        get {
            return self.offsetTextField.inputAccessoryView
        }
        set(value) {
            self.offsetTextField.inputAccessoryView = value
        }
    }

    public var inputTextField: UIView? {
        get {
            return self.offsetTextField.inputView
        }
        set(value) {
            self.offsetTextField.inputView = value
        }
    }

    public var placeHolder: String? {
        get {
            return self.placeHolderLabel.text
        }
        set(value) {
            self.placeHolderLabel.text = value
        }
    }

    public var messageError: String? {
        get {
            return self.errorLabel.text
        }
        set(value) {
            self.errorLabel.text = value
        }
    }

    public var rightIcon: UIImage? = nil {
        didSet {
            self.rightImageView.image = rightIcon?.withRenderingMode(.alwaysTemplate)
            self.rightImageView.tintColor = ColorTheme.blue
        }
    }

    public var rightIconTapAction: (() -> Void)?

    public var leftIcon: UIImage? = nil {
        didSet {
            self.leftImageView.image = leftIcon?.withRenderingMode(.alwaysTemplate)
            self.leftImageView.tintColor = ColorTheme.blue
        }
    }

    public var leftIconTapAction: (() -> Void)?

    public var keyboardType: UIKeyboardType {
        get {
            return self.offsetTextField.keyboardType
        }
        set(value) {
            self.offsetTextField.keyboardType = value
        }
    }

    public enum State {
        case none
        case editing
        case error
        case completed
    }

    public var stateControl: State = .none {
        willSet(newState) {
            switch newState {
            case .none:
                self.placeHolderLabel.textColor = ColorTheme.tertairy
                self.coverInputTextField.layer.borderColor = ColorTheme.grey.cgColor
                self.errorLabel.isHidden = true
            case .editing:
                self.placeHolderLabel.textColor = ColorTheme.tertairy
                self.coverInputTextField.layer.borderColor = ColorTheme.darkBlue.cgColor
                self.errorLabel.isHidden = true
            case .error:
                self.placeHolderLabel.textColor = ColorTheme.red
                self.coverInputTextField.layer.borderColor = ColorTheme.red.cgColor
                self.errorLabel.isHidden = false
            case .completed:
                self.placeHolderLabel.textColor = ColorTheme.tertairy
                self.coverInputTextField.layer.borderColor = ColorTheme.grey.cgColor
                self.errorLabel.isHidden = true
            }
        }
    }

    public enum Style {
        case leading
        case trailing
        case both
        case none
    }

    public var style: Style = Style.leading {
        didSet {
            self.coverInputTextField.addSubview( self.offsetTextField)
            self.coverInputTextField.addSubview(self.placeHolderLabel)
            let widthIconImageView: CGFloat = self.leftImageView.frame.width
            var leftTextFieldPading: CGFloat = 0.0
            var rightTextFieldPaing: CGFloat = 0.0
            switch style {
            case .leading:
                leftTextFieldPading = verticalPadingTextFiledAndIcon
                rightTextFieldPaing =  widthIconImageView + verticalPadingTextFiledAndIcon * 2.0
            case .trailing:
                leftTextFieldPading = widthIconImageView + verticalPadingTextFiledAndIcon * 2.0
                rightTextFieldPaing = verticalPadingTextFiledAndIcon
            case .both:
                leftTextFieldPading = verticalPadingTextFiledAndIcon
                rightTextFieldPaing = verticalPadingTextFiledAndIcon
            case .none:
                leftTextFieldPading = widthIconImageView + verticalPadingTextFiledAndIcon * 2.0
                rightTextFieldPaing = widthIconImageView + verticalPadingTextFiledAndIcon * 2.0
            }
            self.offsetTextField.anchor(top: self.coverInputTextField.topAnchor,
                                  leading: self.coverInputTextField.leadingAnchor,
                                  bottom: self.coverInputTextField.bottomAnchor,
                                  trailing: self.coverInputTextField.trailingAnchor,
                                  padding: UIEdgeInsets(top: topPadingAnimation,
                                                        left: leftTextFieldPading,
                                                        bottom: topPadingAnimation,
                                                        right: rightTextFieldPaing),
                                  size: .zero)
            self.placeHolderLabel.anchor(top: self.offsetTextField.topAnchor,
                                  leading: self.offsetTextField.leadingAnchor,
                                  bottom: self.offsetTextField.bottomAnchor,
                                  trailing: self.offsetTextField.trailingAnchor)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    /// :nodoc:
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.clear
        _ = fromNib(nibName: String(describing: InputTextField.self), isInherited: true)

        self.errorLabel.textColor = ColorTheme.red
        self.errorLabel.font = UIFont.systemFont(ofSize: 12.0)

        self.coverInputTextField.backgroundColor = .clear
        self.coverInputTextField.layer.cornerRadius = 4.00
        self.coverInputTextField.layer.borderWidth = 0.5

        self.offsetTextField.textAlignment = .left
        self.offsetTextField.font = UIFont.systemFont(ofSize: 14.0)
        self.offsetTextField.textColor = ColorTheme.deepBlue
        self.offsetTextField.addTarget(self, action: #selector(self.editingChanged(_:)),
                                 for: UIControl.Event.editingChanged)
        self.offsetTextField.addTarget(self, action: #selector(self.editingDidBegin(_:)),
                                 for: UIControl.Event.editingDidBegin)

        self.placeHolderLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.stateControl = .none

        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightIconTapped))
        rightImageView.isUserInteractionEnabled = true
        rightImageView.addGestureRecognizer(rightTap)

        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftIconTapped))
        leftImageView.isUserInteractionEnabled = true
        leftImageView.addGestureRecognizer(leftTap)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.offsetTextField.delegate = delegate
    }

    @objc func rightIconTapped() { rightIconTapAction?() }

    @objc func leftIconTapped() { leftIconTapAction?()}

    public func getTextFieldRightView() -> UIView { return rightImageView }

    public func getTextFieldLeftView() -> UIView { return leftImageView}

    @objc func editingDidBegin(_ textField: UITextField) {
        self.delegate?.textFieldDidBegin(self)
    }

    @objc func editingChanged(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            self.revertAnimation()
            self.stateControl = .none
        } else {
            self.typingAnimation()
            self.stateControl = .editing
        }
        self.text = self.offsetTextField.text
        self.delegate?.textFieldDidChange(self)
    }

    public func resetInputTextField() {
        self.text = nil
        revertAnimation()
        stateControl = .none
    }

    public func typingAnimation() {
        guard !isRunningAnimation else { return }
        self.moveTextFiledAndHintLabel(isRunningAnimation: true)
    }

    public func revertAnimation() {
        guard isRunningAnimation else { return }
        self.moveTextFiledAndHintLabel(isRunningAnimation: false)
    }

    private func moveTextFiledAndHintLabel(isRunningAnimation: Bool) {
        let placeHolderLabelBuffer = isRunningAnimation ? -self.topPadingAnimation : self.topPadingAnimation
        let textFieldBuffer = isRunningAnimation ? self.topPadingAnimation : -self.topPadingAnimation
        UIView.animate(withDuration: 0.12) {
            self.placeHolderLabel.frame = CGRect(origin: CGPoint(x: self.placeHolderLabel.frame.origin.x,
                                                                 y: self.placeHolderLabel.frame.origin.y
                                                                    + placeHolderLabelBuffer),
                                                 size: self.placeHolderLabel.frame.size)

            self.offsetTextField.frame = CGRect(origin: CGPoint(x: self.offsetTextField.frame.origin.x,
                                                                   y: self.offsetTextField.frame.origin.y
                                                                    + textFieldBuffer),
                                                   size: self.offsetTextField.frame.size)
            self.isRunningAnimation = isRunningAnimation
        }
    }

    public func animationExpandText() {
        self.placeHolderLabel.isHidden = true
        self.offsetTextField.isHidden = true
        self.stateControl = .none
        self.revertAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.placeHolderLabel.isHidden = false
            self.offsetTextField.isHidden = false
            self.typingAnimation()
        }
    }
}

class OffSetTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -6)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
