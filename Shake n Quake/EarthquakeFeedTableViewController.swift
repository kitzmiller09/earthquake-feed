//
//  EarthquakeFeedTableViewController.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 1/26/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EarthquakeFeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshController = UIRefreshControl()
    
    var quakes = [Earthquake()]
    /* Sorting / Toolbar Buttons
            Sort
            - By date/time  (By Most Recent)
            - By Magnitude (Highest to Lowest)
            - By Distance? (Closest)
    
            Filter
            - Magnitude (> 2.5, > 3.0, etc.)
            - Date (Today, week, month)
            - Around Me (Toggle on or off)
    */
    
    var urlStartTime = ""
    var minimumMag = "2.0"
    
    var todaysDate = ""
    var weekData = ""
    var monthDate = ""

    var quakeFeedURL = ""
    
    
    //Pull to refresh
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var loadingView: UIView = UIView()
    var refreshDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDate()
        
        fetchQuakeFeed()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "EarthQuakeFeedTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "earthquakeCell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
        //Pull to refresh setup
        self.refreshController.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshController.addTarget(self, action: "fetchQuakeFeed", forControlEvents: UIControlEvents.ValueChanged);
        self.tableView?.addSubview(refreshController)
        self.refreshDateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        self.refreshDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchQuakeFeed() {
        quakes.removeAll()
        quakeFeedURL = "http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=" + urlStartTime + "&minmagnitude=" + minimumMag
        
        showActivityIndicator()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        Alamofire.request(.GET, quakeFeedURL).responseJSON { (response) -> Void in
            if let value = response.result.value {
                
                let json = JSON(value)
                
                for quakeItem in json["features"].arrayValue {
                    var quakeProperties = quakeItem["properties"]
                    var quakeGeometryCoords = quakeItem["geometry"]["coordinates"]
                    
                    let quake = Earthquake()
                    
                    quake.locationName = quakeProperties["place"].stringValue;
                    quake.magnitude = quakeProperties["mag"].floatValue;
                    quake.time = quakeProperties["time"].doubleValue;
                    
                    //Set Latitude, Longitude, and Depth
                    quake.geometry["longitude"] = quakeGeometryCoords[0].floatValue
                    quake.geometry["latitude"] = quakeGeometryCoords[1].floatValue
                    quake.geometry["depth"] = quakeGeometryCoords[2].floatValue
                    
                    self.quakes.append(quake)
                }
                
                self.quakes.removeFirst()
                
                self.hideActivityIndicator()
                
                // update "last updated" title for refresh control
                let now = NSDate()
                let updateString = "Last Updated at " + self.refreshDateFormatter.stringFromDate(now)
                self.refreshController.attributedTitle = NSAttributedString(string: updateString)
                if self.refreshController.refreshing {
                    self.refreshController.endRefreshing()
                }
                
                self.animateTable()
                
            } else {
                //TO DO: Display Alert View Controller
                
                print("Error")
            }
        }
    }
    
    func showActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)//: "#444444")
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    func setDate() {
        let today = NSDate()
        
        let lastWeek = today.dateByAddingTimeInterval(-1209600.0)
        
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let formattedDate = dateFormatter.stringFromDate(lastWeek)
        
        urlStartTime = formattedDate
        print(urlStartTime)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quakes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("earthquakeCell", forIndexPath: indexPath) as! EarthQuakeFeedTableViewCell
        
        cell.magnitudeLabel.text = String(quakes[indexPath.row].magnitude)
        cell.dateTimeLabel.text = String(quakes[indexPath.row].getFormattedDate())
        cell.locationLabel.text = String(quakes[indexPath.row].getFormattedLocation())
        
        return cell
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "showQuakeMap" {
            let destinationController = segue.destinationViewController as! MapViewController
            
            destinationController.mapQuakes = self.quakes
        } else if segue.identifier == "showFilterOptions" {
            let destinationController = segue.destinationViewController as! FilterSubmissionViewController
            destinationController.minMag = self.minimumMag
        }
        
    }
    
    
}
