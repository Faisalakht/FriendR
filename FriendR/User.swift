//
//  User.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-03.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation


class User {
    
    
    
    
    private var _email = "";
    private var _id = "";
    private var _long = 0;
    private var _lang = 0;
    
    init (id: String, email: String)
    {
        _id = id;
        _email = email;
        
        
    }
    
    var email: String {
        
        return _email;
        
    }
    
    var id: String {
        
        return _id;
    }
    
    var long: Int {
        
        return _long;
    }
    
    var lang: Int {
        
        return _lang;
    }

    
    
    
    
}
