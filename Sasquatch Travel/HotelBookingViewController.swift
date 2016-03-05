//
//  HotelBookingViewController.swift
//  Sasquatch Travel
//
//  Created by Evan on 18/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit

class HotelBookingViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var nights: UILabel!
    @IBOutlet weak var guests: UILabel!
    
    @IBOutlet weak var nightsStepper: UIStepper!
    @IBOutlet weak var guestsStepper: UIStepper!
    
    var hotelName:String?
    
    
    @IBAction func nightsStepperValueChanged(sender: UIStepper) {
        nights.text = Int(sender.value).description
        
    }
    
    @IBAction func guestsStepperValueChanged(sender: UIStepper) {
        guests.text = Int(sender.value).description
        
    }
    @IBAction func makeBooking(sender: AnyObject) {
        print(name.text)
        print(date.date)
        print(nightsStepper.value)
        print(guestsStepper.value)
        print(hotelName)
        Model.sharedInstance.makeBooking(name.text!, hotelName: hotelName!, dateIn: date.date,  nights: Int32(nightsStepper.value), guests: Int32(guestsStepper.value))
        
        var conf = "Booking Confirmed"
        
        let alertController = UIAlertController(title: "Booking confirmed", message: conf, preferredStyle: UIAlertControllerStyle.Alert)
        
        var actionDismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("headHome", sender: self)
        }
        
        alertController.addAction(actionDismiss)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Booking"
        
        nightsStepper.wraps = false
        nightsStepper.autorepeat = true
        nightsStepper.maximumValue = 20
        
        guestsStepper.wraps = false
        guestsStepper.autorepeat = true
        guestsStepper.maximumValue = 10
        
        nights.text = Int(nightsStepper.value).description
        guests.text = Int(guestsStepper.value).description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when clicking press outside text field
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
