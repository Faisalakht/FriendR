//
//  AuthSet.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-04.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias L_handler = (_ msg: String?) -> Void;

struct error_msgs {
    
    static let WRONG_PASSWORD = " Wrong Password, Please enter the correct password";
    static let USER_NOTFOUND = "User not found, please sign up";
    static let WEAK_PASSWORD = "Password needs to be 6 characters long";
    static let EMAIL_INUSE = "Email is already in user!";
    static let INVALID_EMAIL = "Email is not valid, Please enter a valid email";
    static let DEFAULT = "Cannot connect to the server";
    
    
    
}

class AuthSet {
    
    private static let _instance = AuthSet();
    
    static var Instance: AuthSet {
        
        return _instance;
    }
    
    func login(email: String,password: String,l_handler: L_handler?)
    {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            (user,error) in
                
                if error != nil {
                    
                    self.handle_errors(err: error as! NSError, l_handler: l_handler);
                    
                }
                    
                    
                else    {
                    
                    l_handler?(nil);
                    
                    }
                
                
            
            
        });
        
        
    }
    
    
    func register(email: String,password: String, l_handler: L_handler?)
    {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            
           (user,error) in
            
            if  error != nil {
                
                
                
                self.handle_errors(err: error as! NSError, l_handler: l_handler);
                
            }
            
            else{
                if user?.uid != nil {
                    
                    l_handler?(nil);
                    
                                
                }
                
            }
            
            
        });
        
        
        
    }

    
    
    
    func loggedin () -> Bool {
        
        
        if FIRAuth.auth()?.currentUser != nil {
            
            
            return true;
            
        }
        else{
            
            
            return false;
        }
        
        
    }
    
    func logout() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            
            do {
                
                try FIRAuth.auth()?.signOut();
                return true;
                
            
            }
            
            catch {
                
                return false;
                
            }
            
            
            
        }
        
        return true;
        
        
        
    }
    
    
    
    private func handle_errors(err: NSError,l_handler: L_handler?){
        
        if let error_code = FIRAuthErrorCode(rawValue: err.code)
        {
            switch error_code {
            case .errorCodeWrongPassword:
                l_handler?(error_msgs.WRONG_PASSWORD);
                break;
            case .errorCodeUserNotFound:
                l_handler?(error_msgs.USER_NOTFOUND);
                break;
            case .errorCodeWeakPassword:
                l_handler?(error_msgs.WEAK_PASSWORD);
                break;
            case .errorCodeInvalidEmail:
                l_handler?(error_msgs.INVALID_EMAIL);
                break;
            case .errorCodeEmailAlreadyInUse:
                l_handler?(error_msgs.EMAIL_INUSE);
                break;
            
            default:
                l_handler?(error_msgs.DEFAULT);
                break;
            }
            
            
        }
        
    }
    
    
    
}//class
