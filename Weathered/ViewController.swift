//
//  ViewController.swift
//  Weathered
//
//  Created by David Gibbs on 07/12/2015.
//  Copyright © 2015 SixtySticks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userCity: UITextField!
    @IBOutlet weak var weatherDisplay: UITextView!
    
    @IBAction func findWeather(sender: AnyObject) {
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                var weather = ""
                
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    let stringToSearch = "<span class=\"phrase\">"
                    
                    if urlContent.containsString(stringToSearch) {
                        var urlContentArray = urlContent.componentsSeparatedByString(stringToSearch)
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
    
                        weather = weatherArray[0] as String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    } else {
                        urlError = true
                    }
                } else {
                    urlError = true
                }
                
                // Loads web content before waiting for any other code after this block to execute
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        self.showError()
                    } else {
                        self.weatherDisplay.text = weather
                    }
                }
            })
            
            task.resume()
            
        } else {
            showError()
        }
    }
    
    func showError() {
        weatherDisplay.text = "We were not able to find any results for \(userCity.text!). Please try again"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

