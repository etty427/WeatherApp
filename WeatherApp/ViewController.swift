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
    }
    
    private func getWeather() {
        getLocation(location: locationTextField.text ?? "No Location Entered")
    }
    
    func getLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                            self.weeklyForcast = weatherData
                            
                            DispatchQueue.main.async {
                              self.tableview.reloadData()
                            }
                            
                        }
                        
                    })
                    Weather.getCurrentWeather(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let currentData = results {
                            self.forecastData = currentData
                            
                        }
                    })
                }
                
            }
        }
    }
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        getWeather()
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
        return weeklyForcast.count
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
        
        let currentObject = forecastData[indexPath.row]
        let weekObject = weeklyForcast[indexPath.row]
        
        cell.textLabel?.text = weekObject.summary
        cell.detailTextLabel?.text = "\(Int(weekObject.temperature)) °F"
        cell.imageView?.image = UIImage(named: weekObject.icon)
        cell.backgroundColor = .lightGray
        
        tempertureLabel.text = "\(Int(currentObject.temperature))"
        iconLabel.text = currentObject.icon
        
        return cell
    }
}

