//
//  SharedData.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/24/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import Foundation

class SharedData{
    
    static let sharedInstance = SharedData()
    var studentInformations: [StudentInformation] = []
    var currentUser: StudentInformation?
    
    private init() {}
}
