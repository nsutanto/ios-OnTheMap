//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/9/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import UIKit

class UpdateLocationViewController: UIViewController {

    @IBOutlet weak var textLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLocation.delegate = OnTheMapTextFieldDelegate.sharedInstance
    }
    
    @IBAction func performCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func performFindOnMap(_ sender: Any) {
        if (textLocation.text! == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter location.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "UpdateURLViewController") as! UpdateURLViewController
        vc.location = textLocation.text!
        
        // Nick : Need to do this for navigation controller. otherwise it will not display the navigation bar
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

