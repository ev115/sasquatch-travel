//
//  Booking.swift
//  Sasquatch Travel
//
//  Created by Evan on 1/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import Foundation
import CoreData

class Booking:NSManagedObject
{
    @NSManaged var name:String
    @NSManaged var hotel:String
    @NSManaged var dateIn:NSDate
    @NSManaged var nights:Int32
    @NSManaged var guests:Int32
    
    
    func getName()->String
    {
        return self.name as String
    }
    
    func getHotelName()->String
    {
        return self.hotel as String
    }
    
    func getDate()->String
    {
        let dateFormatter = NSDateFormatter()
        let dateFormat = NSDateFormatterStyle.ShortStyle
        let timeFormat = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateStyle = dateFormat
        dateFormatter.timeStyle = timeFormat
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.stringFromDate(self.dateIn)
        
        return dateString as String
    }
    
    func getnights()->Int32
    {
        return self.nights as Int32
    }
    
    func getGuests()->Int32
    {
        return self.guests as Int32
    }
}
