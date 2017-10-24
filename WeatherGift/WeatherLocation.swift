//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Kaining on 10/22/17.
//  Copyright © 2017 Kaining. All rights reserved.
//

import Foundation
import Alamofire

class weatherLocation {
    var name = ""
    var coordinates = ""
    
    func getWeather() {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        Alamofire.request(weatherURL).responseJSON { response in
            print(response)
            
        }
    }
}

