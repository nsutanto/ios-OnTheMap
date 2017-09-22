//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/14/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var studentInformationsLocal = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GetStudentInformations()
    }
    
    private func updateTable() {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    func GetStudentInformations() {
        
        let parameters = [
            ParseClient.MultipleStudentParameterKeys.Limit: "100",
        ]
        
        ParseClient.sharedInstance().getStudentInformations(parameters: parameters as [String : AnyObject], completionHandlerLocations: { (studentInformations, error) in
            if let studentInformations = studentInformations {
                self.studentInformationsLocal = studentInformations
                self.updateTable()
            } else {
                print(error ?? "empty error")
            }
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let studentInformation = studentInformationsLocal[(indexPath as NSIndexPath).row]
        if (studentInformation.MediaURL != "") {
            let app = UIApplication.shared
            app.open(URL(string: studentInformation.MediaURL)!, options: [:], completionHandler: { (isSuccess) in
                
                if (isSuccess == false) {
                    self.performAlert()
                }
            })
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Link URL is not valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationsLocal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentInformation = studentInformationsLocal[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformationCell", for: indexPath)
        cell.textLabel!.text = studentInformation.FirstName + " " + studentInformation.LastName
        cell.detailTextLabel!.text = studentInformation.MediaURL
        
        return cell
    }
    
    func performAlert() {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Alert", message: "Link URL is not valid. It might missing http or https.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
