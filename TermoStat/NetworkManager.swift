//
//  NetworkManager.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 27.07.21.
//

import Foundation
import CoreLocation
#warning("Spril Network and CoreLocation")
// FIXME: Spril Network and CoreLocation

// TODO: -
// TODO: Prepare closure
// TODO: Call closure in VC
// TODO: Think about stringURL
// TODO: -

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((Result) -> Void)?
    
    func fetchWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/onecall?q=\(city)&exclude=minutely,alerts&appid=\(Constants.apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,alerts&appid=\(Constants.apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Some error in URL Session")
                return
            }
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> Result? {
        let decoder = JSONDecoder()
        var json: Result?
        do {
            json = try decoder.decode(Result.self, from: data)
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        guard let result = json else {
            return nil
        }
        return result
        
    
}

}
