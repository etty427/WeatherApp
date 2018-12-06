//
//  API.swift
//  WeatherApp
//
//  Created by Ty rainey on 11/10/18.
//  Copyright © 2018 Ty rainey. All rights reserved.
//
struct Currently:Codable {
    let summary:String
    let icon:String
    let temperature:Double
}
struct Weather: Codable {
    let currently: Currently
}

struct DailyWeather : Codable {
    struct Daily : Codable {
        let summary: String
        let icon: String       
    }

    struct Data : Codable {
        let summary: String
        let temperatureMax:Double
    }
    let daily: Daily
    let data: [Data]
}

