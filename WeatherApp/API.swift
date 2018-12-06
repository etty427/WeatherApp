//
//  API.swift
//  WeatherApp
//
//  Created by Ty rainey on 12/2/18.
//  Copyright © 2018 Ty rainey. All rights reserved.
//

import Foundation

struct API {
    
    static let shared = API()
    
    let urlString = "https://api.darksky.net/forecast/c1ec2c952ab8d7fef0921b826f19d2e5/41.538155,-72.807045"
    
    func getData<T: Codable>(urlString: String,onCompletion: @escaping (T) -> (), onError: @escaping (Error) ->()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                onCompletion(json)
            }catch {
                print("Error:",error.localizedDescription)
            }
            }.resume()
    }
    
    func getHourlyData<T: Codable>(urlString: String,onCompletion: @escaping (T) -> (), onError: @escaping (Error) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                onCompletion(json)
            }catch {
                print("Error:",error.localizedDescription)
            }
            }.resume()
    }
}
