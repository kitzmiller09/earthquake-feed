//
//  SingleQuakeViewController.swift
//  Shake n Quake
//
//  Created by Andrew Kitzmiller on 5/12/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit
import MapKit

class SingleQuakeViewController: UIViewController, MKMapViewDelegate {

    var quake = Earthquake()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    @IBOutlet weak var depthLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = MKMapType.Hybrid
        
        magnitudeLabel.text? = String(quake.magnitude)
        dateLabel.text? = quake.getFormattedDate()
        depthLabel.text? = "Depth: \(quake.geometry["depth"]!)"
        
//        let long = Double(quake.geometry["longitude"]!)
//        let lat = Double(quake.geometry["latitude"]!)
        coordinatesLabel.text = ""
        let long = Double(quake.geometry["longitude"]!)
        let lat = Double(quake.geometry["latitude"]!)
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpanMake(55, 55)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(quake.locationName)"
//        annotation.subtitle = "Magnitude: \(quake.magnitude)"
        
        mapView.addAnnotation(annotation)
        
        self.navigationItem.title = quake.getFormattedLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
