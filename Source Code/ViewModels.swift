//
//  ViewModels.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/6/24.
//

import SwiftUI
import MapKit

final class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var gasStations: [GasStation] = []
    @Published var favoriteStations: [GasStation] = [] // List of favorite gas stations
    @Published var searchText: String = ""
    @Published var showLocationServicesAlert = false
    @Published var showLocationPrompt = false
    @Published var userEnteredLocation: String = ""
    
    private let locationManager = CLLocationManager()
    private let gasStationService = GasStationService()
    private var currentDataTask: URLSessionDataTask? // Store the current data task
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            showLocationServicesAlert = true
        }
    }
    
    func promptForLocation() {
        showLocationPrompt = true
    }
    
    func searchLocation(completion: @escaping () -> Void) {
        // Cancel any ongoing data task to prevent stale data processing
        currentDataTask?.cancel()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(userEnteredLocation.isEmpty ? searchText : userEnteredLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                completion()
                return
            }
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.fetchGasStations(for: self.userEnteredLocation.isEmpty ? self.searchText : self.userEnteredLocation) {
                    completion()
                }
            }
        }
    }
    
    func fetchGasStations(for area: String, completion: @escaping () -> Void) {
        // Cancel any ongoing data task before starting a new one
        currentDataTask?.cancel()
        
        // Store the new data task reference
        currentDataTask = gasStationService.fetchGasStations(area: area, limit: 10) { [weak self] stations in
            DispatchQueue.main.async {
                // Filter out stations with no gas prices
                self?.gasStations = stations.filter { !$0.gasPrices!.isEmpty  }
                completion()
            }
        }
    }
    
    func addFavorite(station: GasStation) {
        if !favoriteStations.contains(where: { $0.id == station.id }) {
            favoriteStations.append(station)
        }
    }
    
    func removeFavorite(station: GasStation) {
        favoriteStations.removeAll { $0.id == station.id }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.fetchGasStations(for: "\(location.coordinate.latitude), \(location.coordinate.longitude)") {
                // Completion block if needed
            }
        }
    }
}
