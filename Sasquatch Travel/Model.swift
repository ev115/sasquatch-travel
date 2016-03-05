//
//  Model.swift
//  Sasquatch Travel
//
//  Created by Evan on 1/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Model {
    
    var bookings:[Booking] = [Booking]()
    var hotels:[Hotel]
    
    var selectedHotel:Hotel?
    
    private struct Static {
        static var instance:Model?
    }
    
    class var sharedInstance:Model {
        
        if !(Static.instance != nil) {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    private init() {
        hotels = [Hotel]()
    }
    
    func getBooking(indexPath: NSIndexPath) -> Booking {
        return bookings[indexPath.row]
    }
    
    func makeBooking(name:String, hotelName:String, dateIn:NSDate, nights:Int32, guests:Int32) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Booking", inManagedObjectContext: managedContext)
        
        let booking = Booking(entity: entity!, insertIntoManagedObjectContext: managedContext)
        booking.name = name
        booking.hotel = hotelName
        booking.dateIn = dateIn
        booking.nights = nights
        booking.guests = guests
        
        var error:NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func getBookings() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Booking")
        var fetchedResults = [Booking]()
        var error:NSError?
//        let fetchedResults = managedContext.executeFetchRequest(fetchRequest) as! [Booking]?
        
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [Booking]
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        bookings = fetchedResults
        
//        if let results = fetchedResults {
//            bookings = results
//        } else {
//            print("Could not fetch \(error), \(error!.userInfo)")
//        }
    }
    
    func cancelBooking(booking: Booking) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.deleteObject(booking)
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            abort()
        }
    }
}
