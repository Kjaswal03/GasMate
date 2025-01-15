//
//  DetailView.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/6/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let gasStation: GasStation?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let station = gasStation {
                HStack {
                    Image(systemName: "fuelpump.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(station.title)
                            .font(.largeTitle)
                        Text("Open 24/7") // Update this based on actual data if available
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                
                Text("Address: \(station.address)")
                    .padding([.leading, .trailing])
                
                if let prices = station.gasPrices {
                    Text("Prices:")
                        .font(.headline)
                        .padding([.leading, .top, .trailing])
                    
                    HStack {
                        VStack(alignment: .leading) {
                            ForEach(prices, id: \.gasType) { price in
                                Text(price.gasType)
                            }
                        }
                        .padding([.leading, .trailing])
                        
                        VStack(alignment: .leading) {
                            ForEach(prices, id: \.gasType) { price in
                                Text("\(price.currency) \(price.price, specifier: "%.2f")")
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                } else {
                    Text("No price information available")
                        .padding([.leading, .trailing])
                }
                
                if let website = station.website {
                    Text("Website: \(website)")
                        .padding([.leading, .trailing])
                }
                
                if let phone = station.phone {
                    Text("Phone: \(phone)")
                        .padding([.leading, .trailing])
                }
                
                Text("Total Score: \(station.totalScore ?? 0)")
                    .padding([.leading, .trailing])
                
                Text("Reviews Count: \(station.reviewsCount ?? 0)")
                    .padding([.leading, .trailing])
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if viewModel.favoriteStations.contains(where: { $0.id == station.id }) {
                            viewModel.removeFavorite(station: station)
                        } else {
                            viewModel.addFavorite(station: station)
                        }
                    }) {
                        Text(viewModel.favoriteStations.contains(where: { $0.id == station.id }) ? "Remove from Favorites" : "Add to Favorites")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(viewModel.favoriteStations.contains(where: { $0.id == station.id }) ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                Text("No gas station selected")
                    .padding()
            }
        }
        .navigationTitle("Details")
    }
}
