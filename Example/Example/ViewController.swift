//
//  ViewController.swift
//  Example
//
//  Created by Chi Hoang on 15/10/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit
import InputTextField

class ViewController: UIViewController, InputTextFieldDelegate {
    var bothInputTextField: InputTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testInputTextField()
    }

    func testInputTextField() {
        bothInputTextField = InputTextField()
        bothInputTextField.style = .both
        bothInputTextField.placeHolder = "Please input here :)"
        self.view.addSubview(bothInputTextField)
        
        bothInputTextField.anchor(top: self.view.topAnchor,
                                  leading: self.view.leadingAnchor,
                                  bottom: nil,
                                  trailing: self.view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 200,
                                                        left: 20,
                                                        bottom: 0,
                                                        right: 20),
                                  size: CGSize(width: 0, height: 80))
        self.bothInputTextField.delegate = self
    }
    
    
    func textFieldDidChange(_ textField: InputTextField) {
        if let text = textField.text, text.count > 6 {
            textField.stateControl = .error
        }
    }

    func textFieldDidBegin(_ textField: InputTextField) {}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
