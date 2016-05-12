//
//  FilterTimeTableViewController.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 2/24/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit

protocol SendTimeDelegate {
    func sendMaxTime(time: String)
}

class FilterTimeTableViewController: UITableViewController {
    
    var timeDuration = ["Today", "Last 7 Days", "Last 30 Days"]
    
    var currentlySelected = ""
    var checkmarkIndex = 0
    
    var delegate: SendTimeDelegate?
    
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
        return 3
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //changeSettings
        currentlySelected = timeDuration[indexPath.row]
        
        //        self.dismissViewControllerAnimated(true, completion: nil)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate?.sendMaxTime(self.currentlySelected)
        })
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }
    */
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
}
