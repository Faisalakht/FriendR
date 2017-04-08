//
//  UsersVC.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-03.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import CoreLocation

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    var usrlist = [User]()
    var tracker = [String]()
    var destname: String!;
    var long: Double!
    var lat: Double!
    let myemail = FIRAuth.auth()?.currentUser?.email
    
    var locationManager:CLLocationManager?
    
    var currentLocation:CLLocation?;

    @IBOutlet weak var tblview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        loaddata()
        removedata()
        //self.tblview.dataSource = self;
        self.tblview.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usrlist.count;
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    
    
    func loaddata () {

        FIRDatabase.database().reference().child(Constants.ONLINE).observe(FIRDataEventType.childAdded) { (snapshot : FIRDataSnapshot)  in
            
        
            if let data = snapshot.value as? NSDictionary {
                
                
                if let email = data[Constants.EMAIL] as? String {
                    
                    if let id = data[Constants.SENDER_ID] as? String {
                        
                        
                        if email != self.myemail {
                            
                            
                            let long = data[Constants.LONG] as! CLLocationDegrees
                            let lat = data[Constants.LAT] as! CLLocationDegrees
                            let loc =  CLLocation(latitude: lat, longitude: long);
                            
                            print((self.currentLocation?.distance(from: loc))!/1000)
                            
                            
                            
   
                            if ((self.currentLocation?.distance(from: loc))!/1000) < 1.002 {
                            let newusr = User(id: id, email: email)
                            
                            self.usrlist.append(newusr);
                            self.tracker.append(email);
                                
                                
                                DispatchQueue.main.async {
                                    self.tblview.reloadData()
                                    
                                }
                                
                                
                                
                            }
                        
                        }
                        
                        


                        print("THIS IS USRLIST",id);
                        
                    }
                    
                    
                }
                
                
                
            }
        
        
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        
        cell.textLabel?.text = usrlist[indexPath.row].email;
        
        return cell;
    }
    
    
    
    
    
    @IBAction func refreshbtn(_ sender: AnyObject) {
        
        self.tblview.reloadData()
        
    }
    
    
    @IBAction func logoutbtn(_ sender: AnyObject) {
        
        let id = FIRAuth.auth()?.currentUser?.uid
        //let email = FIRAuth.auth()?.currentUser?.email
        
        do {
            try FIRAuth.auth()?.signOut()
            FIRDatabase.database().reference().child(Constants.ONLINE).child(id!).removeValue()
            self.removedata()
            self.dismiss(animated: true, completion: nil);
        } catch  {
            print("Error checking needs to be done!")
        }
        
    }
    
    
    
    
    
    func onlinestatus()
    {
        
        let lat = (currentLocation?.coordinate.latitude)!
        let long = (currentLocation?.coordinate.longitude)!
        let id = FIRAuth.auth()?.currentUser?.uid
        let email = FIRAuth.auth()?.currentUser?.email
        let data:Dictionary <String,Any> = [Constants.SENDER_ID : id!,Constants.EMAIL : email!]
        FIRDatabase.database().reference().child(Constants.ONLINE).child(id!).setValue(data);

        
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        print((currentCell!.textLabel!.text)!)
        
        self.destname = (currentCell!.textLabel!.text)!
        performSegue(withIdentifier: "ChatSeg", sender: self);

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ChatSeg") {
            
            let navVC = segue.destination as? UINavigationController
            let tableVC = navVC?.viewControllers.first as! ChatVC
            tableVC.destname = self.destname;
        }
        
    

        
        
        



    }
    
    
    
    
    
    
    
    func removedata () {
        
        FIRDatabase.database().reference().child(Constants.ONLINE).observe(FIRDataEventType.childRemoved) { (snapshot : FIRDataSnapshot)  in
            
            
            if let data = snapshot.value as? NSDictionary {
                
                
                if let email = data[Constants.EMAIL] as? String {
                    
                    if let id = data[Constants.SENDER_ID] as? String {
                        
                        if let itemToRemoveIndex = self.tracker.index(of: email) {
                            self.tracker.remove(at: itemToRemoveIndex)
                            self.usrlist.remove(at: itemToRemoveIndex)
                        }
                        
                        //let newusr = User(id: id, email: email)
                        //self.usrlist.append(newusr);
                        
                        
                        DispatchQueue.main.async {
                           self.tblview.reloadData()
                            
                        }
                        print("REMOVED",email);
                        
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
    
    
    
    
    
    
    
    
}
