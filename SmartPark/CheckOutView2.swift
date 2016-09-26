//
//  CheckOutView2.swift
//  SmartPark
//
//  Created by Jose Cordova on 9/5/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit

class CheckOutView2: UITableViewController {
    
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var fee: UILabel!
    
    @IBOutlet weak var tip: UILabel!
    
    @IBOutlet weak var finalTotal: UILabel!
    
    var totalInt = Int()
    var subtotalInt = Int()
    var feeInt = Int()
    var tipInt = Int()
    var finalTotalInt = Int()
    
    var SERVICE_FEE:Float = 2.00
    
    
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    
    var bCodeIndex = Int()
    
    var message = String()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeLabels()
        checkoutDetails()
        
        
        //checkoutDetails()
        
        
        
        
        

        
        
        //subtotal.text = subtotalInt.description
        //fee.text = feeInt.description
        //tip.text = tipInt.description
        //totalLabel.text = finalTotalInt.description
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func initializeLabels(){
        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "#" + message
        
        restaurantName.text = (feedItems[bCodeIndex] as AnyObject).description
        restaurantName.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        totalLabel.text = (feedItems2[bCodeIndex] as AnyObject).description
        totalLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        subtotal.text = totalLabel.text
        fee.text = String(SERVICE_FEE)
        tip.text = String(0.00)
        //totalLabel.text = String(0)
        finalTotal.text = String()
    }
    
    func checkoutDetails(){
        
        //subtotalInt = convertFloat
        //feeInt = Int(fee.text!)!
        //tipInt = Int(tip.text!)!
        //finalTotalInt = (subtotalInt + feeInt + finalTotalInt)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
