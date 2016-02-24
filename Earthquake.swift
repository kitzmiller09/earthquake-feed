//
//  Earthquake.swift
//  Shake n Quake
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 2/16/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit

class Earthquake: NSObject {
    
    var magnitude = Float()
    var locationName = String()
    var time = Double()
    var geometry = [String : Float]()
    
    func getFormattedDate() -> String {
        let dateFormatter = NSDateFormatter()
        let timeInterval = time / 1000.0
        
        dateFormatter.dateFormat = "MM/dd 'at' HH:mm a"
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        var formattedDate = dateFormatter.stringFromDate(date)
        
        //Remove 0's from the front fo the date
        if formattedDate.characters.first == "0" {

            formattedDate = formattedDate.substringFromIndex(formattedDate.startIndex.advancedBy(1))
        }
        
        return formattedDate;
    }
    
    func getFormattedLocation() -> String {
        
        //Trim between 0 and "of "
        let ofPos = locationName.rangeOfString("of")    //Range containing the substring "of"
        
        if ofPos != nil {   //Not all Locations retrieved contain the word "of"
            var finalLoc = locationName.substringFromIndex(ofPos!.endIndex)
            
            finalLoc = finalLoc.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            return finalLoc
        } else {
            return locationName
        }
    }
}
