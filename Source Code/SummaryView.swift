//
//  SummaryView.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/9/24.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Gas Station Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                
                summaryCard(title: "Total Number of Gas Stations", value: "\(viewModel.gasStations.count)", iconName: "number")
                
                if let averagePrices = calculateAveragePrices() {
                    summaryCard(title: "Average Prices", details: averagePrices.map { "\($0.key): \(String(format: "%.2f", $0.value)) USD" }.joined(separator: "\n"), iconName: "chart.bar")
                } else {
                    summaryCard(title: "Average Prices", value: "No data available", iconName: "chart.bar")
                }
                
                if let lowestPriceStations = findLowestPriceStations() {
                    summaryCard(title: "Lowest Prices", details: lowestPriceStations.compactMap { type, station in
                        if let price = station.gasPrices?.first(where: { $0.gasType == type })?.price {
                            return "\(type): \(station.title) - \(String(format: "%.2f", price)) USD"
                        }
                        return nil
                    }.joined(separator: "\n"), iconName: "arrow.down")
                } else {
                    summaryCard(title: "Lowest Prices", value: "No data available", iconName: "arrow.down")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Summary")
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
    
    private func summaryCard(title: String, value: String, iconName: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 3)
    }
    
    private func summaryCard(title: String, details: String, iconName: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 3)
    }
    
    private func calculateAveragePrices() -> [String: Double]? {
        var priceSums: [String: Double] = [:]
        var priceCounts: [String: Int] = [:]
        
        for station in viewModel.gasStations {
            if let prices = station.gasPrices {
                for price in prices {
                    if priceSums[price.gasType] != nil {
                        priceSums[price.gasType]! += price.price
                        priceCounts[price.gasType]! += 1
                    } else {
                        priceSums[price.gasType] = price.price
                        priceCounts[price.gasType] = 1
                    }
                }
            }
        }
        
        guard !priceSums.isEmpty else { return nil }
        
        var averagePrices: [String: Double] = [:]
        for (type, sum) in priceSums {
            if let count = priceCounts[type] {
                averagePrices[type] = sum / Double(count)
            }
        }
        
        return averagePrices
    }
    
    private func findLowestPriceStations() -> [String: GasStation]? {
        var lowestPrices: [String: (station: GasStation, price: Double)] = [:]
        
        for station in viewModel.gasStations {
            if let prices = station.gasPrices {
                for price in prices {
                    if let currentLowest = lowestPrices[price.gasType] {
                        if price.price < currentLowest.price {
                            lowestPrices[price.gasType] = (station, price.price)
                        }
                    } else {
                        lowestPrices[price.gasType] = (station, price.price)
                    }
                }
            }
        }
        
        guard !lowestPrices.isEmpty else { return nil }
        
        var lowestPriceStations: [String: GasStation] = [:]
        for (type, info) in lowestPrices {
            lowestPriceStations[type] = info.station
        }
        
        return lowestPriceStations
    }
}
