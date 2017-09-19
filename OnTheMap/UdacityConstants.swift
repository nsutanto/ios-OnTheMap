//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/10/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        static let AuthorizationURL = "https://www.udacity.com/api/session"
    }
    
    // MARK: Parameter Keys
    struct UdacityParameterKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct UdacityAccountKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
    }
    
    struct SessionKeys {
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
    }
}
