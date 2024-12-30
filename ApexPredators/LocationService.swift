//
//  LocationService.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/30/24.
//
import CoreLocation

/// A service class used for location related functionalities.
class LocationService {
    
    /// Converts geographic coordinates into a human-readable location string using reverse geocoding.
    /// This method uses CoreLocation's geocoding service to fetch the city and state information
    /// for the given coordinates.
    ///
    /// - Parameters:
    ///   - latitude: The latitude coordinate of the location to be converted.
    ///   - longitude: The longitude coordinate of the location to be converted.
    ///   - completion: A closure that receives the formatted location string.
    ///                 The string will be in the format "City, State" if available,
    ///                 or "Unknown location" if the geocoding fails
    ///
    /// Example usage:
    /// ```
    /// LocationService.fetchHumanReadableLocation(latitude: 37.7749, longitude: -122.4194) { location in
    ///     print(location) // Prints: "San Francisco, California"
    /// }
    /// 
    /// ```
    static func fetchHumanReadableLocation(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to get location: \(error.localizedDescription)")
                    completion("Unknown location")
                } else if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let state = placemark.administrativeArea ?? ""
                    
                    let location = [city, state]
                        .filter { !$0.isEmpty }
                        .joined(separator: ", ")
                    
                    completion(location.isEmpty ? "Unknown location" : location)
                } else {
                    completion("Unknown location")
                }
            }
        }
    }
}
