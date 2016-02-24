//
//  MapViewController.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 2/18/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var worldMap: MKMapView!
    
    var mapQuakes = [Earthquake()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worldMap.delegate = self
        worldMap.mapType = MKMapType.Hybrid
        
        showEarthquakes()
    }
    
    func showEarthquakes() {
        
        for quake in mapQuakes {
            
            let long = Double(quake.geometry["longitude"]!)
            let lat = Double(quake.geometry["latitude"]!)
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let span = MKCoordinateSpanMake(75, 75)

            let region = MKCoordinateRegion(center: location, span: span)
            
            worldMap.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "\(quake.locationName)"
            annotation.subtitle = "Magnitude: \(quake.magnitude)"
            
            worldMap.addAnnotation(annotation)
        }
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
