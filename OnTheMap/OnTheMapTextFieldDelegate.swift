//
//  OnTheMapTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/16/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import UIKit

class OnTheMapTextFieldDelegate : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
