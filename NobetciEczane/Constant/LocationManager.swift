//
//  LocationManager.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 26.09.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var city: String = ""
    @Published var district: String = ""
    
    private var lastGeocodeTime: Date?
    private let geocodeInterval: TimeInterval = 10

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        let currentTime = Date()
        if let lastTime = lastGeocodeTime, currentTime.timeIntervalSince(lastTime) < geocodeInterval {
            return
        }
        
        lastGeocodeTime = currentTime
        fetchCityAndDistrict(from: location)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            stopUpdatingLocation()
        }
    }
    
    func fetchCityAndDistrict(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                if let city = placemark.administrativeArea {
                    self.city = city
                }
                
                if let district = placemark.subAdministrativeArea {
                    self.district = district
                }
            }
        }
    }
}
