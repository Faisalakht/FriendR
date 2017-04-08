//
//  CreateAccount.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-03.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseDatabase

class CreateAccount: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var email: HoshiTextField!
    
    
    @IBOutlet weak var password: HoshiTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self;
        password.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnback(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        email.resignFirstResponder()
        return true
    }

    
    @IBAction func Register(_ sender: AnyObject) {
        
        
        
        if email.text != "" && password.text != ""
        {
            
            AuthSet.Instance.register(email: email.text!, password: password.text!, l_handler: {
                
                (message) in
                
                
                if message != nil
                {
                    
                    self.alertsign(title: "Cant login", msg: message!)
                    
                }
                else
                {
                    
                    //print("jello");
                    //let data:Dictionary <String ,Any> = [Constants.EMAIL : self.email.text!]
                    //FIRDatabase.database().reference().child(Constants.USERS).childByAutoId().setValue(data);
                    self.dismiss(animated: true, completion: nil);

                    
                }
                
                
                
                
                
            });
            
        }

        
        
        
        
        
    }
    
    
    
    
    
    
    private func alertsign (title: String, msg: String)
    {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    

}
