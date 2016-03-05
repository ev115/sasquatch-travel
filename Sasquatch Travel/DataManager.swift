//
//  DataManager.swift
//  Sasquatch Travel
//
//  Created by Evan on 4/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import Foundation
var url:String = "http://api.ean.com/ean-services/rs/hotel/v3/list?cid=487627&minorRev=99&apiKey=7tvfrbpueabd75jl8cl40f1s81&locale=en_US&currencyCode=USD&sig=4d667d684357f78bf4c0a02452e9130f"


let BASE_URL:String = "http://api.ean.com/ean-services/rs/hotel/v3/list?"
let CID:String = "cid=487627&minorRev=99"
let API_KEY = "7tvfrbpueabd75jl8cl40f1s81"
let SECRET = "6ijbsc62j2kll"
let SIG = "&sig="
var query = "&locale=en_US&currencyCode=AUD&city="
var state = "&stateProvinceCode=BC"
var noResults = "&arrivalDate=09/06/16&departureDate=09/07/2016&room1=2&numberOfResults=20"

// String extension to get MD5 hash
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}

class DataManager {
    
    class func getHotelsDataFromExpediaSyncronous(destination: String) -> NSData {
        if destination == "Banff" {
            state = "&stateProvinceCode=AB"
        } else {
            state = "&stateProvinceCode=BC"
        }
        
        let currentDate = NSDate()
        let timestamp = currentDate.timeIntervalSince1970
        let time:Int = Int(timestamp)
        let timeText:String = time.description
        print(timeText)
        print(API_KEY + SECRET + timeText)
        let sig:String = (API_KEY + SECRET + timeText).md5
        print(sig)
        
        let urlPath = BASE_URL + CID + "&apiKey=" + API_KEY + "&sig=" + sig + query + destination + state + noResults
        print("URL: " + urlPath)
        
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
        
        return dataVal
    }
    
    class func getHotelsDataFromExpediaWithSuccess (destination: String, success: ((expediaData: NSData) -> Void)) {
        if destination == "Banff" {
            state = "&stateProvinceCode=AB"
        } else {
            state = "&stateProvinceCode=BC"
        }
        
        let currentDate = NSDate()
        let timestamp = currentDate.timeIntervalSince1970
        let time:Int = Int(timestamp)
        let timeText:String = time.description
        print(timeText)
        
        print(API_KEY + SECRET + timeText)
        let sig:String = (API_KEY + SECRET + timeText).md5
        print(sig)
        
        let url = BASE_URL + CID + "&apiKey=" + API_KEY + "&sig=" + sig + query + destination + state + noResults
        print("URL: " + url)
        
        loadDataFromURL(NSURL(string: url)!, completion: {(data,error) -> Void in
            if let urlData = data {
                success(expediaData: urlData)
            }
        })
    }
        
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusErrror = NSError(domain: "com.evan", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusErrror)
                } else {
                    completion(data: data , error: nil)
                }
            }
    })
    
        loadDataTask.resume()

    }
}