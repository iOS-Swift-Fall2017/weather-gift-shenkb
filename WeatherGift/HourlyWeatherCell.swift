//
//  HourlyWeatherCell.swift
//  WeatherGift
//
//  Created by Kaining on 11/5/17.
//  Copyright © 2017 Kaining. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ha"
    return dateFormatter
}()

class HourlyWeatherCell: UICollectionViewCell {
    @IBOutlet weak var hourlyTime: UILabel!
    @IBOutlet weak var hourlyTemp: UILabel!
    @IBOutlet weak var hourlyPrecipProb: UILabel!
    @IBOutlet weak var hourlyIcon: UIImageView!
    @IBOutlet weak var rainDropImage: UIImageView!
    
    func update(with hourlyForcast: WeatherDetail.HourlyForecast, timeZone: String) {
        hourlyTemp.text = String(format: "%2.f", hourlyForcast.hourlyTemp) + "°"
        hourlyIcon.image = UIImage(named: "small-" + hourlyForcast.hourlyIcon)
        let precipProb = hourlyForcast.hourlyPrecipProb * 100
        let isHidden = precipProb < 30.0
        hourlyPrecipProb.isHidden = isHidden
        rainDropImage.isHidden = isHidden
        hourlyPrecipProb.text = String(format: "%2.f", precipProb) + "%"
        let dayString = hourlyForcast.hourlyTime.format(timeZone: timeZone, dateFormatter: dateFormatter)
        hourlyTime.text = dayString
    }
}
