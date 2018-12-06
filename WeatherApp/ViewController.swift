//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ty rainey on 11/10/18.
//  Copyright © 2018 Ty rainey. All rights reserved.
//

import UIKit
import CoreLocation


final class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
     var dict: [String : String] = [:]
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var latitude = ""
    var longitude = ""
    var locationManager: CLLocationManager!
    var weeklyForcast = [Weather]()
    var forecastData = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        getCurrentWeather()
        getDailyForecast()
    }
    
    
    func getLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    }
                }
            }
        }
    
    @IBAction func getWeatherButton(_ sender: UIButton) {

    }
    
    private func getDailyForecast() {
        API.shared.getHourlyData(urlString: API.shared.urlString, onCompletion: { (daily: [DailyWeather.Daily]) in
            print(daily)
        }) { (err: Error) in
            print("Error")
        }
    }
    
    private func getCurrentWeather() {
        API.shared.getData(urlString: API.shared.urlString, onCompletion: { (weather: Weather) in
            self.forecastData.append(weather)
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                
                self.tempertureLabel.text = "\(Int(weather.currently.temperature))"
                self.iconLabel.text = weather.currently.icon
                self.iconImage.image = UIImage(named: weather.currently.icon)
            
            }
        }){ (err: Error) in
            print("Error parsing Json \(err)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        dict["latitude"] = "\(location.coordinate.latitude)"
        dict["longitude"] = "\(location.coordinate.longitude)"
        latitude = "\(String(describing: dict["latitude"]!))"
        longitude = "\(String(describing: dict["longitude"]!))"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let weekObject = forecastData[indexPath.row]
        
        cell.textLabel?.text = weekObject.currently.summary
        cell.detailTextLabel?.text = "\(Int(weekObject.currently.temperature)) °F"
        cell.imageView?.image = UIImage(named: "\(weekObject.currently.icon)")
        cell.backgroundColor = .lightGray
        
        return cell
    }
}
