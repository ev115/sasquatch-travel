//
//  MyBookingsViewController.swift
//  Sasquatch Travel
//
//  Created by Evan on 18/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit

class MyBookingsViewController: UIViewController, UITableViewDelegate {
    
    var model = Model.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtHotelName: UILabel!
    @IBOutlet weak var txtDateIn: UILabel!
    @IBOutlet weak var txtGuests: UILabel!
    @IBOutlet weak var txtNights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.getBookings()
        tableView.allowsSelectionDuringEditing = true
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        model.getBookings()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.bookings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell", forIndexPath: indexPath) as! CustomTableViewCell
        let booking = model.getBooking(indexPath)
        cell.bookingLabel.text = booking.getDate()
        cell.nameLabel!.text = booking.getHotelName()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let booking = model.getBooking(indexPath)
        print(booking.getHotelName())
        txtHotelName.text = booking.getHotelName()
        txtDateIn.text = booking.getDate()
        txtGuests.text = String(booking.getGuests())
        txtNights.text = String(booking.getnights())
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let cancelAlert = UIAlertController(title: "Cancel Booking", message: "Are you sure you want to cancel this booking?", preferredStyle: UIAlertControllerStyle.Alert)
            cancelAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                self.model.cancelBooking(self.model.bookings[indexPath.row])
                self.model.bookings.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.txtHotelName.text = ""
                self.txtDateIn.text = ""
                self.txtGuests.text = ""
                self.txtNights.text = ""
                
            }))
            cancelAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction) in
                self.tableView.reloadData()
            }))
            self.presentViewController(cancelAlert, animated: true, completion: nil)
            
            
        }
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
