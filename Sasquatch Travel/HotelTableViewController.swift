//
//  HotelTableViewController.swift
//  Sasquatch Travel
//
//  Created by Evan on 1/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit

class HotelTableViewController: UITableViewController {
    
    var model = Model.sharedInstance
    var hotels = [Hotel]()
    
    // Sets up a networking session
    let session = NSURLSession.sharedSession()
    
    // Constants for building various url requests to the service
    let BASE_URL:String = "http://api.ean.com/ean-services/rs/hotel/v3/list?"
    let API_KEY :String = "apikey=7tvfrbpueabd75jl8cl40f1s81"
    let CID:String = "&cid=487267"
    let CURRENCY_CODE:String = "&currencyCode=AUD"


    let ID_LENGTH:Int  = 5
    
    var url : String = "http://api.ean.com/ean-services/rs/hotel/v3/list?apikey=7tvfrbpueabd75jl8cl40f1s81&cid=487267&currencyCode=AUD"
    var request : NSMutableURLRequest = NSMutableURLRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hotels"
        hotels = model.hotels
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDynamicTypeChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleDynamicTypeChange() {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(hotels)
        return hotels.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell

        let hotel = hotels[indexPath.row]
        cell.hotelLabel.text = hotel.name
        
        cell.hotelLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hotelDetail" {
            let hotelDetailViewController = segue.destinationViewController as! HotelDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let hotel = self.model.hotels[indexPath.row]
            model.selectedHotel = hotel
            
            hotelDetailViewController.hotelName = hotel.name
            hotelDetailViewController.hotelDesc = hotel.shortDescription
            hotelDetailViewController.imgURL = hotel.imageURL
            hotelDetailViewController.lat = hotel.lat
            hotelDetailViewController.lon = hotel.lon
            
        }
    }
}
