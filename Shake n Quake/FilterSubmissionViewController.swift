//
//  FilterSubmissionViewController.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 2/19/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit

class FilterSubmissionViewController: UITableViewController, SendMinMagDelegate, SendTimeDelegate {
    
    @IBOutlet weak var minMagLabel: UILabel!
    
    @IBOutlet weak var maxDateLabel: UILabel!
    
    var minMag = ""
    var maxTime = ""
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        minMagLabel.text? = "\(minMag) or Higher"
//        maxDateLabel.text? =  "\(maxTime)"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.minMagLabel.text? = "\(minMag) or Higher"
//        self.maxDateLabel.text? =  "\(maxTime)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    //MARK: - Filter options
    //SendMinMagDelegate Method
    func sendMinMag(mag: String) {
        self.minMag = mag;
    }
    
    func sendMaxTime(time: String) {
        self.maxTime = time;
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMagFilterOptions" {
            let destinationController = segue.destinationViewController as! FilterMagTableViewController
//            destinationController.currentlySelected = self.minMag
            destinationController.delegate = self
        } else if segue.identifier == "submitFilters" {
            let destinationController = segue.destinationViewController as! EarthquakeFeedTableViewController
            destinationController.minimumMag = self.minMag
        }

    }
    

}
