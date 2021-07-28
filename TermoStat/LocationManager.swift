//
//  LocationManager.swift
//  TermoStat
//
//  Created by Nikita Laptyonok on 27.07.21.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    override private init() {}
    var completion: ((CLLocation) -> Void)?
    let manager = CLLocationManager()
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    public func resolveLocationName(with location: CLLocation,
                                    completion: @escaping ((String?) -> Void)) {
        let geoCoder = CLGeocoder()
        //geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU"))
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print(place)
            var name = ""
            if let locality = place.locality {
                name += locality
            }
            if let country = place.country {
                name += ", \(country)"
            }
            completion(name)
        }
    }
    public func resolveLocationCoordWith(name location: String,
                                    completion: @escaping ((CLPlacemark?) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, in: nil) { (placemarks, error) in
            guard
                let placemarks = placemarks
            else {
                print("No location find")
                return
            }
            completion(placemarks.first)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
