//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Kaining on 10/22/17.
//  Copyright © 2017 Kaining. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class weatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates

        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let temperature = json["currently"]["temperature"].double {
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return a temperature.")
                }
                
                if let summary = json["daily"]["summary"].string {
                    self.currentSummary = summary
                    print(self.currentSummary)
                } else {
                    print("Could not return a summary.")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}

