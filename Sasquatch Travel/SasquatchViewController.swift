//
//  ViewController.swift
//  Sasquatch Travel
//
//  Created by Evan on 1/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit

class SasquatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var model = Model.sharedInstance
    var hotels = [Hotel]()
    var destinations :[String] = ["Banff", "Revelstoke", "Whistler"]
    var queryDest:String = "Banff"
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var destination: UIPickerView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var hotelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        
        subHeadingLabel.lineBreakMode = .ByWordWrapping
        subHeadingLabel.numberOfLines = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDynamicTypeChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleDynamicTypeChange() {
        self.configureView()
    }
    
    func configureView() {
        headingLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        subHeadingLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        hotelButton.titleLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Load hotels data using Expedia API
    @IBAction func findHotels(sender: AnyObject) {
        
        self.activityIndicatorView.startAnimating()
        
        let data:NSData = DataManager.getHotelsDataFromExpediaSyncronous(queryDest)
        var json = JSON(data: data)
        self.hotels = [Hotel]()
        
        if let hotelArray = json["HotelListResponse"]["HotelList"]["HotelSummary"].array {
            for hotelDict in hotelArray {
                let hotelName: String? = hotelDict["name"].string
                let decodedHotelName = String(htmlEncodedString: hotelName!)
                let imageUrl: String = "http://images.travelnow.com" + hotelDict["thumbNailUrl"].string!
                let finalImage = imageUrl.stringByReplacingCharactersInRange(Range(start: imageUrl.endIndex.advancedBy(-5), end: imageUrl.endIndex.advancedBy(-4)), withString: "b")
                let hotelRating: Int? = hotelDict["hotelRating"].int
                let shortDescription: String? = hotelDict["shortDescription"].string
                let decodedDesc = String(htmlEncodedString: shortDescription!)
                let strippedDesc = decodedDesc.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                let latitude: Float? = hotelDict["latitude"].float
                let longitude: Float? = hotelDict["longitude"].float
                let hotel = Hotel(name: decodedHotelName, imageUrl: finalImage, rating: hotelRating!, shortDescription: strippedDesc, latitude: latitude!, longitude: longitude!)
                self.hotels.append(hotel)
            }
        }
        print("data loaded!")
        self.model.hotels = self.hotels
        self.activityIndicatorView.stopAnimating()
        self.performSegueWithIdentifier("hotelDetail", sender: sender)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return destinations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return destinations[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        queryDest = destinations[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hotelDetail" {
            let hotelTableViewController = segue.destinationViewController as! HotelTableViewController
        }
    }
    
    // Allows unwind back to start screen from booking view
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}

// From http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
// String extension to decode HTML entitites
extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        self.init(attributedString.string)
    }
}

