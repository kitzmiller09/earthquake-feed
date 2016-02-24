//
//  FilterOptionsTableViewController.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 2/18/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit

protocol SendMinMagDelegate {
    func sendMinMag(mag: String)
}

class FilterMagTableViewController : UITableViewController {
    
    var magnitudeNum = ["8.0", "7.0", "6.0", "5.0", "4.0", "3.0", "2.0"]
    
    var currentlySelected = ""
    var checkmarkIndex = 0
    
    var delegate: SendMinMagDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //changeSettings
        currentlySelected = magnitudeNum[indexPath.row]
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate?.sendMinMag(self.currentlySelected)
        })
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("magnitudeFilterCell", forIndexPath: indexPath)
//        
//        // Check if the cell is the selected cell
//        if indexPath.row == checkmarkIndex {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }
//        return cell
//    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }*/
}
