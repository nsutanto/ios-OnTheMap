//
//  MainTabViewController.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/10/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func performLogout(_ sender: Any) {
        
        UdacityClient.sharedInstance().performUdacityLogout(completionHandlerLogout: { (error) in
            self.updateUIAfterLogout(error: error)
        })
    }
    
    @IBAction func performRefresh(_ sender: Any) {
        if (selectedIndex == 0) {
            let vc = selectedViewController as! MapViewController
            vc.getStudentInformations("updatedAt")
        }
        else {
            let vc = selectedViewController as! TableViewController
            vc.getStudentInformations()
        }
    }
    
    @IBAction func performAddStudent(_ sender: Any) {
    
        let studentInformations = ParseClient.sharedInstance().studentInformations!
        addStudentInformation(studentInformations)
    }
    
    private func updateUIAfterLogout(error: NSError?) {
        
        performUIUpdatesOnMain {
     
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func addStudentInformation(_ studentInformations: [StudentInformation]) {
        var isExist: Bool = false
        let currentUserUniqueKey = UdacityClient.sharedInstance().AccountKey
        var currentStudent: StudentInformation?
        
        for studentInformation in studentInformations {
            if (studentInformation.UniqueKey == currentUserUniqueKey) {
                currentStudent = studentInformation
                isExist = true
                break
            }
        }
        
        if (isExist) {
            // create the alert
            let alert = UIAlertController(title: "Warning", message: "User \(currentStudent!.FirstName) \(currentStudent!.LastName) has already posted a student location. Would you like to overwrite their location?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: {_ in
                self.presentUpdateStudentInfoView()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else {
            presentUpdateStudentInfoView()
        }
    }
    
    private func presentUpdateStudentInfoView() {
        let updateLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "UpdateNavigationController")
        self.present(updateLocationVC, animated: true, completion: nil)
    }

}
