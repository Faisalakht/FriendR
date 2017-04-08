//
//  UserViewController.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-06.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class UserViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var shoppingList: [String] = ["Eggs", "Milk"]

    
    
    @IBOutlet weak var tblview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblview.dataSource = self;
        self.tblview.delegate  = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count;
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        
        cell.textLabel?.text = shoppingList[indexPath.row];
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("hello")
    }


}
