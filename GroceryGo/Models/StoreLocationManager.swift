//
//  StoreLocationManager.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import Foundation
import CoreLocation
import MapKit

/// Manages location services and store searches
@MainActor
class StoreLocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var searchResults: [MKMapItem] = []
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    /// Request location authorization from the user
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Start updating user location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stop updating user location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Search for grocery stores near a coordinate
    /// - Parameters:
    ///   - coordinate: The coordinate to search near
    ///   - searchText: Optional search text to filter results
    func searchForGroceryStores(near coordinate: CLLocationCoordinate2D, searchText: String = "") {
        let request = MKLocalSearch.Request()
        
        // If user provides search text, use it; otherwise search for generic grocery stores
        if searchText.isEmpty {
            request.naturalLanguageQuery = "grocery store"
        } else {
            request.naturalLanguageQuery = searchText
        }
        
        request.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        let search = MKLocalSearch(request: request)
        
        Task {
            do {
                let response = try await search.start()
                await MainActor.run {
                    self.searchResults = response.mapItems
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to search for stores: \(error.localizedDescription)"
                    self.searchResults = []
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension StoreLocationManager: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            self.userLocation = location.coordinate
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.errorMessage = "Location error: \(error.localizedDescription)"
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            
            if manager.authorizationStatus == .authorizedWhenInUse || 
               manager.authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }
}
