//
//  GasStation.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/7/24.
//

import Foundation
import CoreLocation

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

struct GasPrice: Decodable {
    let priceTag: String
    let updatedAt: String
    let unit: String
    let currency: String
    let price: Double
    let gasType: String
}

struct GasStation: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let address: String
    let website: String?
    let phone: String?
    let location: Location
    let gasPrices: [GasPrice]?
    
    // Additional fields from JSON
    let totalScore: Double?
    let rank: Int?
    let reviewsCount: Int?
    let isAdvertisement: Bool?
    let categoryName: String?
    let searchString: String?
    let url: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }
    
    var priceSummary: String {
        guard let prices = gasPrices, !prices.isEmpty else {
            return "No prices available"
        }
        return prices.map { "\($0.gasType): \($0.priceTag)" }.joined(separator: ", ")
    }
}

