//
//  WebServices.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import Foundation

class WebService {
    func getVehicles(url: URL, completion: @escaping ([Vehicle]?) -> () ) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {

                let vehicleList = try? JSONDecoder().decode(VehicleList.self, from: data)
                
                if let vehicleList = vehicleList {
                    completion(vehicleList.vehicles)
                }
            }
        }.resume()
    }
}
