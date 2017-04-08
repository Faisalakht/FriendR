//
//  LoginVC.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-03.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import CoreLocation




class LoginVC: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {

    
    var locationManager:CLLocationManager?
    
    
    
    @IBOutlet weak var password: HoshiTextField!
    
    @IBOutlet weak var email: HoshiTextField!
    
      var usrlist = [User]()
    
    var id = FIRAuth.auth()?.currentUser?.uid
    
    var currentLocation:CLLocation?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        password.delegate = self;
        email.delegate = self;
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FIRAuth.auth()?.currentUser != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let id = FIRAuth.auth()?.currentUser?.uid
            let email = FIRAuth.auth()?.currentUser?.email

            let long = (self.currentLocation?.coordinate.longitude)!
            let lat = (self.currentLocation?.coordinate.latitude)!
            
            let data:Dictionary <String,Any> = [Constants.SENDER_ID : id!,Constants.EMAIL : email!,Constants.LONG : long , Constants.LAT : lat]
            FIRDatabase.database().reference().child(Constants.ONLINE).child(id!).setValue(data);
            self.locationManager?.stopUpdatingLocation()
            self.performSegue(withIdentifier: "UserSeg", sender: nil);
            
            
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        email.resignFirstResponder()
        return true
    }


    @IBAction func LogIn(_ sender: AnyObject) {
        
        
        if email.text != "" && password.text != "" {
            
            AuthSet.Instance.login(email: email.text!, password: password.text!, l_handler: {
                (message) in
                
                if message != nil
                {
                    
                    self.alertsign(title: "Cant login", msg: message!)
                    
                }
                else
                {
                    
                    let id = FIRAuth.auth()?.currentUser?.uid
                    let email = FIRAuth.auth()?.currentUser?.email
                    let long = (self.currentLocation?.coordinate.longitude)! 
                    let lat = (self.currentLocation?.coordinate.latitude)!
                    let data:Dictionary <String,Any> = [Constants.SENDER_ID : id!,Constants.EMAIL : email!,Constants.LONG : long, Constants.LAT : lat]
                    FIRDatabase.database().reference().child(Constants.ONLINE).child(id!).setValue(data);
                    
                    self.locationManager?.stopUpdatingLocation()
                     self.performSegue(withIdentifier: "UserSeg", sender: self);
                    
                }
                
                
                
            })
            
        }
        
        
    }
    

    @IBAction func CreateAccount(_ sender: AnyObject) {
        performSegue(withIdentifier: "RegisterSeg", sender: self);
    }
    
    
    
    private func alertsign (title: String, msg: String)
    {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    
    func loaddata () {
        
        FIRDatabase.database().reference().child(Constants.ONLINE).observe(FIRDataEventType.childAdded) { (snapshot : FIRDataSnapshot)  in
            
            
            if let data = snapshot.value as? NSDictionary {
                
                
                if let email = data[Constants.EMAIL] as? String {
                    
                    if let id = data[Constants.SENDER_ID] as? String {
                        
                        
                        
                        let newusr = User(id: id, email: email)
                        self.usrlist.append(newusr);
                        print("THIS IS USRLIST",self.usrlist);
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         self.currentLocation = locations[0]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "UserSeg") {
            
            var viewController = segue.destination as! UsersVC;
            // your new view controller should have property that will store passed value
            viewController.currentLocation = self.currentLocation
        }
        
        
        
    }
    
    
    
    

}//class
