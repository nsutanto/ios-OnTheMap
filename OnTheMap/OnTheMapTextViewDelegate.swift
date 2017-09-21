//
//  OnTheMapTextViewDelegate.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/18/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    static let sharedInstance : OnTheMapTextFieldDelegate = OnTheMapTextFieldDelegate()
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Insert Code after Text Field is Done editing
        textField.resignFirstResponder()
    }
}
