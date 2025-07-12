//
//  WeatherForecastService.swift
//  CloudCast
//
//  Created by Aadil on 7/11/25.
//

import Foundation

struct CurrentWeatherForecast {
  let windSpeed: Double
  let windDirection: Double
  let temperature: Double
  let weatherCodeRaw: Int
  var weatherCode: WeatherCode {
    return WeatherCode(rawValue: weatherCodeRaw) ?? .clearSky
  }
}

class WeatherForecastService{
    static func fetchForecast(latitude: Double,
                              longitude: Double,
                              completion: ((CurrentWeatherForecast) -> Void)? = nil ){
        let parameters = "latitude=\(latitude)&longitude=\(longitude)&current_weather=true&temperature_unit=fahrenheit&timezone=auto&wind_speed_unit=mph"
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?\(parameters)")!
        //Create a network task that will fetch data from this URL, and when it's done, call this function with the results
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            
            
        }

        
    }
}
