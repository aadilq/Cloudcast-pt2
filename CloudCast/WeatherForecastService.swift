//
//  WeatherForecastService.swift
//  CloudCast
//
//  Created by Aadil on 7/11/25.
//

import Foundation

struct WeatherAPIResponse: Decodable {
  let currentWeather: CurrentWeatherForecast

  private enum CodingKeys: String, CodingKey {
    case currentWeather = "current_weather"
  }
}

struct CurrentWeatherForecast: Decodable {
  let windSpeed: Double
  let windDirection: Double
  let temperature: Double
  let weatherCodeRaw: Int
  var weatherCode: WeatherCode {
    return WeatherCode(rawValue: weatherCodeRaw) ?? .clearSky
  }
    private enum CodingKeys: String, CodingKey {
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case temperature = "temperature"
        case weatherCodeRaw = "weathercode"
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
            //Check for network errors, if there any network errors, make sure to log the error and exit early
            guard error == nil else{
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            //Check if the response is a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else{
                assertionFailure("Invalid Response")
                return
            }
            //Verify that data exists and the HTTP status code is 200 (success).
            guard let data = data, httpResponse.statusCode == 200 else{
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(WeatherAPIResponse.self, from: data)
            DispatchQueue.main.async {
                completion?(response.currentWeather)
            }
           
        }
        task.resume()

        
    }
    private static func parse(data: Data) -> CurrentWeatherForecast{
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let currentWeather = jsonDictionary["currentWeather"] as! [String: Any]
        
        let windSpeed = currentWeather["windspeed"] as! Double
        
        let windDirection = currentWeather["windDirection"] as! Double
        
        let temperature = currentWeather["temperature"] as! Double
        
        let weatherCodeRaw = currentWeather["weathercode"] as! Int
        
        return CurrentWeatherForecast(windSpeed: windSpeed, windDirection: windDirection, temperature: temperature, weatherCodeRaw: weatherCodeRaw)
    }
}
