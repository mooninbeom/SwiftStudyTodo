//
//  weatherkit.swift
//  SwiftStudyTest
//
//  Created by 문인범 on 2023/06/30.
//

import WeatherKit
import CoreLocation

class MainWeather {
    
    var weatherKit: Weather?
    
    func getWeather(location: CLLocation) {
        
        Task {
            do {
                //WeatherService 싱글턴 사용
                let weather = try await WeatherService.shared.weather(for: location)
                
                print("Temp: \(weather.currentWeather.temperature)")
                print("체감온도: \(weather.currentWeather.apparentTemperature)")
                
                weather.dailyForecast.forEach{
                    dump("\($0.date), \($0.lowTemperature)")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
