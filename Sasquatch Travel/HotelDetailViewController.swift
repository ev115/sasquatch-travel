//
//  HotelDetailViewController.swift
//  Sasquatch Travel
//
//  Created by Evan on 18/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit
import MapKit

class HotelDetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var txtHotelName: UILabel!
    @IBOutlet weak var txtHotelDesc: UILabel!
    @IBOutlet weak var hotelMap: MKMapView!
    
    var model = Model.sharedInstance
    var hotelName:String?
    var hotelDesc:String?
    var imgURL:String?
    var lat: Float?
    var lon: Float?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = "Hotel Details"
        txtHotelName.text = hotelName
        
        let latitude: CLLocationDegrees = Double(lat!)
        let longitude: CLLocationDegrees = Double(lon!)
        let latDelta: CLLocationDegrees = 0.02
        let lonDelta: CLLocationDegrees = 0.02
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let hotelFlag = MKPointAnnotation()
        hotelFlag.coordinate = location
        hotelFlag.title = hotelName
        hotelMap.addAnnotation(hotelFlag)
        
        hotelMap.setRegion(region, animated: true)
        
        
        let fullImgURL = NSURL(string: imgURL!)
        
        if let imageData = NSData(contentsOfURL: fullImgURL!) {
            dispatch_async(dispatch_get_main_queue(), {
                self.hotelImage.image = UIImage(data: imageData)
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hotelBooking" {
            let hotelBookingViewController = segue.destinationViewController as! HotelBookingViewController
            
            hotelBookingViewController.hotelName = hotelName
        }
    }
}
