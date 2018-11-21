//
//  API.swift
//  WeatherApp
//
//  Created by Ty rainey on 11/10/18.
//  Copyright © 2018 Ty rainey. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    
    let summary:String
    let icon:String
    let temperature:Double
    
    init(summary: String,icon:String,temperature:Double) throws {
      
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    static let basePath = "https://api.darksky.net/forecast/c1ec2c952ab8d7fef0921b826f19d2e5/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var weeklyArray:[Weather] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                   let temp = dataPoint["temperatureMax"] as! Double
                                   let summary = dataPoint["summary"] as! String
                                   let icon = dataPoint["icon"] as! String
                                    let week = try Weather(summary: summary, icon: icon, temperature: temp)
                                   weeklyArray.append(week)
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(weeklyArray)
            }
        }
        task.resume()
    }
    
    static func getCurrentWeather(withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var forecastData = [Weather]()
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(json)
                        if let currentForecasts = json["currently"] as? [String:Any] {
                            let temp = currentForecasts["temperature"] as! Double
                            let summary = currentForecasts["summary"] as! String
                            let icon = currentForecasts["icon"] as! String
                            let currentWeather = try Weather(summary: summary, icon: icon, temperature: temp)
                            forecastData.append(currentWeather)
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastData)
            }
        }
        task.resume()
    }
}
